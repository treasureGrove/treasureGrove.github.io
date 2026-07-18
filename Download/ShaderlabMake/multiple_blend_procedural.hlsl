//These options will remove in several months
//But you still need to copy and change these options for different materials
//#asset is_explicit = {true}
//#asset is_deferred = {true}
//#asset shading_mode = {opacue}

//RenderPipeline: deferred

//#category alpha_clip
//#option_default off
//#option off

//#category attribute_normal
//#option_default enable
//#option enable

//#category attribute_uv0
//#option_default enable
//#option enable

//#category attribute_color0
//#option_default enable
//#option enable

//#category attribute_world_clip_position
//#option_default enable
//#option enable

//#category mesh_type
//#option_default rigid
//#option rigid

//#category environment_light
//#option_default on
//#option on

//#category vertex_input_type
//#option_default standard
//#option standard

//#category z_detail_normal
//#option_default on
//#option off
//#option on

//#category z_terrain_blend
//#option_default off
//#option off
//#option on

//#category z_has_base_normal
//#option_default on
//#option off
//#option on

//#category z_rock_edge_wear
//#option_default on
//#option off
//#option on

//#category z_cavity_dirt
//#option_default on
//#option off
//#option on

//#category z_world_dirt
//#option_default on
//#option off
//#option on
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
// Properties
//#group BaseMaterial = {index(0)}
//#param float4 base_tint = {default(1.0, 1.0, 1.0, 1.0), group(BaseMaterial), index(0)};
//#param float base_saturation = {min(0.0), max(10.0), default(1), group(BaseMaterial), index(2)};
//#param float base_contrast = {min(0.0), max(10.0), default(1), group(BaseMaterial), index(3)};
//#param float base_brightness = {min(0.0), max(10.0), default(1), group(BaseMaterial), index(4)};
//#param float normal_intensity = {min(0.0), max(2.0), default(1), group(BaseMaterial), index(5)};
//#param float roughness_intensity = {min(0.0), max(10.0), default(1), group(BaseMaterial), index(7)};
//#param float ao_intensity = {min(0.0), max(5.0), default(1), group(BaseMaterial), index(8)};
//#param float ao_constraint = {min(0.0), max(1.0), default(0.5), group(BaseMaterial), index(9)};
//#param float specular_intensity = {min(0.0), max(5.0), default(1), group(BaseMaterial), index(10)};
//#param float base_uv_scale = {min(0.0), max(20.0), default(1), group(BaseMaterial), index(11)};
//#param float base_weight = {min(0.0), max(1.0), default(1), group(BaseMaterial), index(12)};
//#param float rock_blend_noise_scale = {min(0.0), max(100.0), default(0.005), group(BaseMaterial), index(20)};
//#param float rock_blend_noise_strength = {min(0.0), max(10.0), default(0.25), group(BaseMaterial), index(21)};
//#param float rock_blend_contrast = {min(0.1), max(10.0), default(1.2), group(BaseMaterial), index(22)};
//#param float rock_blend_softness = {min(0.0), max(0.5), default(0.08), group(BaseMaterial), index(23)};
//#param float detail_uv_scale = {min(0.0), max(1000.0), default(1), group(BaseMaterial), index(24)};
//#param float detail_normal_intensity = {min(0.0), max(10.0), default(1), group(BaseMaterial), index(25)};
//#param sampler2D base_color_opacity_map = {default(flat_white_d), group(BaseMaterial), index(12)};
//#param sampler2D base_normal_map = {default(_project/textures/default/flat_n_bc5.texture.ast), group(BaseMaterial), index(13)};
//#param sampler2D base_nor_map = {default(_project/textures/default/flat_n_bc5.texture.ast), group(BaseMaterial), index(14)};
//#param sampler2D detail_map = {default(flat_white_d), group(BaseMaterial), index(15)};

//#group BlendMaterial_1 = {index(1)}
//#param float4 rock_tint_1 = {default(1.0, 1.0, 1.0, 1.0), group(BlendMaterial_1), index(0)};
//#param float rock_saturation_1 = {min(0.0), max(10.0), default(1), group(BlendMaterial_1), index(2)};
//#param float rock_contrast_1 = {min(0.0), max(10.0), default(1), group(BlendMaterial_1), index(3)};
//#param float rock_brightness_1 = {min(0.0), max(10.0), default(1), group(BlendMaterial_1), index(4)};
//#param float rock_normal_intensity_1 = {min(0.0), max(2.0), default(1), group(BlendMaterial_1), index(5)};
//#param float rock_roughness_intensity_1 = {min(0.0), max(10.0), default(1), group(BlendMaterial_1), index(7)};
//#param float rock_uv_scale_1 = {min(0.0), max(20.0), default(1), group(BlendMaterial_1), index(8)};
//#param float rock_uv_rotation_1 = {min(0.0), max(360), default(0), group(BlendMaterial_1), index(9) };
//#param float rock_1_weight = {min(0.0), max(1.0), default(1), group(BlendMaterial_1), index(10) };
//#param sampler2D rock_color_map_1 = {default(flat_white_d), group(BlendMaterial_1), index(- 1)};
//#param sampler2D rock_nor_map_1 = {default(_project/textures/default/flat_n_bc5.texture.ast), group(BlendMaterial_1), index(- 2)};

//#group BlendMaterial_2 = {index(2)}
//#param float4 rock_tint_2 = {default(1.0, 1.0, 1.0, 1.0), group(BlendMaterial_2), index(0)};
//#param float rock_saturation_2 = {min(0.0), max(10.0), default(1), group(BlendMaterial_2), index(2)};
//#param float rock_contrast_2 = {min(0.0), max(10.0), default(1), group(BlendMaterial_2), index(3)};
//#param float rock_brightness_2 = {min(0.0), max(10.0), default(1), group(BlendMaterial_2), index(4)};
//#param float rock_normal_intensity_2 = {min(0.0), max(2.0), default(1), group(BlendMaterial_2), index(5)};
//#param float rock_roughness_intensity_2 = {min(0.0), max(10.0), default(1), group(BlendMaterial_2), index(7)};
//#param float rock_uv_scale_2 = {min(0.0), max(20.0), default(1), group(BlendMaterial_2), index(8)};
//#param float rock_uv_rotation_2 = {min(0.0), max(360), default(0), group(BlendMaterial_2), index(9) };
//#param float rock_2_weight = {min(0.0), max(1.0), default(1), group(BlendMaterial_2), index(10) };
//#param sampler2D rock_color_map_2 = {default(flat_white_d), group(BlendMaterial_2), index(- 1)};
//#param sampler2D rock_nor_map_2 = {default(_project/textures/default/flat_n_bc5.texture.ast), group(BlendMaterial_2), index(- 2)};

//#group RockEdgeWear = {index(3)}
//#param float edge_sharpness = {min(0.05), max(5.0), default(0.5), group(RockEdgeWear), index(0)};
//#param float edge_amount = {min(0.0), max(1.0), default(0.5), group(RockEdgeWear), index(1)};
//#param float edge_softness = {min(0.0), max(1.0), default(0.3), group(RockEdgeWear), index(2)};
//#param float edge_breakup = {min(0.0), max(1.0), default(0.4), group(RockEdgeWear), index(3)};
//#param float edge_top_bias = {min(0.0), max(1.0), default(0.3), group(RockEdgeWear), index(4)};
//#param float4 edge_color = {default(1.5, 1.5, 1.5, 1.0), group(RockEdgeWear), index(5)};
//#param float edge_roughness = {min(0.0), max(1.0), default(0.2), group(RockEdgeWear), index(6)};
//#param sampler2D edge_grunge_map = {default(flat_white_d), group(RockEdgeWear), index(- 1)};

//#group CavityDirt = {index(4)}
//#param float dirt_sharpness = {min(0.05), max(5.0), default(0.5), group(CavityDirt), index(0)};
//#param float dirt_amount = {min(0.0), max(1.0), default(0.4), group(CavityDirt), index(1)};
//#param float dirt_top_bias = {min(0.0), max(1.0), default(0.3), group(CavityDirt), index(2)};
//#param float4 dirt_color = {default(0.25, 0.22, 0.18, 1.0), group(CavityDirt), index(3)};
//#param float dirt_roughness = {min(0.0), max(1.0), default(0.15), group(CavityDirt), index(4)};
//#param sampler2D dirt_map = {default(flat_white_d), group(CavityDirt), index(- 1)};

//#group WorldDirt = {index(5)}
//#param float4 world_dirt_color = {default(0.3, 0.28, 0.22, 1.0), group(WorldDirt), index(0)};
//#param float world_dirt_contrast = {min(0.0), max(10.0), default(1.0), group(WorldDirt), index(1)};
//#param float world_dirt_tiling = {min(0.001), max(1.0), default(0.01), group(WorldDirt), index(2)};
//#param float world_dirt_roughness = {min(0.0), max(1.0), default(0.3), group(WorldDirt), index(3)};
//#param sampler2D world_dirt_noise_map = {default(flat_white_d), group(WorldDirt), index(- 1)};

//#group TerrainBlend = {index(10)}
//#param float terrain_blend_range = {min(0.1), max(20.0), default(1.0), group(TerrainBlend), index(0)};
//#param float terrain_blend_contrast = {min(0), max(20.0), default(0.5), group(TerrainBlend), index(1)};
//#param float height_add = {min(- 20.0), max(20.0), default(0.2), group(TerrainBlend), index(2)};
//#param float noise_intense = {min(- 1.0), max(1.0), default(0.0), group(TerrainBlend), index(3)};
//#param float4 terrain_map_mutiplier = {default(1.0, 1.0, 1.0, 1.0), group(TerrainBlend), index(-1)};
//#param float terrain_map_roughness_add = {min(- 1.0), max(1.0), default(0.0), group(TerrainBlend), index(-2)};
//#param float terrain_map_metallic_add = {min(- 1.0), max(1.0), default(0.0), group(TerrainBlend), index(-3)};
//#param float terrain_map_normal_intensity = {min(0.0), max(10.0), default(1.0), group(TerrainBlend), index(-4)};
//#param sampler2D noise_map = {default(flat_white_d), group(TerrainBlend), index(-5)};

// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

#include "core/gbuffer/gbuffer_mr.hlsli"

#if defined(SHADING_PIPELINE_FORWARD)
#include "core/pixel_shader_factory/forward_shading_common.hlsli"
#include "core/common/reconstruct_position.hlsli"
#include "core/light/surface_data_common.hlsli"
#include "core/light/light_common.hlsli"
#include "core/light/environment_lighting/environment_lighting.hlsli"
#include "core/atmosphere/atmosphere_common.hlsli"
#endif

#include "core/material/material_template.hlsli"
#include "core/pixel_shader_factory/pixel_inoutput.hlsli"
#include "core/material/material_surface_convert.hlsli"
#include "core/terrain/common.hlsli"
#include "core/terrain/common_def.hlsli"
#include "core/terrain/common_func.hlsli"
#include "core/terrain/compute_common.hlsli"
#include "TA/core/color_adjustments.hlsli"
#include "TA/core/uv_adjustments.hlsli"
#include "TA/core/terrain_blend.hlsli"

#ifdef ALPHA_CLIP_ON
float alpha_clip_value;
#endif

//#region MaterialParameters

CHAOS_DECLARE_TEX2D(base_color_opacity_map);
CHAOS_DECLARE_TEX2D(base_normal_map);
CHAOS_DECLARE_TEX2D(base_nor_map);
CHAOS_DECLARE_TEX2D(detail_map);

CHAOS_DECLARE_TEX2D(rock_color_map_1);
CHAOS_DECLARE_TEX2D(rock_nor_map_1);

CHAOS_DECLARE_TEX2D(rock_color_map_2);
CHAOS_DECLARE_TEX2D(rock_nor_map_2);
CHAOS_DECLARE_TEX2D(edge_grunge_map);
CHAOS_DECLARE_TEX2D(dirt_map);
CHAOS_DECLARE_TEX2D(world_dirt_noise_map);
//#endregion

float4 base_tint;
float base_saturation;
float base_contrast;
float base_brightness;
float base_uv_scale;
float normal_intensity;
float roughness_intensity;
float ao_intensity;
float ao_constraint;
float alpha_clip;
float specular_intensity;
float base_weight;
float detail_uv_scale;
float detail_normal_intensity;

float4 rock_tint_1;
float rock_saturation_1;
float rock_contrast_1;
float rock_brightness_1;
float rock_uv_scale_1;
float rock_uv_rotation_1;
float rock_normal_intensity_1;
float rock_roughness_intensity_1;
float rock_1_weight;

float4 rock_tint_2;
float rock_saturation_2;
float rock_contrast_2;
float rock_brightness_2;
float rock_uv_scale_2;
float rock_uv_rotation_2;
float rock_normal_intensity_2;
float rock_roughness_intensity_2;
float rock_2_weight;

float rock_blend_noise_scale;
float rock_blend_noise_strength;
float rock_blend_contrast;
float rock_blend_softness;

// Rock edge wear — 7 knobs.
float edge_sharpness;
float edge_amount;
float edge_softness;
float edge_breakup;
float edge_top_bias;
float4 edge_color;
float edge_roughness;

// Cavity dirt — 5 knobs.
float dirt_sharpness;
float dirt_amount;
float dirt_top_bias;
float4 dirt_color;
float dirt_roughness;

// World dirt overlay — 4 knobs.
float4 world_dirt_color;
float world_dirt_contrast;
float world_dirt_tiling;
float world_dirt_roughness;

//#endregion

// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

#if defined(PIXEL_SHADER)

static const float BASE_NORMAL_WEIGHT_FOR_CURVATURE = 0.4;
static const float AO_PROTECT                       = 0.5;
static const float WEAR_NORMAL_FLATTEN              = 0.6;
static const float DIRT_AO_DARKEN                   = 0.85;
static const float GRUNGE_SCALE_FACTOR              = 3.0;
static const float WORLD_DIRT_NOISE_SCALE           = 5.0;

float GetNormalSeamMask(
    float3 world_normal,
    float3 world_position,
    float seam_scale,
    float seam_power,
    float convex_weight,
    float threshold) {
    float3 shading_normal = normalize(world_normal);

    float3 dpdx = ddx(world_position);
    float3 dpdy = ddy(world_position);

    float3 dndx = ddx(shading_normal);
    float3 dndy = ddy(shading_normal);

    float world_span = max(length(dpdx), length(dpdy));
    float normal_span = length(dndx) + length(dndy);

    float derivative_edge = normal_span / max(world_span, 1e-5);
    derivative_edge = saturate(max(0.0, derivative_edge - threshold) * seam_scale);
    derivative_edge = pow(derivative_edge, max(seam_power, 1e-5));

    float3 geometry_normal = normalize(cross(dpdx, dpdy));

    float convexity = saturate(1.0 - dot(geometry_normal, shading_normal));
    convexity = pow(convexity, max(seam_power, 1e-5));

    return saturate(max(derivative_edge, convexity * convex_weight));
}

float GetNormalSeamMask(float3 world_normal, float3 world_position) {
    return GetNormalSeamMask(world_normal, world_position, 8.0, 2.0, 0.35, 0.02);
}

float ComputeScreenSpaceCurvature(float3 world_normal, float3 world_position, float sharpness) {
    float3 n = normalize(world_normal);

    float3 dndx = ddx(n);
    float3 dndy = ddy(n);

    float3 dpdx = ddx(world_position);
    float3 dpdy = ddy(world_position);

    float world_step = max(length(dpdx) + length(dpdy), 1e-5);
    float raw = (length(dndx) + length(dndy)) / world_step;

    float curvature = 1.0 - exp(-raw * sharpness);
    return pow(curvature, 1.5);
}

float ValueNoise3D(float3 p) {
    float3 ip = floor(p);
    float3 fp = frac(p);

    float3 u = fp * fp * (3.0 - 2.0 * fp);

    float n000 = Hash31(ip + float3(0.0, 0.0, 0.0));
    float n100 = Hash31(ip + float3(1.0, 0.0, 0.0));
    float n010 = Hash31(ip + float3(0.0, 1.0, 0.0));
    float n110 = Hash31(ip + float3(1.0, 1.0, 0.0));
    float n001 = Hash31(ip + float3(0.0, 0.0, 1.0));
    float n101 = Hash31(ip + float3(1.0, 0.0, 1.0));
    float n011 = Hash31(ip + float3(0.0, 1.0, 1.0));
    float n111 = Hash31(ip + float3(1.0, 1.0, 1.0));

    float nx00 = lerp(n000, n100, u.x);
    float nx10 = lerp(n010, n110, u.x);
    float nx01 = lerp(n001, n101, u.x);
    float nx11 = lerp(n011, n111, u.x);

    float nxy0 = lerp(nx00, nx10, u.y);
    float nxy1 = lerp(nx01, nx11, u.y);

    return lerp(nxy0, nxy1, u.z);
}

float FBMNoise3D(float3 p) {
    float sum = 0.0;
    float amp = 0.5;

    sum += ValueNoise3D(p) * amp;
    p = p * 2.03 + float3(17.1, 9.2, 31.7);
    amp *= 0.5;

    sum += ValueNoise3D(p) * amp;
    p = p * 2.01 + float3(3.4, 27.6, 11.3);
    amp *= 0.5;

    sum += ValueNoise3D(p) * amp;
    p = p * 2.07 + float3(21.9, 7.8, 4.6);
    amp *= 0.5;

    sum += ValueNoise3D(p) * amp;

    return sum;
}

float ComputeGrungeField(float3 world_pos, float scale) {
    float3 p = world_pos * scale;

    float3 warp_pos = p * 1.7;
    float3 warp = float3(
        FBMNoise3D(warp_pos + float3(11.2, 5.3, 17.7)),
        FBMNoise3D(warp_pos + float3(23.1, 19.8, 3.4)),
        FBMNoise3D(warp_pos + float3(7.5, 29.7, 13.6)));
    p += (warp - 0.5) * 0.8;

    float n = FBMNoise3D(p);
    float ridge = 1.0 - abs(n * 2.0 - 1.0);
    return pow(saturate(ridge), 2.0);
}

float ComputeRockEdgeWearMask(
    float3 world_pos,
    float3 curvature_normal_ws,
    float3 geometry_normal_ws,
    float ao_value) {
    float curvature = ComputeScreenSpaceCurvature(
        curvature_normal_ws,
        world_pos,
        max(edge_sharpness, 0.01));

    // Procedural grunge as base break-up.
    float grunge = ComputeGrungeField(world_pos, edge_sharpness * GRUNGE_SCALE_FACTOR);

    float grunge_offset = (grunge - 0.5) * saturate(edge_breakup) * 0.8;
    curvature = saturate(curvature + grunge_offset);

    float threshold = lerp(0.95, 0.05, saturate(edge_amount));
    float softness  = lerp(0.02, 0.35, saturate(edge_softness));
    float mask = smoothstep(threshold - softness, threshold + softness, curvature);

    float topness = saturate(geometry_normal_ws.z * 0.5 + 0.5);
    float top_curve = pow(topness, saturate(edge_top_bias) * 6.0);
    mask *= top_curve;

    float ao_mod = lerp(1.0, saturate(ao_value), AO_PROTECT);
    mask *= ao_mod;

    return saturate(mask);
}

// Cavity dirt mask — curvature-only (no AO texture dependence).
//
// Concavity via the trick: (1 - curvature) * curvature peaks at 0.5,
// so flat surfaces (curv~0) and sharp edges (curv~1) both drop out.
// Only "medium curvature" areas — real concave crevices — pass through.
// Scale by 4 so the peak maps to 1.0.
float ComputeCavityDirtMask(
    float3 world_pos,
    float3 curvature_normal_ws,
    float3 geometry_normal_ws) {
    float curvature = ComputeScreenSpaceCurvature(
        curvature_normal_ws,
        world_pos,
        max(dirt_sharpness, 0.01));

    float concavity = saturate((1.0 - curvature) * curvature * 4.0);

    // FBM break-up so dirt looks natural, not a uniform stripe.
    float dirt_noise = FBMNoise3D(world_pos * 1.5);
    float signal = concavity * lerp(0.6, 1.4, saturate(dirt_noise));

    float threshold = lerp(0.95, 0.05, saturate(dirt_amount));
    float mask = smoothstep(threshold - 0.15, threshold + 0.15, signal);

    // Gravity: down-faces keep a baseline of dust.
    float topness = saturate(geometry_normal_ws.z * 0.5 + 0.5);
    float top_curve = lerp(1.0, pow(topness, 3.0), saturate(dirt_top_bias));
    mask *= top_curve;

    return saturate(mask);
}

float assembleOpacityMaskDepthOnly(PixelParameters pixel_params) {
    return CHAOS_SAMPLE_TEX2D(base_color_opacity_map, pixel_params.uvs[0]).w;
}

void assembleMaterialParams(PixelParameters pixel_params, inout MaterialParameters material_params) {
    float3 worldPos = pixel_params.world_position.xyz;
    float3 worldNormal = pixel_params.world_normal.xyz;
    float2 uv = pixel_params.uvs[0];

    float3 geometry_normal_ws = normalize(worldNormal);

#if defined(Z_HAS_BASE_NORMAL_ON)
    float3 base_model_normal_ts = decodeNormalFromNormalMapValueBC5(
        CHAOS_SAMPLE_TEX2D(base_normal_map, uv));
    float3 base_model_normal_ws = normalize(mul(base_model_normal_ts, pixel_params.TBN));
#endif

    float3 curvature_normal_ws = geometry_normal_ws;
#if defined(Z_HAS_BASE_NORMAL_ON)
    curvature_normal_ws = normalize(lerp(
            geometry_normal_ws,
            base_model_normal_ws,
            BASE_NORMAL_WEIGHT_FOR_CURVATURE));
#endif

    float3 base_color = TriPlanarMappingThree(
        CHAOS_TEXTURE_2D(base_color_opacity_map),
        worldPos,
        worldNormal,
        base_uv_scale,
        0).rgb;
    float3 base_normal;
    float base_ao;
    float base_roughness;
    TriPlanarPackedNRMAORough(CHAOS_TEXTURE_2D(base_nor_map), worldPos, worldNormal, base_uv_scale, 0, normal_intensity, base_normal, base_ao, base_roughness);

    float3 rock_color_1 = TriPlanarMappingThree(
        CHAOS_TEXTURE_2D(rock_color_map_1),
        worldPos,
        worldNormal,
        rock_uv_scale_1,
        rock_uv_rotation_1).rgb;
    float3 rock_normal_1;
    float rock_ao_1;
    float rock_roughness_1;
    TriPlanarPackedNRMAORough(CHAOS_TEXTURE_2D(rock_nor_map_1), worldPos, worldNormal, rock_uv_scale_1, rock_uv_rotation_1, rock_normal_intensity_1, rock_normal_1, rock_ao_1, rock_roughness_1);

    float3 rock_color_2 = TriPlanarMappingThree(
        CHAOS_TEXTURE_2D(rock_color_map_2),
        worldPos,
        worldNormal,
        rock_uv_scale_2,
        rock_uv_rotation_2).rgb;

    float3 rock_normal_2;
    float rock_ao_2;
    float rock_roughness_2;
    TriPlanarPackedNRMAORough(CHAOS_TEXTURE_2D(rock_nor_map_2), worldPos, worldNormal, rock_uv_scale_2, rock_uv_rotation_2, rock_normal_intensity_2, rock_normal_2, rock_ao_2, rock_roughness_2);

    base_color *= base_tint;
    base_color = Desaturation(base_color, 1 - base_saturation);
    base_color = Brightness(base_color, base_brightness);
    base_color = LuminanceContrast(base_color, base_contrast);

    rock_color_1 *= rock_tint_1;
    rock_color_1 = Desaturation(rock_color_1, 1 - rock_saturation_1);
    rock_color_1 = Brightness(rock_color_1, rock_brightness_1);
    rock_color_1 = LuminanceContrast(rock_color_1, rock_contrast_1);

    rock_color_2 *= rock_tint_2;
    rock_color_2 = Desaturation(rock_color_2, 1 - rock_saturation_2);
    rock_color_2 = Brightness(rock_color_2, rock_brightness_2);
    rock_color_2 = LuminanceContrast(rock_color_2, rock_contrast_2);

    float3 rock_weights = float3(base_weight, rock_1_weight, rock_2_weight);
    rock_weights = GetRockBlendWeights(worldPos,rock_weights,rock_blend_noise_scale,rock_blend_noise_strength,rock_blend_contrast,rock_blend_softness);

    float3 final_base_color = base_color * rock_weights.x + rock_color_1 * rock_weights.y + rock_color_2 * rock_weights.z;
    float3 final_normal = base_normal * rock_weights.x + rock_normal_1 * rock_weights.y + rock_normal_2 * rock_weights.z;
    float final_roughness = base_roughness * rock_weights.x + rock_roughness_1 * rock_weights.y + rock_roughness_2 * rock_weights.z;
    float final_ao = base_ao * rock_weights.x + rock_ao_1 * rock_weights.y + rock_ao_2 * rock_weights.z;
    float final_metallic = 0;

#if defined(Z_ROCK_EDGE_WEAR_ON)
    float edge_mask = ComputeRockEdgeWearMask(
        worldPos,
        curvature_normal_ws,
        geometry_normal_ws,
        final_ao);

    // Edge grunge texture: world-space triplanar, used only for color, not mask.
    float3 edge_grunge_color = TriPlanarMappingThree(
        CHAOS_TEXTURE_2D(edge_grunge_map),
        worldPos,
        geometry_normal_ws,
        edge_sharpness * GRUNGE_SCALE_FACTOR,
        0).rgb;

    final_base_color = lerp(final_base_color,
        final_base_color * edge_color.rgb * edge_grunge_color,
        edge_mask);
    final_roughness  = saturate(final_roughness + edge_roughness * edge_mask);
    final_normal     = normalize(lerp(final_normal,
            float3(0.0, 0.0, 1.0),
            edge_mask * WEAR_NORMAL_FLATTEN));
#endif

#if defined(Z_CAVITY_DIRT_ON)
    float dirt_mask = ComputeCavityDirtMask(
        worldPos,
        curvature_normal_ws,
        geometry_normal_ws);

#if defined(Z_ROCK_EDGE_WEAR_ON)
    dirt_mask = saturate(dirt_mask * (1.0 - edge_mask));
#endif

    // Cavity dirt texture: world-space triplanar, used only for color, not mask.
    float3 dirt_tex_color = TriPlanarMappingThree(
        CHAOS_TEXTURE_2D(dirt_map),
        worldPos,
        geometry_normal_ws,
        dirt_sharpness * 2.0,
        0).rgb;

    final_base_color = lerp(final_base_color, dirt_color.rgb * dirt_tex_color, dirt_mask);
    final_roughness  = saturate(final_roughness + dirt_roughness * dirt_mask);
    final_ao         = saturate(final_ao * lerp(1.0, DIRT_AO_DARKEN, dirt_mask));
#endif

#ifndef SHADING_PATH_MOBILE
#if defined(Z_TERRAIN_BLEND_ON)
    ApplyTerrainBlend(worldPos,worldNormal,final_base_color,final_normal,final_roughness,final_metallic);
#endif
#endif

#if defined(Z_HAS_BASE_NORMAL_ON)
    final_normal = BlendAngleCorrectedNormals(base_model_normal_ts, final_normal);
    material_params.normal = normalize(mul(final_normal, pixel_params.TBN));
#else
    material_params.normal = normalize(mul(final_normal, pixel_params.TBN));
#endif

#if defined(Z_DETAIL_NOMRAL_ON)
    float3 detail_normal_ts = decodeNormalFromNormalMapValueBC5(
        CHAOS_SAMPLE_TEX2D(detail_map, uv * detail_uv_scale));
    material_params.normal = BlendAngleCorrectedNormals(
        detail_normal_ts * detail_normal_intensity,
        material_params.normal);
#endif

#if defined(Z_WORLD_DIRT_ON)
    // Sample noise mask (world-space triplanar) to drive the dirt overlay.
    float3 world_dirt_noise = TriPlanarMappingThree(
        CHAOS_TEXTURE_2D(world_dirt_noise_map),
        worldPos,
        geometry_normal_ws,
        world_dirt_tiling * WORLD_DIRT_NOISE_SCALE,
        0).rgb;
    float world_dirt_mask = Luminance(world_dirt_noise);

    // Apply contrast to sharpen/smooth the noise mask.
    world_dirt_mask = saturate((world_dirt_mask - 0.5) * world_dirt_contrast + 0.5);

    final_base_color = lerp(final_base_color,
        world_dirt_color.rgb,
        world_dirt_mask * world_dirt_color.a);
    final_roughness  = saturate(final_roughness + world_dirt_roughness * world_dirt_mask);
#endif

    material_params.metallic = 0;
    material_params.roughness = clamp(final_roughness, 0.0001f, 1.0f);
    material_params.base_color = final_base_color;
    material_params.ao = CheapContrast(final_ao * ao_intensity, ao_constraint);
    material_params.dielectric_specular_multiplier = specular_intensity;

#if defined(ALPHA_CLIP_ON)
    material_params.opacity_mask = base_map_clip - alpha_clip;
#endif
}

void customClip(PixelParameters pixel_params, MaterialParameters material_params) {
#ifdef ALPHA_CLIP_ON
    clip(material_params.opacity_mask - alpha_clip_value);
#endif

    return;
}

#endif // PIXEL_SHADER
