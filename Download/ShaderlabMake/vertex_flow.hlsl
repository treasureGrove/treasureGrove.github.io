//These options will remove in several months
//But you still need to copy and change these options for different materials
//#asset is_explicit = {true}
//#asset is_deferred = {true}
//#asset shading_mode = {opacue}

//#category alpha_clip
//#option_default off
//#option off
//#option on

//#category environment_light
//#option_default on
//#option on
//#option off

//#category emissive
//#option_default off
//#option off
//#option on

//#category emissive_tex
//#option_default off
//#option off
//#option on

//#category shading_pipeline
//#option_default deferred
//#option forward
//#option deferred

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
//#option_default disable
//#option disable

//#category attribute_front_face
//#option_default disable
//#option enable
//#option disable

//#category vertex_input_type
//#option_default standard
//#option standard
//#option multi_draw_indirect
//#option nano

//#group Value = {index(0)}
//#param float4 uv_scale_offset = {default(1.0, 1.0, 0.0, 0.0), group(Value), index(0)};
//#param float4 base_color_multiplier = {default(1.0, 1.0, 1.0, 1.0), group(Value), index(1)};
//#param float base_color_saturation = {min(0.0), max(5.0), default(1.0), group(Value), index(2)};
//#param float base_color_brightness = {min(0.0), max(10.0), default(1.0), group(Value), index(3)};
//#param float base_color_contrast = {min(0.0), max(10.0), default(1.0), group(Value), index(4)};
//#param float4 emissive_tint = {default(1.0, 1.0, 1.0, 1.0), group(Value), index(5)};
//#param float emissive_intensity = {min(0.0), max(1000000.0), default(0), group(Value), index(6)};
//#param float metallic_scale = {min(0.0), max(10.0), default(1.0), group(Value), index(7)};
//#param float roughness_scale = {min(0.0), max(10.0), default(1.0), group(Value), index(8)};
//#param float roughness_contrast = {min(0.0), max(10.0), default(1.0), group(Value), index(9)};
//#param float dielectric_specular_value = {min(0.0), max(1.0), default(0.5), group(Value), index(10)};
//#param float ao_scale = {min(0.0), max(10.0), default(1.0), group(Value), index(11)};
//#param float alpha_scale = {min(0.0), max(10.0), default(1.0), group(Value), index(12)};

//#group AddLighting = {index(1)}
//#param float threshold = {min(0.0), max(1.0), default(0.0), group(AddLighting), index(0)};
//#param float add_min_distance = {min(0.0), max(10000.0), default(5.0), group(AddLighting), index(1)};
//#param float add_max_distance = {min(0.0), max(10000.0), default(80.0), group(AddLighting), index(2)};
//#param float color_min = {min(0.0), max(10000.0), default(5.0), group(AddLighting), index(3)};
//#param float color_max = {min(0.0), max(10000.0), default(80.0), group(AddLighting), index(4)};
//#param float character_add_pow = {min(0.0), max(10000.0), default(0.0), group(AddLighting), index(5)};

//#group HighLight = {index(2)}
//#param float4 highlight_color = {default(0.2, 0.6, 0.8, 1.0), group(HighLight), index(0)};
//#param float rim_intense = {min(0.0), max(1.0), default(0.0), group(HighLight), index(1)};
//#param float emissive_scale = {min(0.0), max(1.0), default(1.0), group(HighLight), index(2)};
//#param float highlight_smooth_power = {min(0.0), max(10.0), default(2.5), group(HighLight), index(3)};

//#group VertexUVFlow = {index(3)}
//#param float windSpeed = {min(0.0), max(10.0), default(1.0), group(VertexUVFlow), index(0)};
//#param float windDistortion = {min(0.0), max(10.0), default(1.0), group(VertexUVFlow), index(1)};
//#param float uvWindScale = {min(0.0), max(10.0), default(1.0), group(VertexUVFlow), index(2)};
//#param float uvDistortionScale = {min(0.0), max(10.0), default(1.0), group(VertexUVFlow), index(3)};
//#param float rangeOffset = {min(0.0), max(10.0), default(0.5), group(VertexUVFlow), index(4)};
//#param float softness = {min(0.0), max(1.0), default(0.1), group(VertexUVFlow), index(5)};
//#param float DistrotionHeight = {min(0.0), max(10.0), default(1.0), group(VertexUVFlow), index(6)};

//#group VertexUVAdjustment = {index(4)}
//#param float uvFlowAngle = {min(-180.0), max(180.0), default(0.0), group(VertexUVAdjustment), index(0)};
//#param float4 uvFlowTiling = {default(1.0, 1.0, 0.0, 0.0), group(VertexUVAdjustment), index(1)};

//#param float if_near_clip = {min(0.0), max(1.0), default(0.0), (hide)};

//#param sampler2D base_color_opacity_map ={default(grey)};
//#param sampler2D orm_mask_map = {default(_engine/textures/default/flat_orm.texture.ast)};
//#param sampler2D normal_map={default(_engine/textures/default/flat_n_bc5.texture.ast)};
//#param sampler2D emissive_map={default(_engine/textures/default/flat_white_d.texture.ast)};

// Notice: Only when you want to use the self-definition of the vertex shader, you need to copy the following code.

#ifdef ATTRIBUTE_CUSTOM_DATA_ENABLE
struct CustomDataInOutput {
    float4 custom_data1 : TEXCOORD13;
    float4 custom_data2 : TEXCOORD14;
    float4 custom_data3 : TEXCOORD15;
    float4 custom_data4 : TEXCOORD16;
};
#endif

#include "core/vertex_shader_factory/vertex_common.hlsli"
#include "core/common/common_endecode.hlsli"
#include "core/common/global_constants.hlsli"
#if defined(VERTEX_INPUT_TYPE_STANDARD_PSD)
#include "core/common/primitive_scene_data.hlsli"
#endif
#include "core/vertex_shader_factory/animation_vertex_common.hlsli"
#include "core/vertex_shader_factory/input_output_common.hlsli"
#include "core/vertex_shader_factory/default_input.hlsli"
#include "core/gpu_driven/gpu_primitive_common.hlsli"

#if defined(VERTEX_SHADER)

float windSpeed;
float windDistortion;
float uvWindScale;
float uvDistortionScale;
float rangeOffset;
float softness;
float DistrotionHeight;

float uvFlowAngle;
float4 uvFlowTiling;

// If you can't handle the vertex input to be the same as the sample shows, you should rewrite the vertex shader.
// Instead using the function struct in common_vertex_shader.hlsli, you need to write your own vertex shader.
#include "core/vertex_shader_factory/vertex_parameters.hlsli"

float2 applyVertexUVAdjustment(float2 uv) {
    float rad = uvFlowAngle * (3.14159265 / 180.0);
    // 围绕 UV 中心 (0.5, 0.5) 旋转 + 缩放
    float2 centered = uv - float2(0.5, 0.5);
    float2 rotated = float2(
        centered.x * cos(rad) - centered.y * sin(rad),
        centered.x * sin(rad) + centered.y * cos(rad));
    rotated *= uvFlowTiling.xy;
    float2 adjusted = rotated + float2(0.5, 0.5) + uvFlowTiling.zw;
    return adjusted;
}

float4 customObjectTransformation(float4 input_object_position, CommonVertexShaderAccessibleParameters p) {
    float2 uv = applyVertexUVAdjustment(p.uv0);
    float t = per_frame_time.x;

    float d = distance(uv, float2(0.0, 0.0));
    float s0 = sin(t * windSpeed + d * uvWindScale);
    float s1 = sin(t * windDistortion + (uv.x + uv.y) * uvDistortionScale);
    float amp = s0 * s1 * DistrotionHeight;

    float u = saturate(uv.x);
    float edge = saturate(rangeOffset);
    float mask = smoothstep(edge, edge + softness, u);

    float3 n = normalize(p.object_normal.xyz);
    float3 offset = n * (amp * mask);

    return input_object_position + float4(offset, 0.0);
}

float4 customPreviousObjectTransformation(float4 input_previous_object_position, CommonVertexShaderAccessibleParameters p) {
    float2 uv = applyVertexUVAdjustment(p.uv0);
    float t_prev = per_frame_time.x;

    float d = distance(uv, float2(0.0, 0.0));
    float s0 = sin(t_prev * windSpeed + d * uvWindScale);
    float s1 = sin(t_prev * windDistortion + (uv.x + uv.y) * uvDistortionScale);
    float amp = s0 * s1 * DistrotionHeight;

    float u = saturate(uv.x);
    float edge = saturate(rangeOffset);
    float mask = smoothstep(edge, edge + softness, u);

    float3 n = normalize(p.object_normal.xyz);
    float3 offset = n * (amp * mask);

    return input_previous_object_position + float4(offset, 0.0);
}

float4 customWorldTransformation(float4 input_world_position, CommonVertexShaderAccessibleParameters p) {
    return input_world_position;
}

float4 customPreviousWorldTransformation(float4 input_previous_world_position, CommonVertexShaderAccessibleParameters p) {
    return input_previous_world_position;
}

#ifdef ATTRIBUTE_CUSTOM_DATA_ENABLE
void customOutputAssembling(CommonVertexShaderAccessibleParameters input, inout CustomDataInOutput custom_data) {
    custom_data.custom_data1.xyz = input.position;
    return;
}
#endif
#endif

#include "core/gbuffer/gbuffer_mr.hlsli"
// for forward shading
#include "core/common/reconstruct_position.hlsli"
#include "core/light/surface_data_common.hlsli"
#include "core/light/light_common.hlsli"
#include "core/light/environment_lighting/environment_lighting.hlsli"
#include "core/atmosphere/atmosphere_common.hlsli"
// can be customized
#include "core/material/material_template.hlsli"
#include "core/pixel_shader_factory/pixel_inoutput.hlsli"
#include "core/material/material_surface_convert.hlsli"
#include "core/postprocess/eye_adaptation_common.hlsli"

CHAOS_DECLARE_TEX2D(base_color_opacity_map);
CHAOS_DECLARE_TEX2D(orm_mask_map); // x : ao, y : roughess, z : metallic
CHAOS_DECLARE_TEX2D(normal_map);

#if defined(EMISSIVE_TEX_ON)
CHAOS_DECLARE_TEX2D(emissive_map);
#endif

CHAOS_CONSTANT_BUFFER_DECLARATION_BEGIN(Material)
float4 uv_scale_offset;
float4 base_color_multiplier;
float4 emissive_tint;
float metallic_scale;
float roughness_scale;
float ao_scale;
float alpha_scale;
float dielectric_specular_value;
float emissive_intensity;
float4 highlight_color;
float highlight_smooth_power;
float rim_intense;
float emissive_scale;
float base_color_saturation;
float base_color_brightness;
float base_color_contrast;
float roughness_contrast;

#ifdef ALPHA_CLIP_ON
float alpha_clip_value;
#endif

float if_near_clip;

float anisotropy;
float opacity;
float porosity;
CHAOS_CONSTANT_BUFFER_DECLARATION_END
#define nearclip_range 25

#if defined(PIXEL_SHADER)

float level(float max_value, float min_value, float x) {
    return saturate((x - min_value) / (max_value - min_value));
}

float assembleOpacityMaskDepthOnly(PixelParameters pixel_params) {
    return CHAOS_SAMPLE_TEX2D(base_color_opacity_map, pixel_params.uvs[0]).w;
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
float Get_Fresnel_Value(float3 ws_pos, float3 ws_normal, float power, float intensity, float f0) {
    float3 view_dir = normalize(per_view_camera_position.xyz - ws_pos);
    float fresnel = f0 + (1.0f - f0) * pow(1 - abs(dot(normalize(ws_normal), view_dir)), power);
    fresnel *= intensity;
    return fresnel;
}

void assembleMaterialParams(PixelParameters pixel_params, inout MaterialParameters material_params) {
    float2 sample_uv = pixel_params.uvs[0]* uv_scale_offset.xy + uv_scale_offset.zw;

    //Texture Sample
    float4 base_color_opacity_value = CHAOS_SAMPLE_TEX2D(base_color_opacity_map, sample_uv);
    float4 normal = CHAOS_SAMPLE_TEX2D(normal_map, sample_uv);
    float4 orm_value = CHAOS_SAMPLE_TEX2D(orm_mask_map, sample_uv).rgba;

    // orm_value.rgb = approximationSRgbToLinear(orm_value.rgb);

    float3 emissive_color = float3(0.0, 0.0, 0.0);

#if defined(EMISSIVE_ON)
#if defined(EMISSIVE_TEX_ON)
    emissive_color = CHAOS_SAMPLE_TEX2D(emissive_map, sample_uv).rgb * emissive_intensity;
#else
    emissive_color = base_color_opacity_value.rgb * orm_value.a * emissive_tint * emissive_intensity;
#endif
#endif

    //pixel compute
    // float3 base_color_value = base_color_opacity_value.rgb * base_color_multiplier.rgb;
    float3 base_color_value = primaryColorCorrection(base_color_opacity_value.rgb, base_color_saturation, base_color_multiplier.rgb, base_color_brightness, base_color_contrast);
    float opacity_mask_value = base_color_opacity_value.a * alpha_scale;

    float metallic_value = orm_value.b * metallic_scale;
    float roughness_value = orm_value.g * roughness_scale;
    roughness_value = pow(roughness_value, roughness_contrast);
    float ao_value = ao_scale * (orm_value.r - 1.0) + 1.0;

    if(if_near_clip > 0) {
        float2 screen_pos = pixel_params.sv_clip_position.xy;
        float distance_clip_alpha = pixel_params.linear_depth / nearclip_range;
        float dither = temporalDither2(screen_pos, pixel_params.jitter_frame_index);
        clip(dither + distance_clip_alpha - 1.0);
    }

    float3 local_normal = decodeNormalFromNormalMapValueBC5(normal);

#ifdef ATTRIBUTE_FRONT_FACE_ENABLE
    local_normal = local_normal * pixel_params.is_front_face_float;
#endif

    float3 normal_value = normalize(mul(local_normal, pixel_params.TBN));

    //out material parameters to gbuffer
    material_params.base_color = base_color_value;

    material_params.normal = normal_value;
    material_params.metallic = metallic_value;
    material_params.roughness = roughness_value;
    material_params.dielectric_specular_multiplier = dielectric_specular_value;
    material_params.ao = ao_value;
    material_params.emissive_color = EyeAdaptationInverse(emissive_color.rgb, 1.0f, PreExposure);
#ifdef ALPHA_CLIP_ON
    material_params.opacity_mask = base_color_opacity_value.a * alpha_scale;
#endif

    // IMPORTANT!!!
    // Density here is only for "CheapSubsurface" and "TwoSideFoliage" shading model now, which controls transmission shadow strength.
    material_params.density = opacity;
    material_params.subsurface_color = float3(0.0f, 0.0f, 0.0f);
    material_params.anisotropy_or_backlit = anisotropy;
    material_params.subsurface_data.subsurface_profile_index = 255;
    material_params.subsurface_data.subsurface_thickness = 0.0f;
    material_params.subsurface_data.subsurface_strength = 0.0f;
    material_params.depth_offset = 0.0f;
    material_params.porosity = porosity;
}

void customClip(PixelParameters pixel_params, MaterialParameters material_params) {
#ifdef ALPHA_CLIP_ON
    clip(material_params.opacity_mask - alpha_clip_value);
#endif
    return;
}
#endif