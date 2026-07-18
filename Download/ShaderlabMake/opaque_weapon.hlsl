//These options will remove in several months
//But you still need to copy and change these options for different materials
//#asset is_explicit = {true}
//#asset is_deferred = {true}
//#asset shading_mode = {opacue}

//#category alpha_clip
//#option_default off
//#option on
//#option off

//#category attribute_normal
//#option_default enable
//#option enable

//#category attribute_uv0
//#option_default enable
//#option enable

//#category attribute_uv1
//#option_default disable
//#option disable

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
//#option_default bone
//#option rigid
//#option bone


//#category environment_light
//#option_default on
//#option off
//#option on

//#category vertex_input_type
//#option_default standard
//#option standard
//#option multi_draw_indirect
//#option nano

//#category character_first_personal
//#option_default enable
//#option enable
//#option disable


//#param float alpha_clip_value={min(0.0), max(1.0), default(0.333)};

//-----------------------------------------------------------------------------------------------------------
// Properties
//#group BaseMaterial = {index(0)}
//#param float4 base_tint={default(1.0,1.0,1.0,1.0), group(BaseMaterial), index(1)};
//#param float4 base_controls={default(1.0,1.0,1.0,0.0), group(BaseMaterial), index(2)};
//#param sampler2D base_color_map={default(flat_white_d), group(BaseMaterial), index(-1)};
//#param sampler2D base_normal_map={default(_project/textures/default/flat_n_bc5.texture.ast), group(BaseMaterial), index(-2)};
//#param sampler2D base_orm_map={default(flat_white_d), group(BaseMaterial), index(-3)};

//#group DetailMaterial = {index(1)}
//#param float4 dirt_tint={default(1.0,1.0,1.0,0.01), group(DetailMaterial), index(1)};
//#param float4 dirt_controls={default(1.0,1.0,1.0,0.0), group(DetailMaterial), index(2)};
//#param float4 dirt_uv_tiling={default(1.0,1.0,0.0,0.0), group(DetailMaterial), index(3)};
//#param float4 detial_uv_tiling={default(12,12,0,0), group(DetailMaterial), index(4)};
//#param float4 scratch_uv_tiling={default(10,10,0,0), group(DetailMaterial), index(5)};
//#param float detial_normal_intensity={default(1.0), group(DetailMaterial), index(6)};
//#param float scratch_normal_intensity={default(1.0), group(DetailMaterial), index(7)};
//#param sampler2D detail_normal_map={default(_project/textures/detail/weapon/ultra_detail.texture.ast), group(DetailMaterial), index(-1)};
//#param sampler2D dirt_map={default(_project/textures/detail/weapon/dirt_noise_mix.texture.ast), group(DetailMaterial), index(-2)};

//#group MaterialMask = {index(-1)}
//#param sampler2D RGBA_mask={default(_project/terrain/manmade/pure_color/white_d_mr.texture.ast), group(MaterialMask), index(-1)};

//#group WaterMaterial = {index(2)}
//#param float4 water_uv_tiling={default(8,8,0.0,0.0), group(WaterMaterial), index(1)};
//#param float water_normal_strength={default(0.2), group(WaterMaterial), index(2)};
//#param float water_frequecy={default(0.07), group(WaterMaterial), index(3)};
//#param float water_flow_frequency={default(0.07), group(WaterMaterial), index(4)};
//#param float4 water_flow_uv_tiling={default(5,5,0.0,0.0), group(WaterMaterial), index(5)};
//#param float water_intensity={default(0.0), group(WaterMaterial), index(6)};
//#param sampler2D water_map={default(_project/textures/rain/rain_drop.texture.ast), group(WaterMaterial), index(-1)};
//#param sampler2D water_flow_map={default(_project/textures/rain/rain_flow.texture.ast), group(WaterMaterial), index(-2)};
//#param sampler2D water_flow_animation_map={default(_project/textures/rain/rain_flow_mask.texture.ast), group(WaterMaterial), index(-3)};

//#group snowMaterial = {index(3)}
//#param float snow_offset={min(-5.0), max(5.0), default(0.0), group(snowMaterial), index(1)};
//#param float snow_intensity={min(0.0), max(1), default(0), group(snowMaterial), index(2)};
//#param float snow_range={min(0.0), max(1.0), default(0.5), group(snowMaterial), index(2)};
//#param float4 snow_uv_tiling={default(100.0,100.0,0.0,0.0), group(snowMaterial), index(3)};
//#param float4 snow_tint={default(0.93,1.0,1.0,1.0), group(snowMaterial), index(4)};
//#param float4 snow_controls={default(1.0,1.0,1.0,0.0), group(snowMaterial), index(5)};
//#param float snow_normal_intensity={default(1.0), group(snowMaterial), index(6)};
//#param sampler2D snow_color_map={default(_project/textures/default/default_snow_d.texture.ast), group(snowMaterial), index(-1)};
//#param sampler2D snow_normal_map={default(_project/textures/default/default_snow_n.texture.ast), group(snowMaterial), index(-2)};

//#group Hightlight={index(4)}
//#param float4 highlight_color={default(0.2,0.6,0.8,1.0), group(HighLight), index(0)};
//#param float rim_intense={min(0.0), max(1.0), default(0.0), group(HighLight), index(1)};
//#param float emissive_scale={min(0.0), max(1.0), default(1.0), group(HighLight), index(2)};
//#param float highlight_smooth_power={min(0.0), max(10.0), default(2.5), group(HighLight), index(3)};
//#param float opacity_mask={min(0.0), max(1), default(1), group(HighLight), index(4)};

//-----------------------------------------------------------------------------------------------------------
#ifdef ATTRIBUTE_CUSTOM_DATA_ENABLE
struct CustomDataInOutput
{
    float4 custom_data1 : TEXCOORD13;
    float4 custom_data2 : TEXCOORD14;
    float4 custom_data3 : TEXCOORD15;
    float4 custom_data4 : TEXCOORD16;
};
#endif

#include "core/vertex_shader_factory/vertex_common.hlsli"
#include "core/common/common_endecode.hlsli"
#include "core/common/global_constants.hlsli"
#include "core/vertex_shader_factory/animation_vertex_common.hlsli"
#include "core/vertex_shader_factory/input_output_common.hlsli"
#include "core/gpu_driven/gpu_primitive_common.hlsli"
struct CommonVertexInput
{
#ifdef VERTEX_INPUT_TYPE_MULTI_DRAW_INDIRECT
    uint  vertex_id     : CHAOS_VERTEX_ID;
    uint4 drawcall_id   : DRAWCALLIDX;
    uint instance_index : CHAOS_INSTANCE_ID;
#elif defined(VERTEX_INPUT_TYPE_NANO)
    uint  vertex_id     : CHAOS_VERTEX_ID;
    uint instance_index : CHAOS_INSTANCE_ID;
#else
    // Default to VERTEX_INPUT_TYPE_STANDARD if no other type is defined
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
    float4 barycoord_pos     : TEXCOORD9;
	float4 barycoord_normal  : TEXCOORD10;
	float4 barycoord_tangent : TEXCOORD11;
	int4   simul_indices     : TEXCOORD12;
#endif

        uint instance_index : CHAOS_INSTANCE_ID;

#endif
};


// If you can't handle the vertex input to be the same as the sample shows, you should rewrite the vertex shader.
// Instead using the function struct in common_vertex_shader.hlsli, you need to write your own vertex shader.
#include "core/vertex_shader_factory/vertex_parameters.hlsli"

float4 customObjectTransformation(float4 input_object_position,CommonVertexShaderAccessibleParameters parameters)
{
    return input_object_position;
}

float4 customPreviousObjectTransformation(float4 input_previous_object_position,CommonVertexShaderAccessibleParameters parameters)
{
    return input_previous_object_position;
}

float4 customWorldTransformation(float4 input_world_position,CommonVertexShaderAccessibleParameters parameters)
{
    return input_world_position;
}

float4 customPreviousWorldTransformation(float4 input_previous_world_position,CommonVertexShaderAccessibleParameters parameters)
{
    return input_previous_world_position;
}

#ifdef ATTRIBUTE_CUSTOM_DATA_ENABLE
void customOutputAssembling(CommonVertexShaderAccessibleParameters input,inout CustomDataInOutput custom_data)
{    
    custom_data.custom_data1.xyz = input.position.xyz;
    custom_data.custom_data2 = float4(0.4f,0.5f,0.6f,0.7f);
    custom_data.custom_data3 = float4(0.8f,0.9f,0.10f,0.11f);
    custom_data.custom_data4 = float4(0.12f,0.13f,0.14f,0.15f);
    return ;
}
#endif


#include "core/gbuffer/gbuffer_mr.hlsli"
// for forward shading
#include "core/pixel_shader_factory/forward_shading_common.hlsli"
// can be customized
#include "core/material/material_template.hlsli"
#include "core/pixel_shader_factory/pixel_inoutput.hlsli"
#include "core/material/material_surface_convert.hlsli"
// #include "core/postprocess/eye_adaptation_common.hlsli"
//SamplerState
CHAOS_DECLARE_TEX2D(base_color_map);
CHAOS_DECLARE_TEX2D(base_normal_map); // x: ao,  y: roughess, z: metallic
CHAOS_DECLARE_TEX2D(base_orm_map);
CHAOS_DECLARE_TEX2D(detail_normal_map);
CHAOS_DECLARE_TEX2D(dirt_map);

CHAOS_DECLARE_TEX2D(water_map);
CHAOS_DECLARE_TEX2D(water_flow_map);
CHAOS_DECLARE_TEX2D(water_flow_animation_map);
CHAOS_DECLARE_TEX2D(snow_color_map);
CHAOS_DECLARE_TEX2D(snow_normal_map);
float opacity_mask;
float4 base_tint;
float4 base_controls;

float4 dirt_tint;
float4 dirt_controls;
float4 dirt_uv_tiling;

float4 detial_uv_tiling;
float4 scratch_uv_tiling;
float detial_normal_intensity;
float scratch_normal_intensity;

float4 water_uv_tiling;
float water_normal_strength;
float water_frequecy;
float4 water_flow_uv_tiling;
float water_flow_frequency;
float water_intensity;

float snow_offset;
float snow_intensity;
float4 snow_uv_tiling;
float4 snow_tint;
float4 snow_controls;
float snow_normal_intensity;
float snow_range;

float4 highlight_color;
float rim_intense;
float emissive_scale;
float highlight_smooth_power;
//#region Branch

#if defined(EMISSIVE_TEX_ON)
    CHAOS_DECLARE_TEX2D(emissive_map);
#endif


#ifdef ALPHA_CLIP_ON
float alpha_clip_value;
#endif

float if_near_clip;
#define nearclip_range 25;

#if defined(CHARACTER_FIRST_PERSONAL_ENABLE)
float4 world_rotation;
#endif

//#endregion Branch
//#region Functions
float level(float max_value, float min_value, float x){
    return saturate((x - min_value) / (max_value - min_value));
}
float CheapContrast(float inScale, float Contrast)
{
    return saturate(lerp(0 - Contrast, Contrast + 1.0, inScale));
}
float3 BlendAngleCorrectedNormals(float3 base_normal,float3 additional_normal)
{
    float3 n1 = float3(base_normal.x, base_normal.y, (base_normal.z + 1.0));
    float3 n2 = float3((additional_normal.x * -1.0), (additional_normal.y * -1.0), additional_normal.z);
    float n1_dot_n2 = dot(n1, n2);
	n1 *= n1_dot_n2;
	n2 = (base_normal.z + 1.0) * n2;
    return normalize(n1 - n2); 
}

float3 Desaturation(float3 input, float fraction)
{
    float3 LuminanceFactors = float3(0.3, 0.59, 0.11);
    return lerp(input, dot(input, LuminanceFactors), fraction);
}

float3 LuminanceContrast(float3 color, float control)
{
    float mapped_contrast = control - 1.0;
    float luminance = dot(color, float3(0.3, 0.59, 0.11));
    float luminance_contrast = CheapContrast(luminance, mapped_contrast);
    float scale = (luminance > 0.0001) ? (luminance_contrast / luminance) : 1.0;
    return saturate(color * scale);
}

float3 Brightness(float3 input, float brightness)
{
    return input * brightness;
}
//#endregion Functions
float3 FlattenNormal(float3 normal,float normal_flatness)
{
    return lerp(normal, float3(0, 0, 1), normal_flatness);
}
float4 FourPlanarBlend(
    CHAOS_DECLARE_TEX2D_LOCAL(tex),
    float3 worldPos,
    float3 worldNormal,
    float4 uvTiling,   
    float blendSharpness = 4.0,
    float stableThreshold = 0.85)
{
    float4 axisWeights = float4(
        max( worldNormal.x, 0 ),   // +X
        max(-worldNormal.x, 0 ),   // -X
        max( worldNormal.y, 0 ),   // +Y
        max(-worldNormal.y, 0 )    // -Y
    );
    axisWeights = pow(axisWeights, blendSharpness);

    float sumW = axisWeights.x + axisWeights.y + axisWeights.z + axisWeights.w + 1e-6;
    float4 normWeights = axisWeights / sumW;

    float w_max = normWeights.x;
    int i_max = 0;
    [unroll]
    for(int i=1; i<4; i++) {
        if(normWeights[i] > w_max) {
            w_max = normWeights[i];
            i_max = i;
        }
    }

    float2 planarUVs[4] = {
        worldPos.yz * uvTiling.x + uvTiling.zw, 
        worldPos.yz * uvTiling.x + uvTiling.zw, 
        worldPos.xz * uvTiling.y + uvTiling.zw, 
        worldPos.xz * uvTiling.y + uvTiling.zw  
    };

    if(w_max > stableThreshold) {
        return CHAOS_SAMPLE_TEX2D(tex, planarUVs[i_max]);
    } else {
        float w_second = -1;
        int i_second = -1;
        [unroll]
        for(int i=0; i<4; i++) {
            if(i==i_max) continue;
            if(normWeights[i] > w_second) {
                w_second = normWeights[i];
                i_second = i;
            }
        }
        float sum2 = normWeights[i_max] + normWeights[i_second] + 1e-6;
        float w1 = normWeights[i_max]/sum2;
        float w2 = normWeights[i_second]/sum2;
        float4 c1 = CHAOS_SAMPLE_TEX2D(tex, planarUVs[i_max]);
        float4 c2 = CHAOS_SAMPLE_TEX2D(tex, planarUVs[i_second]);
        return w1*c1 + w2*c2;
    }
}
#if defined(PIXEL_SHADER)
float assembleOpacityMaskDepthOnly(PixelParameters pixel_params)
{
    return CHAOS_SAMPLE_TEX2D(base_color_map, pixel_params.uvs[0]).w;
}
void assembleMaterialParams(PixelParameters pixel_params,inout MaterialParameters material_params)
{
    
    float2 base_uv = pixel_params.uvs[0];
    float3 world_pos=pixel_params.world_position;
    float3 world_normal=pixel_params.world_normal;
    //BaseMaterial
    float3 base_color=CHAOS_SAMPLE_TEX2D(base_color_map, base_uv).rgb;
    float4 base_orm=CHAOS_SAMPLE_TEX2D(base_orm_map, base_uv);
    float3 base_normal=decodeNormalFromNormalMapValueBC5(CHAOS_SAMPLE_TEX2D(base_normal_map, base_uv));
    base_color*=base_tint.rgb*base_tint.a;
    base_color=Desaturation(base_color,1-base_controls.r);
    base_color=LuminanceContrast(base_color,base_controls.g);
    base_color=Brightness(base_color,base_controls.b);

    float3 final_color=base_color;
    float3 final_normal=base_normal;
    float3 final_roughness=base_orm.g;
    float3 final_metallic=base_orm.b;
    float3 final_ao=base_orm.r;

    //mask
    // float4 mask_rgba = float4(1.0,1.0,1.0,1.0);
    // #if defined(MASK_R_ON)|| defined(MASK_G_ON)|| defined(MASK_B_ON)|| defined(MASK_A_ON)
    // mask_rgba=CHAOS_SAMPLE_TEX2D(RGBA_mask, base_uv);
    // #endif

    //FrostedNormal
    float3 frosted_normal=unpackNormalMap(CHAOS_SAMPLE_TEX2D(detail_normal_map, base_uv*detial_uv_tiling.xy+detial_uv_tiling.zw).xy);
    frosted_normal.xy*=detial_normal_intensity;
    frosted_normal=normalize(frosted_normal);

    final_normal=BlendAngleCorrectedNormals(final_normal, frosted_normal);


    //ScratchNoraml 用ba通道做法线
    float3 scratch_normal=unpackNormalMap(CHAOS_SAMPLE_TEX2D(detail_normal_map, base_uv*scratch_uv_tiling.xy+scratch_uv_tiling.zw).zw);
    scratch_normal.xy*=scratch_normal_intensity;
    scratch_normal=normalize(scratch_normal);
    // float3 scratch_normal=decodeNormalFromNormalMapValueBC5(float4(scratch_normal_map.zw,scratch_normal_map.xy));
    // #if defined(MASK_R_ON)
    // if(mask_rgba.r>0.01)
    // {
    //     final_normal=BlendAngleCorrectedNormals(final_normal, scratch_normal);
    // }
    // #else
    final_normal=BlendAngleCorrectedNormals(final_normal, scratch_normal);
    // #endif
    //Dirt
    float4 dirt_map_rgba=CHAOS_SAMPLE_TEX2D(dirt_map, base_uv*dirt_uv_tiling.xy+dirt_uv_tiling.zw);
    float3 dirt_color=dirt_tint*(1-dirt_map_rgba.g)*dirt_tint.a;
    dirt_color=Desaturation(dirt_color,1-dirt_controls.r);
    dirt_color=Brightness(dirt_color,dirt_controls.g);
    dirt_color=LuminanceContrast(dirt_color,dirt_controls.b);
    // #if defined(MASK_G_ON)
    // if(mask_rgba.g>0.01)
    // {
    //     final_color=clamp(final_color+dirt_color,0,1);
    //     final_roughness=saturate(final_roughness+dirt_map_rgba.g*0.1f+dirt_map_rgba.a);
    // }
    // #else
    final_color=clamp(final_color+dirt_color,0,1);
    final_roughness=saturate(final_roughness+dirt_map_rgba.g*0.1f+dirt_map_rgba.a);
    // #endif

    // orm_value.rgb = approximationSRgbToLinear(orm_value.rgb);

#if defined(ATTRIBUTE_CUSTOM_DATA_ENABLE)
    world_pos=pixel_params.custom_data.custom_data1.xyz;
#endif
    if(water_intensity>0.01)
    {
        
        float3 wn = normalize(world_normal);
        float2 water_uv;
        if (wn.z > 0.5f)
        {
            water_uv = world_pos.xy;
        }
        else
        {
            float3 proj = world_pos - wn * dot(world_pos, wn);
            water_uv = proj.xy;
        }
        float4 water_rgba=CHAOS_SAMPLE_TEX2D(water_map, water_uv*water_uv_tiling.xy+water_uv_tiling.zw);
        float3 water_normal = decodeNormalFromNormalMapValueBC5(water_rgba) * water_normal_strength;
        water_normal = normalize(water_normal);

        float water_anim=frac(water_rgba.b-per_frame_time.x*water_frequecy)+saturate((int)((-1)*(water_rgba.a*2-1)));
        float water_move_mask=saturate(water_rgba.a*2-1);
        float water_static_mask=saturate(trunc(water_move_mask*-1));
        float vertex_normal_mask=world_normal.z;
        vertex_normal_mask=lerp(0,1,vertex_normal_mask);
        float water_mask=(water_anim*water_move_mask+water_static_mask)*vertex_normal_mask;

        water_normal=FlattenNormal(water_normal,lerp(0.4*(1-water_intensity),1*(1-water_intensity),water_mask));
        final_normal=lerp(final_normal,water_normal,water_mask);

        final_roughness =saturate(final_roughness-0.15f*water_intensity*dirt_map_rgba.g-0.1f);
        final_roughness=clamp(final_roughness-water_intensity*0.2f,0.05f,1);

        float4 water_flow_rgba=FourPlanarBlend(CHAOS_TEXTURE_2D(water_flow_map),world_pos,world_normal,water_flow_uv_tiling);
        float water_flow_offset=(water_flow_rgba.a+per_frame_time.x*water_flow_frequency)*lerp(0,1,water_flow_rgba.a);
        float4 water_flow_animation_uv_tiling=float4(water_flow_uv_tiling.xy,water_flow_uv_tiling.z,water_flow_uv_tiling.w+water_flow_offset);
        float4 water_flow_animation=FourPlanarBlend(CHAOS_TEXTURE_2D(water_flow_animation_map),world_pos,world_normal,water_flow_animation_uv_tiling);
        float water_flow_mask=water_flow_animation.r*round(water_flow_rgba.b);
        float3 water_flow_normal=decodeNormalFromNormalMapValueBC5(water_flow_rgba);



        // *saturate(lerp(3.5,1.5,world_normal.z))
        float vertex_flow_mask=lerp(0,1,world_normal.z+0.2f);
        float side_mask = saturate(1.0 - abs(world_normal.z) * 4.0);
        water_flow_normal.xy *= water_flow_mask  * vertex_flow_mask * side_mask;
        water_flow_normal = normalize(water_flow_normal);
        final_normal=lerp(final_normal,water_flow_normal,water_flow_mask*side_mask*water_intensity);
        final_roughness=clamp(final_roughness-water_flow_mask*0.2f,0.05f,1);
        
        // material_params.base_color = water_mask;
    }

// if(snow_intensity>0.01)
// {
// #if defined(ATTRIBUTE_CUSTOM_DATA_ENABLE)
//     world_pos=pixel_params.custom_data.custom_data1.xyz;
// #endif
//     float2 snow_uv =world_pos.xy;
//     float3 snow_color=CHAOS_SAMPLE_TEX2D(snow_color_map, snow_uv*snow_uv_tiling.xy+snow_uv_tiling.zw).rgb;
//     snow_color*=snow_tint.rgb*snow_tint.a;
//     snow_color=Desaturation(snow_color,1-snow_controls.r);
//     snow_color=Brightness(snow_color,snow_controls.g);
//     snow_color=LuminanceContrast(snow_color,snow_controls.b);
//     float3 snow_normal=decodeNormalFromNormalMapValueBC5(CHAOS_SAMPLE_TEX2D(snow_normal_map, snow_uv*snow_uv_tiling.xy+snow_uv_tiling.zw));
//     snow_normal.xy*=snow_normal_intensity;
//     snow_normal=normalize(snow_normal);
//     float snow_mask=lerp(0,1,pow(world_normal.z,snow_intensity*4)+snow_offset);
//     snow_mask*=(dirt_map_rgba.r-snow_range);
//     snow_mask=saturate(snow_mask);
//     snow_normal=BlendAngleCorrectedNormals(final_normal, snow_normal);
//     final_color=saturate(lerp(final_color,snow_color,snow_mask)+dirt_map_rgba.a*0.8);
//     final_normal=lerp(final_normal,snow_normal,snow_mask);
//     final_roughness=saturate(lerp(final_roughness,2,snow_mask));
// }
    
    float3 emissive_color = float3(0.0, 0.0, 0.0);

    #if defined(EMISSIVE_TEX_ON)
        // emissive_color = CHAOS_SAMPLE_TEX2D(emissive_map, sample_uv).rgb * emissive_intensity;
    #else
        // emissive_color = base_color.rgb * orm_value.a * emissive_tint * emissive_intensity;
    #endif

    //pixel compute
    // float ao_value = ao_scale * (orm_value.r - 1.0) + 1.0;
    
    // #if defined(INVINCIBLE_ON)
    //     float3 camera_dir = normalize(per_view_camera_position.xyz - pixel_params.world_position);
    //     float breath = (sin(per_frame_time * 4.7) + 1) * 0.5;
    //     float  normal_direction_dot = clamp(1.0 - dot(world_normal, camera_dir), 0.0001, 1.0);
    //     float  normal_intensity = pow(normal_direction_dot, highlight_smooth_power)*rim_intense * breath; // pow(base, power) base should not be zero    

    //     emissive_color = lerp(emissive_color, normal_intensity * highlight_color, emissive_scale);
    // #endif

    // if(if_near_clip > 0)
    // {
    //     float2 screen_pos = pixel_params.sv_clip_position.xy;
    //     float distance_clip_alpha = pixel_params.linear_depth / nearclip_range;
    //     float dither = temporalDither2(screen_pos, pixel_params.jitter_frame_index);
    //     clip(dither + distance_clip_alpha - 1.0);
    // }


    final_normal = normalize(mul(final_normal, pixel_params.TBN));

#if defined(CHARACTER_FIRST_PERSONAL_ENABLE)
    final_normal.xyz = quaternionMulVec(world_rotation,final_normal.xyz);
#endif
    // #if defined(CHARACTER_LIGHT_ON)
        // float add_power = smoothstep(0, 1, level(add_max_distance, add_min_distance, pixel_params.clip_position.w)) * character_add_pow;
        // float total_lum = dot(float3(.3,.59,.11),base_color_value);
        // float bloom_lum = step(threshold, total_lum);

        // emissive_color += base_color_value * bloom_lum * add_power;
    // #endif

    //out material parameters to gbuffer
    material_params.base_color = final_color;
    material_params.opacity_mask = opacity_mask;
    material_params.normal = final_normal;
    material_params.metallic = final_metallic;
    material_params.roughness = final_roughness;
    // material_params.dielectric_specular_multiplier = dielectric_specular_value;
    material_params.ao = final_ao;

}

void customClip(PixelParameters pixel_params, MaterialParameters material_params)
{
#ifdef ALPHA_CLIP_ON
    clip(material_params.opacity_mask - alpha_clip_value);
#endif
    return;
}
#endif
