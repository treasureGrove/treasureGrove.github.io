#ifndef _TA_SPEEDTREE_GAMES_WIND_HLSLI_
#define _TA_SPEEDTREE_GAMES_WIND_HLSLI_

//===========================================================================================================
// SpeedTree-style "Games" Wind (shared by branch / frond / bush foliage materials)
//
// Three layers, applied largest -> smallest, each preserving segment length (bend, not stretch):
//   (1) Shared  : whole-canopy low-frequency bend & sway   (height-weighted)
//   (2) Branch  : per-branch mid-scale sway                 (vertex color G weighted)
//   (3) Ripple  : per-leaf high-frequency flutter + shimmer (vertex color R weighted, frond/leaf only)
//
// Requirements the INCLUDING material must provide BEFORE including this header:
//   - CHAOS_DECLARE_TEX2D(noise_map)   : tileable grain noise texture
//   - float3 SafeNormalize(float3)     : safe normalize helper
//   - PI                               : the constant
//   - Parameter declarations (float branch_*, shared_*, and ripple_* if enable_ripple is used).
//     Each material declares the params it needs + matching //#param panel entries. Branch-only
//     materials may omit the ripple_* params as long as they never pass enable_ripple = true.
//
// Vertex color convention (shared across all foliage materials):
//   R = inner->outer gradient (leaf ripple weight)
//   G = per-branch noise base * root->tip gradient (branch weight + per-branch phase)
//   B = per-leaf random (ripple desync)
//   A = AO
//===========================================================================================================

//-----------------------------------------------------------------------------------------------------------
// Shared parameter declarations (one identical set for every foliage material -> branches & leaves sync).
// Each material still needs matching //#param panel entries so the engine binds/exposes these values.
// Ripple params are only read when FOLIAGE_ENABLE_RIPPLE is defined, but are declared for all so the
// constant-buffer layout stays identical across materials.
//
// WHERE THINGS LIVE:
//   - float declarations + wind functions : HERE (this shared header).
//   - //#param panel entries + //#group    : in each MATERIAL (.hlsl), because panel layout / group index
//                                            / default values are per-material. To tweak a parameter's
//                                            range or default, edit the material, not this header.
//-----------------------------------------------------------------------------------------------------------
// Shared layer
float shared_enabled;
float shared_bend;
float shared_oscillation;
float shared_speed;
float scene_shared_wind_influence;
// Radial z-grounding envelope (SHARED by Shared + Branch layers):
//   z_granding_origin  : dead-zone height fraction. Below this, wind = 0. (0 = from root, 0.09 = bottom 9% locked).
//   z_granding_falloff : cantilever exponent (2 = classic parabolic; higher = top-heavy, lower = stiffer).
//   foliage_height     : mesh local Z extent (SpeedTree meshes typically span Z=[0,1] → set to 1.0).
//                         World-space tree height = foliage_height × instance_scale.z, so scaling auto-applies.
float z_granding_origin;
float z_granding_falloff;
float shared_intensity;
float foliage_height;

// Branch layer
float branch_enabled;
float branch_bend_amount;
float branch_sway_amount;
float scene_branch_wind_influence;
float branch_intensity;

// Ripple layer (only used by leaf materials that #define FOLIAGE_ENABLE_RIPPLE)
float ripple_enabled;
float ripple_speed;
float ripple_directional;
float ripple_planar;
float ripple_independence;
float ripple_flexibility;
float ripple_shimmer;
float ripple_intensity;
float scene_ripple_wind_influence;
float scene_ripple_deform_dir;
float scene_ripple_deform_planar;
float scene_ripple_speed_response;

//-----------------------------------------------------------------------------------------------------------
// (1) Shared / Global Motion  -- CANTILEVER BEND via ROTATION about the root. The whole tree tips over in
// the wind like a flexible rod anchored at the base. This is the real SpeedTree "global" feel: the trunk
// itself leans from low down and the entire canopy rides along -- NOT "trunk frozen, only branch tips flail".
//
// Implementation: rotate relative_position about a HORIZONTAL axis (perpendicular to the wind) that passes
// through the tree root. The rotation ANGLE grows with height (parabolic h^2 cantilever profile), so:
//   - the base (h~0) barely rotates -> stays anchored,
//   - the top (h~1) rotates the most -> the trunk bows over and drags the branches with it.
// Rotation is LENGTH-PRESERVING by construction (no stretch / torn faces, unlike a raw xy push).
//
//   canopy_height       : instance_scale.z = real tree height (world units).
//   z_granding_origin   : dead-zone height fraction. Below this, shared wind = 0.
//   z_granding_falloff  : cantilever exponent (2 = classic parabolic beam; higher = top-heavy, lower = stiffer top).
//   foliage_height      : mesh local Z extent (× instance_scale.z = world tree height).
//   shared_bend         : steady lean angle scale    shared_oscillation : sway angle over time
//   shared_intensity    : overall master strength.
//-----------------------------------------------------------------------------------------------------------
float3 computeSharedMotion(float3 relative_position, float instance_scale_z, float3 wind_dir, float global_wind01, float random_value, float time) {
    // Height fraction (0 at root, 1 at top). foliage_height × instance_scale_z = actual world-space height.
    float actual_height = max(foliage_height * instance_scale_z, 0.0001);
    float h = saturate(relative_position.z / actual_height);
    if (h <= 0.0) return float3(0.0, 0.0, 0.0); // root anchored

    // Remap height: dead zone below z_granding_origin → 0, top → 1 (LINEAR).
    // max() prevents division by zero when origin = 1.0 (fully dead → bend_shape = 0).
    // pow() then shapes the cantilever curve — this already gives natural ease-in at the base
    // since pow(small_value, falloff) ≈ 0 near the boundary.
    float hb = saturate((h - z_granding_origin) / max(1.0 - z_granding_origin, 0.0001));
    float bend_shape = pow(hb, z_granding_falloff);

    // Global wind coupling.
    float wind_factor = lerp(0.0, global_wind01, scene_shared_wind_influence);
    float wind = wind_factor * shared_intensity;

    // Per-instance noise: speed ±15%, amplitude ±15%, phase offset. Same seeds as Branch for sync.
    float speed_var = shared_speed * (0.85 + frac(random_value * 127.1) * 0.3);
    float amp_var   = 0.85 + frac(random_value * 311.7) * 0.3;
    // Perturb sine phase with subtle noise to break perfect periodicity while keeping
    // a natural wind-like oscillation. All vertices share the same sway → branches stay coherent.
    float sway_phase = time * speed_var + random_value * 6.2831853;
    float noise_perturb = CHAOS_SAMPLE_TEX2D_LOD(noise_map, float2(sway_phase * 0.07, sway_phase * 0.053 + 0.4), 0.0).r;
    float sway = sin(sway_phase + noise_perturb * 0.5);
    float bend_angle = (shared_bend + shared_oscillation * sway) * wind * bend_shape * 0.02 * amp_var;

    // Rotation axis: horizontal, perpendicular to the wind direction, through the root (0,0,0 in local).
    // Rotating about this tips the tree along the wind. axis = up x wind_dir (both roughly horizontal here).
    float3 wnd = normalize(float3(wind_dir.x, wind_dir.y, 0.0) + float3(1e-5, 0.0, 0.0));
    float3 axis = normalize(cross(wnd, float3(0.0, 0.0, 1.0))); // horizontal, bends WITH wind (away from root)

    // RotateAboutAxis returns the OFFSET (rotated - original). Pivot = root (local origin) so the base
    // stays put and the offset grows naturally toward the top -> length-preserving cantilever bend.
    float3 offset = RotateAboutAxis(float4(axis, bend_angle), float3(0.0, 0.0, 0.0), relative_position);
    return offset;
}

//-----------------------------------------------------------------------------------------------------------
// (2) Branch Motion  -- Ported from the original foliage_frond_vertex_color WindLowMotion.
// Two components, same as the old system: a Z-axis TWIST (branch swirl) + a horizontal SWAY (branch bend),
// combined and weighted by vertex color G (root→tip gradient) and z-grounding.
//
//   branch_bend_amount : twist intensity (maps to old branch_motion_twist_multiplier)
//   branch_sway_amount : sway intensity (maps to old root_motion_multiplier)
//   branch_intensity   : overall master (maps to old global_wind_intensity)
//   scene_branch_wind_influence : global-wind influence 0..1
//   branch_g           : vertex color G (root 0 -> tip 1).
//-----------------------------------------------------------------------------------------------------------
float3 computeBranchMotion(float3 relative_position, float instance_scale_z, float branch_g, float3 wind_dir, float3 wind_dir_nor, float global_wind01, float random_value, float time) {
    // G-channel weight via Crytek fBF curve. G=0 at root → fBF=0 → no motion; G=1 at tip → fBF≈2.25.
    float g = saturate(branch_g);
    float fBF = g;
    fBF += 1.0;
    fBF *= fBF;
    fBF = fBF * fBF - fBF;

    // Wind intensity.
    float wind_factor = lerp(0.0, global_wind01, scene_branch_wind_influence);
    float wind = wind_factor * branch_intensity;

    // Per-instance noise: same seeds as Shared so speed/phase stay in sync within one tree.
    float speed_var = shared_speed * (0.85 + frac(random_value * 127.1) * 0.3);
    float amp_var   = 0.85 + frac(random_value * 311.7) * 0.3;

    // Beat-pattern time function, with per-instance phase offset.
    float phase = time * speed_var + random_value * 6.2831853;
    float beat = (cos(phase * 1.257) * sin(phase * 0.628) + 2.0) * (0.25 / 360.0);

    // --- (a) Branch twist: rotate about Z-axis, like old branch_motion_pos ---
    float twist_angle = wind * beat * branch_bend_amount * 2.0 * PI * 0.1 * amp_var;
    float3 twist_motion = RotateAboutAxis(float4(float3(0.0, 0.0, 1.0), twist_angle),
        float3(0.0, 0.0, 0.0), relative_position);

    // --- (b) Branch sway: rotate about a slowly-drifting horizontal axis, like old root_motion_pos ---
    float3 wdir_low = wind_dir_nor * float3(1.0, -1.0, 0.0);
    wdir_low = clamp(float3(wdir_low.yx + sin(phase * 0.3) * 0.25, 0.0), -1.0, 1.0);
    float sway_angle = wind * beat * branch_sway_amount * 2.0 * PI * amp_var;
    float3 sway_motion = RotateAboutAxis(float4(wdir_low, sway_angle),
        float3(0.0, 0.0, 0.0), relative_position);

    float3 motion = twist_motion + sway_motion;

    // Z-gradient (from old system): length-based height fraction with dead-zone subtract.
    float actual_height = max(foliage_height * instance_scale_z, 0.0001);
    float z_gradient = length(relative_position) / actual_height;
    z_gradient = saturate(saturate(z_gradient) - z_granding_origin);

    return motion * fBF * z_gradient;
}
//-----------------------------------------------------------------------------------------------------------
// (3) Leaf Ripple  -- per-leaf high-frequency flutter (Directional + Planar) + shimmer normal perturb.
//   world_pos     : vertex world position
//   instance_pos  : instance pivot
//   ripple_weight : vertex color R (inner->outer gradient)
//   leaf_random   : vertex color B (per-leaf random)
//   out_shimmer_delta : normal perturbation to add for lighting shimmer
//-----------------------------------------------------------------------------------------------------------
#ifdef FOLIAGE_ENABLE_RIPPLE
float3 computeRippleWind(float3 world_pos, float3 instance_pos, float3 wind_dir, float ripple_weight, float leaf_random, float global_wind01, float time, out float3 out_shimmer_delta) {
    out_shimmer_delta = float3(0.0, 0.0, 0.0);
    const float3 vUp = float3(0.0, 0.0, 1.0);

    // Modulate the noise-scroll speed with another layer of noise so the sampling
    // velocity is never constant. This prevents gradient-noise flat spots (where
    // the derivative ≈ 0) from causing a visible "pause" in flutter.
    // Wind-driven speed: stronger wind makes leaves flutter faster.
    float t_base = time * ripple_speed * lerp(1.0, global_wind01, scene_ripple_speed_response);
    float2 nuv_speed = float2(t_base * 0.05 + leaf_random, t_base * 0.037 + leaf_random * 0.3);
    float speed_mod = CHAOS_SAMPLE_TEX2D_LOD(noise_map, nuv_speed, 0.0).r;
    float t_ripple = t_base + leaf_random * 17.0 + speed_mod * 0.5;

    float3 noise_pos_a = instance_pos * ripple_independence
    + world_pos * ripple_independence
    + wind_dir * (ripple_flexibility * ripple_weight) + t_ripple;
    float3 noise_pos_b = instance_pos * ripple_independence
    + world_pos * ripple_independence
    + wind_dir * (ripple_flexibility * ripple_weight) + t_ripple * 1.3 + 0.5;
    float2 nuv_r_a = noise_pos_a.xy * 0.05 + noise_pos_a.z * 0.03;
    float2 nuv_r_b = noise_pos_b.xy * 0.05 + noise_pos_b.z * 0.03;
    float2 nuv_g_a = noise_pos_a.yx * 0.05 - noise_pos_a.z * 0.037 + 0.5;
    float2 nuv_g_b = noise_pos_b.yx * 0.05 - noise_pos_b.z * 0.037 + 0.5;
    float noise_r = (CHAOS_SAMPLE_TEX2D_LOD(noise_map, nuv_r_a, 0.0).r * 2.0 - 1.0) * 0.6
    + (CHAOS_SAMPLE_TEX2D_LOD(noise_map, nuv_r_b, 0.0).r * 2.0 - 1.0) * 0.4;
    float noise_g = (CHAOS_SAMPLE_TEX2D_LOD(noise_map, nuv_g_a, 0.0).r * 2.0 - 1.0) * 0.6
    + (CHAOS_SAMPLE_TEX2D_LOD(noise_map, nuv_g_b, 0.0).r * 2.0 - 1.0) * 0.4;

    // Negate wind_dir so ripple directional motion aligns with Shared/Branch layers.
    // Shared/Branch both effectively tip in the original (non-negated) wind direction;
    // Ripple must match that convention instead of opposing it.
    float3 motion = (-wind_dir) * ((noise_r + 0.25) * ripple_directional * scene_ripple_deform_dir)
    + vUp        * ((noise_g + 0.10) * ripple_planar    * scene_ripple_deform_planar);

    float wind_factor = lerp(0.0, global_wind01, scene_ripple_wind_influence);
    // Dampen overall ripple deformation so triangle faces don't become
    // visually obvious under strong displacement.
    motion *= ripple_weight * ripple_intensity * wind_factor * 0.75;

    out_shimmer_delta = -motion * ripple_shimmer;
    return motion;
}
#endif // FOLIAGE_ENABLE_RIPPLE

//-----------------------------------------------------------------------------------------------------------
// Convenience entry: apply Shared + Branch (+ optional Ripple) in the correct order.
// Order: Shared (canopy) -> Branch (per-branch) -> Ripple (per-leaf).
//   io_world_pos    : inout world position, updated in place
//   io_world_normal : inout world normal, perturbed by ripple shimmer
//   color           : vertex color (R/G/B used)
//   enable_ripple   : pass true for frond/leaf materials, false for pure branch materials
//-----------------------------------------------------------------------------------------------------------
void applyGamesWind(inout float3 io_world_pos, inout float3 io_world_normal, float3 instance_pos, float instance_scale_z,
    float3 wind_dir, float3 wind_dir_nor, float global_wind01, float random_value, float time, float4 color, bool enable_ripple) {
    // Save original position before wind so Ripple's noise sampling is independent
    // of Shared/Branch displacement — otherwise ripple visibly "pauses" at Shared's
    // sway extremes because the spatial term world_pos * ripple_independence stops moving.
    float3 windless_pos = io_world_pos;

    // (1) Shared
    if (shared_enabled > 0.5) {
        io_world_pos += computeSharedMotion(io_world_pos - instance_pos, instance_scale_z, wind_dir, global_wind01, random_value, time);
    }
    // (2) Branch
    if (branch_enabled > 0.5) {
        io_world_pos += computeBranchMotion(io_world_pos - instance_pos, instance_scale_z, color.g, wind_dir, wind_dir_nor, global_wind01, random_value, time);
    }
    // (3) Ripple (frond / leaf only)
#ifdef FOLIAGE_ENABLE_RIPPLE
    if (enable_ripple && ripple_enabled > 0.5) {
        float3 shimmer_delta;
        io_world_pos += computeRippleWind(windless_pos, instance_pos, wind_dir, color.r, color.b, global_wind01, time, shimmer_delta);
        io_world_normal = normalize(io_world_normal + shimmer_delta);
    }
#endif
}

#endif // _TA_SPEEDTREE_GAMES_WIND_HLSLI_
