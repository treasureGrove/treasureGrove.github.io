//#asset is_explicit = {true}
//#asset is_deferred = {true}
//#asset shading_mode = {default_lit}

//#category alpha_clip
//#option_default on
//#option on
//#option off

//#category z_terrain_blend
//#option_default off
//#option off
//#option on

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

//#category attribute_custom_data
//#option_default enable
//#option enable

//#category mesh_type
//#option_default rigid
//#option rigid

//#category environment_light
//#option_default on
//#option off
//#option on

//#category vertex_input_type
//#option_default standard
//#option standard
//#option multi_draw_indirect
//#option nano
//#option instanced_mesh

//#category attribute_front_face
//#option_default enable
//#option enable
//#option disable

//-----------------------------------------------------------------------------------------------------------
// Properties

//#group Value = {index(0)}
//#param float alpha_clip_value = {min(0.0), max(1.0), default(0.333), group(Value), index(0)};
//#param float use_clip_lerp = {min(0.0), max(1.0), default(1.0), group(Value), index(1)};
//#param float clip_lerp_distance = {min(0.0), max(1000.0), default(80.0), group(Value), index(2)};
//#param float alpha_clip_value_far = {min(0.0), max(1.0), default(0.1), group(Value), index(3)};
//#param sampler2D noise_map={default(_engine/textures/default/Marcie_Grain_v3_128_M2_000.texture.ast), group(Value), index(4)};

//#group Albedo = {index(1)}
//#param sampler2D base_color_opacity_map ={default(grey), group(Albedo), index(0)};
//#param float4 base_color_multiplier = {default(1.0,1.0,1.0,1.0), group(Albedo), index(1)};
//#param float base_color_brightness = {min(0.0), max(10.0), default(1.0), group(Albedo), index(2)};
//#param float base_color_contrast = {min(0.0), max(10.0), default(1.0), group(Albedo), index(3)};
//#param float base_color_saturation = {min(0.0), max(10.0), default(1.0), group(Albedo), index(4)};

//#group Normal = {index(2)}
//#param sampler2D normal_roughness_map = {default(textures/default/flat_n_bc5.texture.ast), group(Normal), index(0)};
//#param float normal_view_dependency_factor = {min(0.0), max(10.0), default(1.0), group(Normal), index(1)};
//#param float normal_view_dependency_strength = {min(0.0), max(20.0), default(1.0), group(Normal), index(2)};
//#param float normal_strength = {min(0.0), max(5.0), default(1.0), group(Normal), index(3)};
//#param float use_normal_lerp = {min(0.0), max(1.0), default(0.0), group(Normal), index(4)};
//#param float normal_lerp_distance = {min(0.0), max(1000.0), default(30.0), group(Normal), index(5)};

//#group OrsMask = {index(3)}
//#param float ao_scale = {min(0.0), max(1.0), default(0.0), group(OrsMask), index(0)};
//#param float ao_contrast = {min(-10.0), max(10.0), default(0.0), group(OrsMask), index(1)};
//#param float roughness_contrast = {min(0.0), max(10.0), default(1.0), group(OrsMask), index(2)};
//#param float roughness_scale = {min(0.0), max(10.0), default(1.0), group(OrsMask), index(3)};
//#param float specular_value = {min(0.0), max(5.0), default(0.5), group(OrsMask), index(4)};

//#group SubSurface = {index(4)}
//#param sampler2D subsurface_color_map ={default(grey), group(SubSurface), index(0)};
//#param float4 subsurface_color_multiplier = {default(1.0,1.0,1.0,1.0), group(SubSurface), index(1)};
//#param float subsurface_color_brightness = {min(0.0), max(10.0), default(1.0), group(SubSurface), index(2)};
//#param float subsurface_color_contrast = {min(0.0), max(10.0), default(1.0), group(SubSurface), index(3)};
//#param float subsurface_color_saturation = {min(0.0), max(10.0), default(1.0), group(SubSurface), index(4)};
//#param float density_value = {min(0.0), max(1.0), default(1.0), group(SubSurface), index(5)};

//#group BackLit = {index(5)}
//#param float fake_env_value = {min(0.0), max(1.0), default(0.0), group(BackLit), index(0)};
//#param float4 top_color_multiplier = {default(0.0,0.0,0.0,0.0), group(BackLit), index(1)};
//#param float4 equator_color_multiplier = {default(0.0,0.0,0.0,0.0), group(BackLit), index(2)};
//#param float4 bottom_color_multiplier = {default(0.0,0.0,0.0,0.0), group(BackLit), index(3)};

//#group Wind-Branch = {index(6)}
//#param sampler2D wind_mask_map = {default(_engine/textures/default/game_wind_noise.texture.ast), group(Wind-Branch), index(0)};
//#param float4 global_wind_direction = {default(0.0,0.0,0.0,0.0), group(Wind-Branch), index(1)};
//#param float global_wind_speed = {min(0.0), max(10.0), default(1.0), group(Wind-Branch), index(2)};
//#param float global_wind_intensity = {min(0.0), max(10.0), default(4.0), group(Wind-Branch), index(3)};
//#param float scene_global_wind_instensity = {min(0.0), max(1.0), default(1.0), group(Wind-Branch), index(13)};
//#param float wind_scale = {min(0.0), max(10.0), default(4.0), group(Wind-Branch), index(4)};
//#param float wind_speed_multiplier = {min(0.0), max(10.0), default(1.0), group(Wind-Branch), index(5)};
//#param float wind_gust_variation = {min(0.0), max(10.0), default(0.02), group(Wind-Branch), index(6)};
//#param float wind_low_branch_speed = {min(0.0), max(10.0), default(5.0), group(Wind-Branch), index(7)};
//#param float wind_low_speed = {min(0.0), max(10.0), default(3.0), group(Wind-Branch), index(8)};
//#param float branch_motion_twist_multiplier = {min(0.0), max(10.0), default(0.0), group(Wind-Branch), index(9)};
//#param float root_motion_multiplier = {min(0.0), max(10.0), default(3.0), group(Wind-Branch), index(10)};
//#param float z_granding_origin = {min(0.0), max(10.0), default(0.0), group(Wind-Branch), index(11)};
//#param float z_granding_weight = {min(0.0), max(10.0), default(1.5), group(Wind-Branch), index(12)};

//#group Wind-Frond = {index(7)}
//#param float twig_curve_filter = {min(0.0001), max(10.0), default(0.25), group(Wind-Frond), index(0)};
//#param float wind_z_speed = {min(0.0), max(10.0), default(1.0), group(Wind-Frond), index(1)};
//#param float wind_z_intensity = {min(0.0), max(10.0), default(0.5), group(Wind-Frond), index(2)};
//#param float wind_intensity = {min(0.0), max(10.0), default(1.0), group(Wind-Frond), index(3)};
//#param float wave_intensity = {min(0.0), max(5.0), default(2.0), group(Wind-Frond), index(4)};
//#param float wave_frequency = {min(0.01), max(10.0), default(1.5), group(Wind-Frond), index(5)};
//#param float wave_scale = {min(0.01), max(20.0), default(1.0), group(Wind-Frond), index(6)};

//#group Interactive = {index(8)}
//#param float interaction_enabled = {min(0.0), max(1.0), default(0.0), group(Interactive), index(0)};
//#param float sphere_radius = {min(0.0), max(1000.0), default(4.0), group(Interactive), index(1)};
//#param float sphere_velocity_radius = {min(0.0), max(1000.0), default(10.0), group(Interactive), index(2)};

//#group SphereNormal = {index(9)}
//#param float normal_sphere_self = {min(0.0), max(1.0), default(0.0), group(SphereNormal), index(0)};
//#param float normal_sphere_self_near = {min(0.0), max(1.0), default(0.0), group(SphereNormal), index(1)};
//#param float4 instance_postion_normal_offset = {default(0.0,0.0,0.0,0.0), group(SphereNormal), index(2)};

//#group NearClip = {index(10)}
//#param float nearclip_enabled = {min(0.0), max(1.0), default(0.0), group(NearClip), index(0)};
//#param float nearclip_range = {min(0.0), max(100.0), default(3.0), group(NearClip), index(1)};
//#param float nearclip_max_translucent = {min(0.0), max(1.0), default(0.1), group(NearClip), index(2)};
//#param float nearclip_dither_density = {min(1.0), max(10000.0), default(2000.0), group(NearClip), index(3)};

//#group LodFade = {index(11)}
//#param float lod_fade_enabled = {min(0.0), max(1.0), default(0.0), group(LodFade), index(0)};
//#param float4 lod_screen_sizes = {default(2.0, 0.5, 0.25, 0.125), group(LodFade), index(1)};
//#param float lod_fade_ratio = {min(0.0), max(1.5), default(0.3), group(LodFade), index(2)};
//#param float lod_sphere_radius = {min(0.1), max(1000.0), default(4.549617), group(LodFade), index(3)};
//#param float lod_fade_min_alpha = {min(0.0), max(1.0), default(0.88), group(LodFade), index(4)};

//#group Fresnel = {index(12)}
//#param float fresnel_enabled = {min(0.0), max(1.0), default(0.0), group(Fresnel), index(0)};
//#param float fresnel_amount = {min(0.0), max(1.0), default(0.7), group(Fresnel), index(1)};
//#param float fresnel_exponent = {min(1.0), max(10.0), default(5.0), group(Fresnel), index(2)};

//#group TerrainBlend = {index(13)}
//#param float terrain_blend_range = {min(0.1), max(20.0), default(1.0), group(TerrainBlend), index(0)};
//#param float terrain_blend_contrast = {min(0.0), max(20.0), default(0.5), group(TerrainBlend), index(1)};
//#param float height_add = {min(-20.0), max(2000.0), default(0.2), group(TerrainBlend), index(2)};
//#param float noise_intense = {min(-1.0), max(1.0), default(0.0), group(TerrainBlend), index(3)};
//#param float4 terrain_map_mutiplier = {default(1.0, 1.0, 1.0, 1.0), group(TerrainBlend), index(4)};
//#param float terrain_map_roughness_add = {min(-1.0), max(1.0), default(0.0), group(TerrainBlend), index(5)};
//#param float terrain_map_metallic_add = {min(-1.0), max(1.0), default(0.0), group(TerrainBlend), index(6)};
//#param float terrain_map_normal_intensity = {min(0.0), max(10.0), default(1.0), group(TerrainBlend), index(7)};

//-----------------------------------------------------------------------------------------------------------
// CustomDataInOutput must always be declared (referenced by input_output_common.hlsli)
struct CustomDataInOutput {
    float4 custom_data1 : TEXCOORD13;
};

#include "core/vertex_shader_factory/vertex_common.hlsli"
#include "core/common/common_endecode.hlsli"
#include "core/common/global_constants.hlsli"
#include "core/vertex_shader_factory/animation_vertex_common.hlsli"
#include "core/vertex_shader_factory/input_output_common.hlsli"
#include "core/gpu_driven/gpu_primitive_common.hlsli"
#include "core/common/temporal_dither.hlsli"
#include "core/terrain/common_func.hlsli"

struct CommonVertexInput {
#ifdef VERTEX_INPUT_TYPE_MULTI_DRAW_INDIRECT
    uint vertex_id : CHAOS_VERTEX_ID;
    uint4 drawcall_id : DRAWCALLIDX;
    uint instance_index : CHAOS_INSTANCE_ID;
#elif defined(VERTEX_INPUT_TYPE_NANO)
    uint vertex_id : CHAOS_VERTEX_ID;
    uint instance_index : CHAOS_INSTANCE_ID;
#else
    float3 position : POSITION;

#ifdef ATTRIBUTE_NORMAL_ENABLE
    float4 normal : NORMAL;
    float4 tangent : TANGENT;
#endif

#ifdef ATTRIBUTE_UV0_ENABLE
    float2 uv0 : TEXCOORD0;
#endif

#ifdef ATTRIBUTE_UV1_ENABLE
    float2 uv1 : TEXCOORD1;
#endif

#if defined(ATTRIBUTE_COLOR0_ENABLE)
    float4 color : COLOR0;
#endif

#if defined(MESH_TYPE_BONE) || defined(MESH_TYPE_DESTRUCTION) || defined(MESH_TYPE_CLOTH_SIMULATION)
    uint4 blend_ids : BLENDINDICES;
    float4 blend_weights : BLENDWEIGHT;
#endif

#ifdef MESH_TYPE_CLOTH_SIMULATION
    float4 barycoord_pos : TEXCOORD9;
    float4 barycoord_normal : TEXCOORD10;
    float4 barycoord_tangent : TEXCOORD11;
    int4 simul_indices : TEXCOORD12;
#endif

    uint instance_index : CHAOS_INSTANCE_ID;

#endif
};

#include "core/vertex_shader_factory/vertex_parameters.hlsli"
#include "TA/character/character_transform.hlsli"
#include "TA/core/foliage_core.hlsli"
#include "custom_render_target/custom_render_target_utility.hlsli"
#include "core/foliage/helicopter_offset.hlsli"

CHAOS_DECLARE_TEX2D(wind_mask_map);
CHAOS_DECLARE_TEX2D(noise_map);

float4 global_wind_direction;
float global_wind_speed;
float global_wind_intensity;
float scene_global_wind_instensity;
float wind_scale;
float wind_speed_multiplier;
float wind_gust_variation;

float wind_low_branch_speed;
float wind_low_speed;
float branch_motion_twist_multiplier;
float root_motion_multiplier;

float z_granding_origin;
float z_granding_weight;

float twig_curve_filter;
float wind_z_speed;
float wind_z_intensity;
float wind_intensity;
float wave_intensity;
float wave_frequency;
float wave_scale;

// Interaction parameters
float interaction_enabled;
float sphere_radius;
float sphere_velocity_radius;

// Sphere Normal parameters
float normal_sphere_self;
float normal_sphere_self_near;
float4 instance_postion_normal_offset;

// LOD Fade parameters
float lod_fade_enabled;
float4 lod_screen_sizes;
float lod_fade_ratio;
float lod_sphere_radius;
float lod_fade_min_alpha;

// Near Clip parameters
float nearclip_enabled;
float nearclip_range;
float nearclip_max_translucent;
float nearclip_dither_density;

// Fresnel parameters
float fresnel_enabled;
float fresnel_amount;
float fresnel_exponent;

float3 SafeNormalize(float3 input_vector) {
    if (dot(input_vector, input_vector) > 0.0000001f) {
        return normalize(input_vector);
    }
    else {
        return float3(0.0f, 0.0f, 0.0f);
    }
}

float4 getBlendedWindDirectionStrength() {
    float blend_factor = saturate(scene_global_wind_instensity);
    float3 local_wind_dir = SafeNormalize(global_wind_direction.xyz);
    float3 level_wind_dir = SafeNormalize(per_level_wind_direction_strength.xyz);
    float3 blended_wind_dir = SafeNormalize(lerp(local_wind_dir, level_wind_dir, blend_factor));
    float blended_wind_strength = lerp(global_wind_intensity, per_level_wind_direction_strength.w, blend_factor);
    return float4(blended_wind_dir, blended_wind_strength);
}

float TwigRamp(float x, float y) {
    float value = pow(x, y) * x * (-10.0 + 1) / (x - 10.0);
    return value;
}

//-----------------------------------------------------------------------------------------------------------
// Interaction System
//-----------------------------------------------------------------------------------------------------------
static const float kTrailBendStrength = 0.38;
static const float kTrailMaxBendRatio = 0.46;

float3 foliageInteraction(float3 world_position, float3 object_pos, float bend_scale, float3 view_position, float bbox_height, float bbox_top_z) {
    if (bbox_height > 2.0 || bbox_top_z > view_position.z + 1.0) return float3(0, 0, 0);

    float2 view_dir = per_view_camera_direction.xy;
    float view_dir_len = length(view_dir);
    if (view_dir_len <= 0.0001) {
        view_dir = per_frame_character_direction.xy;
        view_dir_len = length(view_dir);
    }
    view_dir = view_dir_len > 0.0001 ? view_dir / view_dir_len : float2(0, 1);
    float2 view_right = float2(-view_dir.y, view_dir.x);

    float grass_height_factor = saturate(bbox_height / 0.8);
    float short_grass_boost = lerp(2.2, 1.0, grass_height_factor);

    float2 capsule_start = lerp(per_frame_character_position.xy, view_position.xy, 0.35);
    float lead_distance = lerp(0.56, 0.28, grass_height_factor);
    lead_distance = min(lead_distance, max(sphere_velocity_radius * 0.065, 0.28));
    float2 capsule_end = capsule_start + view_dir * lead_distance;
    float2 capsule_axis = capsule_end - capsule_start;
    float capsule_axis_len_sq = max(dot(capsule_axis, capsule_axis), 0.0001);
    float t = saturate(dot(object_pos.xy - capsule_start, capsule_axis) / capsule_axis_len_sq);
    float2 closest_point = capsule_start + capsule_axis * t;

    float2 root_delta = object_pos.xy - closest_point;
    float root_dist = length(root_delta);
    float radius = max(sphere_radius * lerp(0.16, 0.20, grass_height_factor), 0.001);
    float root_mask = 1.0 - saturate(root_dist / radius);
    root_mask = root_mask * root_mask * (3.0 - 2.0 * root_mask);
    root_mask = root_mask * root_mask;

    if (root_mask <= 0.0001) return float3(0, 0, 0);

    float2 away_dir = root_dist > 0.0001 ? root_delta / root_dist : view_right;
    float side_weight = saturate(abs(dot(away_dir, view_right)));
    float2 push_dir = normalize(view_dir + away_dir * (0.05 + 0.05 * side_weight));

    float3 vPos = world_position - object_pos;
    float fLength = length(vPos);
    if (fLength < 0.001) return float3(0, 0, 0);

    float bbox_top_above_camera = bbox_top_z - view_position.z;
    float height_atten = 1.0 - saturate((bbox_top_above_camera - 0.3) / 0.7);
    height_atten = height_atten * height_atten * (3.0 - 2.0 * height_atten);

    float fBF = vPos.z * bend_scale;
    fBF += 1.0;
    fBF *= fBF;
    fBF = fBF * fBF - fBF;
    float center_mask = root_mask * root_mask;
    float contact_boost = lerp(1.0, 1.4, center_mask);
    float interaction_strength = root_mask * short_grass_boost * contact_boost;

    float2 bend_xy = push_dir * interaction_strength * fBF * height_atten * kTrailBendStrength;
    float max_bend = fLength * min(kTrailMaxBendRatio * short_grass_boost, 0.82);
    float bend_len = length(bend_xy);
    if (bend_len > max_bend) bend_xy *= max_bend / bend_len;

    float3 vNewPos = vPos;
    vNewPos.xy += bend_xy;
    float down_press = center_mask * short_grass_boost * fBF * height_atten * 0.16;
    vNewPos.z -= down_press * fLength;
    vNewPos = normalize(vNewPos) * fLength;

    float3 result = vNewPos - vPos;
    result.z = min(result.z, 0.0);
    return result;
}

//-----------------------------------------------------------------------------------------------------------
// LOD Fade
//-----------------------------------------------------------------------------------------------------------
float computeLodFadeAlphaVS(float3 instance_position) {
    if (lod_fade_ratio <= 0.0001) return 1.0;
    float distance_to_camera = distance(instance_position, per_view_camera_position.xyz);
    float screen_multiple = max(per_view_projection_matrix[0][0], per_view_projection_matrix[1][1]) * 0.5;
    float screen_radius = screen_multiple * lod_sphere_radius / max(1.0, distance_to_camera);
    float screen_size = screen_radius * 2.0;

    float lo, hi;
    if (screen_size >= lod_screen_sizes.y) {
        lo = lod_screen_sizes.y;
        hi = lod_screen_sizes.x;
    }
    else if (screen_size >= lod_screen_sizes.z) {
        lo = lod_screen_sizes.z;
        hi = lod_screen_sizes.y;
    }
    else if (screen_size >= lod_screen_sizes.w) {
        lo = lod_screen_sizes.w;
        hi = lod_screen_sizes.z;
    }
    else {
        lo = 0.0;
        hi = lod_screen_sizes.w;
    }

    float range = hi - lo;
    float band = range * lod_fade_ratio;
    float dist_to_lo = screen_size - lo;
    if (dist_to_lo >= band) return 1.0;
    float fade = saturate(dist_to_lo / band);
    return max(fade, lod_fade_min_alpha);
}

//-----------------------------------------------------------------------------------------------------------
// Fresnel
//-----------------------------------------------------------------------------------------------------------
float cal_fresnel(float nDotV, float exponent, float baseReflectFraction) {
    return max(pow(max(abs(1.0 - max(0.0, nDotV)), 0.0001), exponent), 0.0)
    * (1.0 - baseReflectFraction) + baseReflectFraction;
}

//-----------------------------------------------------------------------------------------------------------
// Vertex Shader
//-----------------------------------------------------------------------------------------------------------
#if defined(VERTEX_SHADER)
float4 customObjectTransformation(float4 input_object_position, CommonVertexShaderAccessibleParameters parameters) {
    return input_object_position;
}

float4 customPreviousObjectTransformation(float4 input_previous_object_position, CommonVertexShaderAccessibleParameters parameters) {
    return input_previous_object_position;
}

float4 customWorldTransformation(float4 input_world_position, inout CommonVertexShaderAccessibleParameters parameters) {
    float twig_mask_value = TwigRamp(parameters.color.r, twig_curve_filter);

    float3 instance_pos, instance_scale;
    instance_pos = parameters.instance_attribute.position;
    instance_scale = parameters.instance_attribute.scale;

    float3 object_orientation = float3(0.0, 0.0, 1.0);
    float3 object_pivot_point = instance_pos;
    float3 relative_position = input_world_position.xyz - instance_pos;

    //WindInput
    float4 vertex_color_bias = (parameters.color - 1.0) * 2.0;
    float wind_variation_time = vertex_color_bias.g + vertex_color_bias.b + per_frame_time.x;
    float4 blended_wind = getBlendedWindDirectionStrength();
    float3 global_wind_direction_nor = blended_wind.xyz;
    float blended_wind_intensity = blended_wind.w;
    float3 wind_direction = global_wind_direction_nor * float3(-1.0, -1.0, 0.0);

    float3 wind_speed_val = global_wind_speed * 0.5 * wind_direction * wind_speed_multiplier;
    float4 wind_mask_value = CHAOS_SAMPLE_TEX2D_LOD(wind_mask_map, input_world_position.xy * 100.0 / wind_scale + wind_variation_time * wind_speed_val.xy, 0.0);
    float wind_mask = (wind_mask_value.r - 1.0) * 2.0;
    float wind_gust_mask = saturate(wind_mask_value.g + (1.0 - wind_gust_variation));

    // Wheat wave: modulates wind strength spatially for natural grain-field sway.
    float wave_gust = 1.0;
    if (wave_intensity > 0.001) {
        float2 wave_dir = normalize(global_wind_direction_nor.xy + float2(1e-5, 0.0));
        float2 wave_across = float2(-wave_dir.y, wave_dir.x);
        float2 wave_uv = input_world_position.xy * wave_scale;
        float t = per_frame_time.x * global_wind_speed * 0.3;
        float along = dot(wave_uv, wave_dir) * wave_frequency + t;
        float cross = dot(wave_uv, wave_across) * wave_frequency * 0.6 + t * 0.7;
        float wave = sin(along) * 0.55 + sin(along * 1.73 + 1.1) * 0.25
        + sin(cross * 0.47 + 2.3) * 0.15 + sin(cross * 1.31 + 0.7) * 0.05;
        wave_gust = 1.0 + wave * wave_intensity;
    }
    float effective_gust = wind_gust_mask * wave_gust;

    //ZMotion
    float z_time_speed = (vertex_color_bias.g + per_frame_time.x + vertex_color_bias.b) * wind_z_speed;
    float3 z_motion = float3(0.0, 0.0, wind_z_intensity * (sin(z_time_speed * 2 * PI / 3.41) + sin(z_time_speed * 2 * PI / 2.73)));

    //WindMotion (frond level)
    float3 wind_motion = wind_mask * global_wind_direction_nor.xyz * float3(-1.0, -1.0, -1.0) + z_motion;
    wind_motion = (wind_motion * wind_intensity) * (effective_gust * blended_wind_intensity) * twig_mask_value * 0.01;

    //WindLowMotion
    float3 wind_direction_low = global_wind_direction_nor * float3(1.0, -1.0, 0.0);
    float random_time = per_frame_time.x + parameters.instance_attribute.random_value * 20;
    wind_direction_low = clamp(float3(float2(wind_direction_low.y, wind_direction_low.x) + sin(random_time * 2 * PI / 7.0) * 0.25, 0.0), -1.0, 1.0);

    //Variation
    float wind_low_branch_variation_time = (parameters.color.r + random_time) * global_wind_speed * wind_low_branch_speed;
    float wind_low_variation_time = (parameters.color.r + random_time) * global_wind_speed * wind_low_speed;

    //BranchMotion
    float branch_instensity = blended_wind_intensity * branch_motion_twist_multiplier;
    branch_instensity *= ((cos(wind_low_branch_variation_time * 2 * PI / 5.0) * sin(wind_low_branch_variation_time * 2 * PI / 10.0) + 2.0) * 0.25 / 360.0);
    branch_instensity *= effective_gust;
    float3 branch_motion_pos = RotateAboutAxis(float4(object_orientation, branch_instensity * 2 * PI * 0.1), float3(0.0, 0.0, 0.0), relative_position);
    branch_motion_pos *= twig_mask_value;

    //RootMotion
    float root_instensity = blended_wind_intensity * root_motion_multiplier;
    root_instensity *= ((cos(wind_low_variation_time * 2 * PI / 5.0) * sin(wind_low_variation_time * 2 * PI / 10.0) + 2.0) * 0.25 / 360.0);
    root_instensity *= effective_gust;
    float3 root_motion_pos = RotateAboutAxis(float4(wind_direction_low, root_instensity * 2 * PI), float3(0.0, 0.0, 0.0), relative_position);
    float3 branch_root_motion = root_motion_pos + branch_motion_pos;

    //ZGradient
    float z_gradient = length(relative_position) / (z_granding_weight * instance_scale.z);
    z_gradient = saturate(saturate(z_gradient) - z_granding_origin);

    branch_root_motion *= z_gradient;

    // Apply wind
    float4 wind_result = input_world_position + float4(wind_motion + branch_root_motion, 0.0);

    // Interaction (runtime controlled)
    if (interaction_enabled > 0.5) {
        float plant_height = instance_scale.z;
        float plant_top_z = instance_pos.z + plant_height;
        float bend_scale = 1.0 / max(plant_height, 0.001);
        float3 interaction_offset = foliageInteraction(wind_result.xyz, instance_pos, bend_scale, per_view_camera_position.xyz, plant_height, plant_top_z);
        wind_result.xyz += interaction_offset;
    }

    // Helicopter offset
    float bend_scale_heli = 1.0 / max(instance_scale.z, 0.001);
    float3 heli_offset = CalculateHelicopterOffset(wind_result.xyz, instance_pos, bend_scale_heli);
    wind_result.xyz += heli_offset;

    // LOD Fade alpha (runtime controlled)
    if (lod_fade_enabled > 0.5) {
        parameters.custom_data0.g = computeLodFadeAlphaVS(instance_pos);
    }
    else {
        parameters.custom_data0.g = 1.0;
    }

    return wind_result;
}

float4 customPreviousWorldTransformation(float4 input_previous_world_position, inout CommonVertexShaderAccessibleParameters parameters) {
    float twig_mask_value = TwigRamp(parameters.color.r, twig_curve_filter);

    float3 instance_pos, instance_scale;
    instance_pos = parameters.instance_attribute.pre_position;
    instance_scale = parameters.instance_attribute.pre_scale;

    float3 object_orientation = float3(0.0, 0.0, 1.0);
    float3 object_pivot_point = instance_pos;
    float3 relative_position = input_previous_world_position.xyz - instance_pos;

    //WindInput
    float4 vertex_color_bias = (parameters.color - 1.0) * 2.0;
    float wind_variation_time = vertex_color_bias.g + vertex_color_bias.b + per_frame_previous_time.x;
    float4 blended_wind = getBlendedWindDirectionStrength();
    float3 global_wind_direction_nor = blended_wind.xyz;
    float blended_wind_intensity = blended_wind.w;
    float3 wind_direction = global_wind_direction_nor * float3(-1.0, -1.0, 0.0);

    float3 wind_speed_val = global_wind_speed * 0.5 * wind_direction * wind_speed_multiplier;
    float4 wind_mask_value = CHAOS_SAMPLE_TEX2D_LOD(wind_mask_map, input_previous_world_position.xy * 100.0 / wind_scale + wind_variation_time * wind_speed_val.xy, 0.0);
    float wind_mask = (wind_mask_value.r - 1.0) * 2.0;
    float wind_gust_mask = saturate(wind_mask_value.g + (1.0 - wind_gust_variation));

    // Wheat wave: modulates wind strength spatially for natural grain-field sway.
    float wave_gust = 1.0;
    if (wave_intensity > 0.001) {
        float2 wave_dir = normalize(global_wind_direction_nor.xy + float2(1e-5, 0.0));
        float2 wave_across = float2(-wave_dir.y, wave_dir.x);
        float2 wave_uv = input_previous_world_position.xy * wave_scale;
        float t = per_frame_previous_time.x * global_wind_speed * 0.3;
        float along = dot(wave_uv, wave_dir) * wave_frequency + t;
        float cross = dot(wave_uv, wave_across) * wave_frequency * 0.6 + t * 0.7;
        float wave = sin(along) * 0.55 + sin(along * 1.73 + 1.1) * 0.25
        + sin(cross * 0.47 + 2.3) * 0.15 + sin(cross * 1.31 + 0.7) * 0.05;
        wave_gust = 1.0 + wave * wave_intensity;
    }
    float effective_gust = wind_gust_mask * wave_gust;

    //ZMotion
    float z_time_speed = (vertex_color_bias.g + per_frame_previous_time.x + vertex_color_bias.b) * wind_z_speed;
    float3 z_motion = float3(0.0, 0.0, wind_z_intensity * (sin(z_time_speed * 2 * PI / 3.41) + sin(z_time_speed * 2 * PI / 2.73)));

    //WindMotion (frond level)
    float3 wind_motion = wind_mask * global_wind_direction_nor.xyz * float3(-1.0, -1.0, -1.0) + z_motion;
    wind_motion = (wind_motion * wind_intensity) * (effective_gust * blended_wind_intensity) * twig_mask_value * 0.01;

    //WindLowMotion
    float3 wind_direction_low = global_wind_direction_nor * float3(1.0, -1.0, 0.0);
    float random_time = per_frame_previous_time.x + parameters.instance_attribute.random_value * 20;
    wind_direction_low = clamp(float3(float2(wind_direction_low.y, wind_direction_low.x) + sin(random_time * 2 * PI / 7.0) * 0.25, 0.0), -1.0, 1.0);

    //Variation
    float wind_low_branch_variation_time = (parameters.color.r + random_time) * global_wind_speed * wind_low_branch_speed;
    float wind_low_variation_time = (parameters.color.r + random_time) * global_wind_speed * wind_low_speed;

    //BranchMotion
    float branch_instensity = blended_wind_intensity * branch_motion_twist_multiplier;
    branch_instensity *= ((cos(wind_low_branch_variation_time * 2 * PI / 5.0) * sin(wind_low_branch_variation_time * 2 * PI / 10.0) + 2.0) * 0.25 / 360.0);
    branch_instensity *= effective_gust;
    float3 branch_motion_pos = RotateAboutAxis(float4(object_orientation, branch_instensity * 2 * PI * 0.1), float3(0.0, 0.0, 0.0), relative_position);
    branch_motion_pos *= twig_mask_value;

    //RootMotion
    float root_instensity = blended_wind_intensity * root_motion_multiplier;
    root_instensity *= ((cos(wind_low_variation_time * 2 * PI / 5.0) * sin(wind_low_variation_time * 2 * PI / 10.0) + 2.0) * 0.25 / 360.0);
    root_instensity *= effective_gust;
    float3 root_motion_pos = RotateAboutAxis(float4(wind_direction_low, root_instensity * 2 * PI), float3(0.0, 0.0, 0.0), relative_position);
    float3 branch_root_motion = root_motion_pos + branch_motion_pos;

    //ZGradient
    float z_gradient = length(relative_position) / (z_granding_weight * instance_scale.z);
    z_gradient = saturate(saturate(z_gradient) - z_granding_origin);

    branch_root_motion *= z_gradient;

    // Apply wind
    float4 wind_result = input_previous_world_position + float4(wind_motion + branch_root_motion, 0.0);

    // Interaction (runtime controlled)
    if (interaction_enabled > 0.5) {
        float plant_height = instance_scale.z;
        float plant_top_z = instance_pos.z + plant_height;
        float bend_scale = 1.0 / max(plant_height, 0.001);
        float3 interaction_offset = foliageInteraction(wind_result.xyz, instance_pos, bend_scale, per_view_camera_previous_position.xyz, plant_height, plant_top_z);
        wind_result.xyz += interaction_offset;
    }

    // Helicopter offset (previous frame)
    float bend_scale_heli = 1.0 / max(instance_scale.z, 0.001);
    float3 heli_offset = CalculateHelicopterOffset(wind_result.xyz, instance_pos, bend_scale_heli, per_frame_previous_time.x - per_frame_time.x);
    wind_result.xyz += heli_offset;

    // LOD Fade alpha (runtime controlled)
    if (lod_fade_enabled > 0.5) {
        parameters.custom_data0.g = computeLodFadeAlphaVS(instance_pos);
    }
    else {
        parameters.custom_data0.g = 1.0;
    }

    return wind_result;
}

#ifdef ATTRIBUTE_CUSTOM_DATA_ENABLE
void customOutputAssembling(CommonVertexShaderAccessibleParameters input, inout CustomDataInOutput custom_data) {
    custom_data.custom_data1 = input.custom_data0;
    return;
}
#endif

CommonVertexOutput VS_Entry_vertex_plants(CommonVertexInput input) {
    CommonVertexOutput output = (CommonVertexOutput)0;
#include "core/vertex_shader_factory/common_vertex_shader.hlsli"
    return output;
}
#endif

///////////////////////////////////////PS////////////////////////////////////////

#include "core/gbuffer/gbuffer_mr.hlsli"
#include "core/pixel_shader_factory/forward_shading_common.hlsli"
#include "core/material/material_template.hlsli"
#include "core/pixel_shader_factory/pixel_inoutput.hlsli"
#include "core/material/material_surface_convert.hlsli"
#include "core/common/color_space_common.hlsli"
#include "core/terrain/common.hlsli"
#include "core/terrain/common_def.hlsli"
#include "core/terrain/common_func.hlsli"
#include "core/terrain/compute_common.hlsli"

//#region Texture Samplers
CHAOS_DECLARE_TEX2D(base_color_opacity_map);
CHAOS_DECLARE_TEX2D(normal_roughness_map);
CHAOS_DECLARE_TEX2D(subsurface_color_map);

//Hidden - terrain textures (always declared for engine binding)
CHAOS_DECLARE_TEX2D_FORMAT(terrain_page_table_texture, uint);
CHAOS_DECLARE_TEX2D(terrain_albedo_physical_texture);
CHAOS_DECLARE_TEX2D(terrain_normal_physical_texture);
CHAOS_DECLARE_TEX2D(terrain_pack_physical_texture);
CHAOS_DECLARE_TEX2DARRAY(terrain_block_height_map_array_for_mesh);
//#endregion

CHAOS_CONSTANT_BUFFER_DECLARATION_BEGIN(Material)
// ============ Hidden / engine-injected (terrain ref height info) ============
float4 terrain_ref_height_info_array[k_max_chunk_count]; // ref_height, pool_index_map, padding, padding

// ============ Base material ============
float4 base_color_multiplier;
float base_color_contrast;
float base_color_saturation;
float base_color_brightness;

float normal_view_dependency_factor;
float normal_view_dependency_strength;
float normal_strength;
float use_normal_lerp;
float normal_lerp_distance;

float ao_scale;
float ao_contrast;
float roughness_contrast;
float roughness_scale;
float specular_value;

float4 subsurface_color_multiplier;
float subsurface_color_brightness;
float subsurface_color_saturation;
float subsurface_color_contrast;
float density_value;

float fake_env_value;
float4 top_color_multiplier;
float4 bottom_color_multiplier;
float4 equator_color_multiplier;

// ============ Terrain blend ============
float terrain_blend_range;
float terrain_blend_contrast;
float height_add;
float noise_intense;
float4 terrain_map_mutiplier;
float terrain_map_roughness_add;
float terrain_map_metallic_add;
float terrain_map_normal_intensity;

// ============ Hidden / engine-injected (VT system) ============
float terrain_physical_page_size;
float terrain_physical_page_border_size;
float4 terrain_virtual_area;
float4 terrain_eye_to_visibility_ref;
float page_scale_factor;

// ============ Hidden / engine-injected (terrain mesh height) ============
float4 terrain_pos_lb; // pos_x, pos_y, num_x, num_y
float is_terrain_existed;

// ============ Alpha clip ============
#ifdef ALPHA_CLIP_ON
float alpha_clip_value;
float use_clip_lerp;
float clip_lerp_distance;
float alpha_clip_value_far;
#endif
CHAOS_CONSTANT_BUFFER_DECLARATION_END

// Utility functions
float CheapContrast(float invalue, float contrast) {
    float value = lerp((0.0 - contrast), (1.0 + contrast), invalue);
    return saturate(value);
}

float3 desaturation(float3 input, float fraction) {
    float3 LuminanceFactors = float3(0.3, 0.59, 0.11);
    return lerp(input, dot(input, LuminanceFactors), fraction);
}

float3 primaryColorCorrection(float3 input, float saturation, float3 tint_color, float brightness, float contrast) {
    float3 output = desaturation(input, 1.0f - saturation) * tint_color.rgb * brightness;
    output = pow(output, contrast);
    return output;
}

float3 cal_fake_env(float3 normal, float3 top_color, float3 equator_color, float3 bottom_color, float strength, float front_face) {
    normal *= front_face;
    float3 color = lerp(equator_color, top_color, saturate(dot(normal, float3(0, 0, 1))));
    color = lerp(color, bottom_color, saturate(dot(normal, float3(0, 0, -1))));
    return color * strength;
}

//-----------------------------------------------------------------------------------------------------------
// Terrain Blend Helper Functions
//-----------------------------------------------------------------------------------------------------------
#if defined(PIXEL_SHADER)

float GetHeightForMesh(float2 world_pos_xy) {
    if (is_terrain_existed < 0.01f) {
        return 0.0f;
    }

    int2 block_xy = (world_pos_xy - terrain_pos_lb.xy) / k_terrain_block_size;
    int block_index = clamp(block_xy.y * terrain_pos_lb.z + block_xy.x, 0, k_max_chunk_count - 1);
    int array_index = terrain_ref_height_info_array[block_index].y;
    int ref_height = terrain_ref_height_info_array[block_index].x;

    float2 chunk_lb_pos = terrain_pos_lb.xy + float2(block_xy) * k_terrain_block_size;
    float2 height_map_uv_xy = (world_pos_xy - chunk_lb_pos) / k_terrain_height_map_size;
    float3 height_map_uv = float3(height_map_uv_xy, array_index);

    float height = CHAOS_SAMPLE_TEX2DARRAY_LOD(terrain_block_height_map_array_for_mesh, height_map_uv, 0.0).x * k_terrain_height_map_scale_factor;
    return height + ref_height;
}

int isInVirtualArea(float2 dpos) {
    if (dpos.x > 0.0f && dpos.y > 0.0f && dpos.x < terrain_virtual_area.z && dpos.y < terrain_virtual_area.w) return 1;
    return 0;
}

uint getPageIdFromRefPosition(float2 dpos, float lod) {
    float2 page_table_uv = dpos / terrain_virtual_area.zw;
    page_table_uv.y = 1.0f - page_table_uv.y;
    uint page_id;
    bool is_valid = GetPageTableId(terrain_page_table_texture, page_table_uv, 0.0f, page_id);
    return page_id;
}

float ComputeHeightBlendMask(float mesh_z, float ground_z, float noise_val, float height_add_val, float blend_range, float blend_contrast, bool revert) {
    float blend_pos = mesh_z - ground_z;
    blend_pos = blend_pos / max(blend_range, 1e-5);
    blend_pos += noise_val * noise_intense - height_add_val;
    float mask = blend_pos;
    mask = pow(mask, blend_contrast);
    mask = saturate(mask);
    if (revert) mask = 1.0 - mask;
    return mask;
}

TerrainMaterialParameters getTerrainMaterialParameters(float3 world_position, float3 world_normal, float terrain_height) {
    float3 tighten_factor = float3(0.2, 0.2, 0.2);
    TerrainMaterialParameters terrain_paras = (TerrainMaterialParameters)0;
    float x_sign_value = sign(dot(world_normal, float3(-1, 0, 0)));
    float y_sign_value = sign(dot(world_normal, float3(0, -1, 0)));
    float height_diff = world_position.z - terrain_height;
    float3 position_ref_cam = world_position.xyz - per_view_camera_position.xyz;
    float2 pos_ref_virtual_area_xy = position_ref_cam.xy - terrain_virtual_area.xy;
    float2 pos_ref_virtual_area_xz = pos_ref_virtual_area_xy + float2(0, 1) * y_sign_value * height_diff;
    float2 pos_ref_virtual_area_yz = pos_ref_virtual_area_xy + float2(1, 0) * x_sign_value * height_diff;

    uint page_id_xy = getPageIdFromRefPosition(pos_ref_virtual_area_xy, 0);
    uint page_id_xz = getPageIdFromRefPosition(pos_ref_virtual_area_xz, 0);
    uint page_id_yz = getPageIdFromRefPosition(pos_ref_virtual_area_yz, 0);

    if (isInVirtualArea(pos_ref_virtual_area_xy) && isInVirtualArea(pos_ref_virtual_area_xz) && isInVirtualArea(pos_ref_virtual_area_yz)
        && IsValidPageId(page_id_xy) && IsValidPageId(page_id_xz) && IsValidPageId(page_id_yz)) {
        float2 physical_uv_x = GetPhysicalTextureUV(pos_ref_virtual_area_yz, page_id_yz, terrain_physical_page_size, terrain_physical_page_border_size, page_scale_factor);
        float2 physical_uv_y = GetPhysicalTextureUV(pos_ref_virtual_area_xz, page_id_xz, terrain_physical_page_size, terrain_physical_page_border_size, page_scale_factor);
        float2 physical_uv_z = GetPhysicalTextureUV(pos_ref_virtual_area_xy, page_id_xy, terrain_physical_page_size, terrain_physical_page_border_size, page_scale_factor);

        float3 albedo_x = CHAOS_SAMPLE_TEX2D(terrain_albedo_physical_texture, physical_uv_x).rgb;
        float3 albedo_y = CHAOS_SAMPLE_TEX2D(terrain_albedo_physical_texture, physical_uv_y).rgb;
        float3 albedo_z = CHAOS_SAMPLE_TEX2D(terrain_albedo_physical_texture, physical_uv_z).rgb;

        float3 normal_x = unpackNormalMap(CHAOS_SAMPLE_TEX2D(terrain_normal_physical_texture, physical_uv_x).yx);
        float3 normal_y = unpackNormalMap(CHAOS_SAMPLE_TEX2D(terrain_normal_physical_texture, physical_uv_y).yx);
        float3 normal_z = unpackNormalMap(CHAOS_SAMPLE_TEX2D(terrain_normal_physical_texture, physical_uv_z).yx);
        normal_x.y = -normal_x.y;
        normal_y.y = -normal_y.y;
        normal_z.y = -normal_z.y;

        float3 pack_x = CHAOS_SAMPLE_TEX2D(terrain_pack_physical_texture, physical_uv_x).rgb;
        float3 pack_y = CHAOS_SAMPLE_TEX2D(terrain_pack_physical_texture, physical_uv_y).rgb;
        float3 pack_z = CHAOS_SAMPLE_TEX2D(terrain_pack_physical_texture, physical_uv_z).rgb;

        float3 blend_weight = saturate(abs(world_normal) - tighten_factor);
        blend_weight /= (blend_weight.x + blend_weight.y + blend_weight.z);

        terrain_paras.base_color = (albedo_x * blend_weight.x + albedo_y * blend_weight.y + albedo_z * blend_weight.z) * terrain_map_mutiplier.rgb;
        terrain_paras.normal = (normal_x * blend_weight.x + normal_y * blend_weight.y + normal_z * blend_weight.z) * terrain_map_normal_intensity;
        terrain_paras.roughness = (pack_x.r * blend_weight.x + pack_y.r * blend_weight.y + pack_z.r * blend_weight.z) + terrain_map_roughness_add;
        terrain_paras.metallic = (pack_x.g * blend_weight.x + pack_y.g * blend_weight.y + pack_z.g * blend_weight.z) + terrain_map_metallic_add;
    }
    return terrain_paras;
}

float assembleOpacityMaskDepthOnly(PixelParameters pixel_params) {
    return CHAOS_SAMPLE_TEX2D(base_color_opacity_map, pixel_params.uvs[0]).w;
}

void assembleMaterialParams(PixelParameters pixel_params, inout MaterialParameters material_params) {
    float2 uv_sample = pixel_params.uvs[0];

    // Sample textures
    float4 base_color_opacity_value = CHAOS_SAMPLE_TEX2D(base_color_opacity_map, uv_sample);
    float4 normal_roughness_value = CHAOS_SAMPLE_TEX2D(normal_roughness_map, uv_sample);
    float4 subsurface_color_value = CHAOS_SAMPLE_TEX2D(subsurface_color_map, uv_sample);

    float3 base_color = primaryColorCorrection(base_color_opacity_value.rgb, base_color_saturation, base_color_multiplier.rgb, base_color_brightness, base_color_contrast);
    float3 subsurface_color = primaryColorCorrection(subsurface_color_value.rgb, subsurface_color_saturation, subsurface_color_multiplier.rgb, subsurface_color_brightness, subsurface_color_contrast);

    float opacity_mask_value = base_color_opacity_value.a;

    // Normal
    float3 local_normal = decodeNormalFromNormalMapValueBC5(normal_roughness_value);
    local_normal.xy *= normal_strength;

    // Sphere Normal: flatten normal detail
    if (normal_sphere_self > 0.0)
    local_normal.xy *= saturate(1.0 - normal_sphere_self * 0.8);

#ifdef ATTRIBUTE_FRONT_FACE_ENABLE
    local_normal = local_normal * pixel_params.is_front_face_float;
#endif

    // Sphere normal blending with reconstructed TBN
    float3 offset_world_position = mul(per_view_inverse_view_proj_matrix, pixel_params.clip_position).xyz;
    float3 re_normal_value = normalize(cross(ddx(offset_world_position), ddy(offset_world_position)));
    re_normal_value = dot(re_normal_value, pixel_params.view_direction) > 0 ? re_normal_value : 0 - re_normal_value;

    float3x3 re_TBN;
    re_TBN[0] = pixel_params.world_tangent;
    re_TBN[1] = cross(re_normal_value, pixel_params.world_tangent);
    re_TBN[2] = re_normal_value;

    float tbn_alpha = lerp(normal_sphere_self, lerp(normal_sphere_self_near, normal_sphere_self, saturate(length(per_view_camera_position - pixel_params.world_position) / normal_lerp_distance)), use_normal_lerp);
    float3 final_normal_value = normalize(mul(local_normal, lerp(pixel_params.TBN, re_TBN, tbn_alpha)));

    // Sphere Normal: blend toward spherical distribution
    if (normal_sphere_self > 0.0) {
        float3 sphere_center = pixel_params.world_position.xyz + instance_postion_normal_offset.xyz;
        float3 sphere_normal = normalize(pixel_params.world_position.xyz - sphere_center);
        float sphere_blend = lerp(normal_sphere_self, lerp(normal_sphere_self_near, normal_sphere_self, saturate(length(per_view_camera_position - pixel_params.world_position) / normal_lerp_distance)), use_normal_lerp);
        final_normal_value = normalize(lerp(final_normal_value, sphere_normal, sphere_blend));
    }

    // AO
    float ao = saturate(lerp(1.0, CheapContrast(pixel_params.vertex_color.a, ao_contrast), ao_scale));
    base_color *= ao;
    subsurface_color *= ao;

    // Roughness
    float roughness = pow(normal_roughness_value.a * roughness_scale, roughness_contrast);

    // Specular
    float specular = normal_roughness_value.b * specular_value;

    // Fresnel (runtime controlled)
    if (fresnel_enabled > 0.5) {
        float ndotv = dot(final_normal_value, pixel_params.view_direction);
        float fresnel = cal_fresnel(ndotv, fresnel_exponent, 0.04);
        specular = lerp(specular, fresnel_amount, fresnel);
    }

    // Fake env in shadow
    float3 emissive_color = cal_fake_env(pixel_params.world_normal.xyz, top_color_multiplier.rgb, equator_color_multiplier.rgb, bottom_color_multiplier.rgb, fake_env_value, pixel_params.is_front_face_float);
    float ndotl = dot(pixel_params.world_normal.xyz * pixel_params.is_front_face_float, pixel_params.light_direction);
    float shadow = 1 - saturate(ndotl);

    material_params.base_color = base_color;
    material_params.normal = final_normal_value;
    material_params.metallic = 0.0f;
    material_params.density = density_value;
    material_params.roughness = roughness;
    material_params.emissive_color = emissive_color * shadow;
    material_params.dielectric_specular_multiplier = specular;
    material_params.subsurface_color = subsurface_color;
    material_params.shade_mode = SHADE_MODE_TWO_SIDED_FOLIAGE;

#ifdef ALPHA_CLIP_ON
    material_params.opacity_mask = opacity_mask_value;
#endif

    // Terrain Blend (compile-time gated)
#ifndef SHADING_PATH_MOBILE
#if defined(Z_TERRAIN_BLEND_ON)
    float3 worldPos = pixel_params.world_position.xyz;
    float ground_world_height = GetHeightForMesh(worldPos.xy);
    TerrainMaterialParameters terrain_para = getTerrainMaterialParameters(worldPos, final_normal_value, ground_world_height);
    float noise_val = CHAOS_SAMPLE_TEX2D(noise_map, worldPos.xy).r;
    float mask = ComputeHeightBlendMask(worldPos.z, ground_world_height, noise_val, height_add, terrain_blend_range, terrain_blend_contrast, true);
    material_params.base_color = lerp(material_params.base_color, terrain_para.base_color, mask);
    material_params.normal = normalize(lerp(final_normal_value, normalize(mul(terrain_para.normal, pixel_params.TBN)), mask));
    material_params.roughness = lerp(material_params.roughness, terrain_para.roughness, mask);
    material_params.metallic = lerp(material_params.metallic, terrain_para.metallic, mask);
#endif
#endif
}

void customClip(PixelParameters pixel_params, MaterialParameters material_params) {
    float final_clip_value = 1.0;

#ifdef ALPHA_CLIP_ON
    final_clip_value = min(final_clip_value, material_params.opacity_mask);
#endif

#ifdef ALPHA_CLIP_ON
    float clip_threshold = lerp(alpha_clip_value, lerp(alpha_clip_value, alpha_clip_value_far, saturate(length(per_view_camera_position - pixel_params.world_position) / clip_lerp_distance)), use_clip_lerp);
    clip(final_clip_value - clip_threshold);
#else
    clip(final_clip_value - 0.333);
#endif

    // Near Clip - dense two-directional grid dither (runtime controlled)
    if (nearclip_enabled > 0.5) {
        float dist_to_camera = distance(pixel_params.world_position.xy, per_view_camera_position.xy);
        if (dist_to_camera < nearclip_range) {
            float fade = saturate(dist_to_camera / max(0.001, nearclip_range));
            fade = fade * fade * (3.0 - 2.0 * fade);
            float opacity = lerp(nearclip_max_translucent, 1.0, fade);

            // Two-directional grid pattern
            float3 wp = pixel_params.world_position.xyz;
            float2 grid_pos = frac(wp.xy * nearclip_dither_density);
            float grid_line_width = 1.0 - opacity;
            float grid_x = step(grid_line_width, grid_pos.x);
            float grid_y = step(grid_line_width, grid_pos.y);
            float grid_mask = grid_x * grid_y;

            // Slight noise to break regularity
            float noise1 = CHAOS_SAMPLE_TEX2D_LOD(noise_map, frac(wp.xy * nearclip_dither_density * 0.63), 0).r;
            grid_mask = lerp(grid_mask, noise1 * opacity, 0.1);

            float near_clip_alpha = 1.0;
#ifdef ALPHA_CLIP_ON
            near_clip_alpha = material_params.opacity_mask;
#endif
            clip(near_clip_alpha * grid_mask - 0.5);
        }
    }

    // LOD Fade dither
    if (lod_fade_enabled > 0.5) {
        float lod_fade_alpha = pixel_params.custom_data.custom_data1.g;
        if (lod_fade_alpha < lod_fade_min_alpha) {
            float2 lod_spos = pixel_params.clip_position.xy / pixel_params.clip_position.w;
            lod_spos = (lod_spos * 0.5 + 0.5) * float2(1920, 1080);
            int jitter_frame_index_lod = (int)(per_frame_temperal_effect_enabled.y + 0.1);
            float dither = temporalDither2(lod_spos, jitter_frame_index_lod);
            float2 noise_uv = lod_spos / float2(64.0, 64.0);
            float noise_val = CHAOS_SAMPLE_TEX2D_LOD(noise_map, noise_uv, 0).r;
            float animated_dither = (dither + noise_val) * (1.0 / 3.0);
            float remapped_fade = lod_fade_alpha * (2.0 / 3.0);
            clip(remapped_fade - animated_dither);
        }
    }

    return;
}
#endif // PIXEL_SHADER