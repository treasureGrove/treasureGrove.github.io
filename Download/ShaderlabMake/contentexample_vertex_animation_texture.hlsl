//These options will remove in several months
//But you still need to copy and change these options for different materials
//#asset is_explicit = {true}
//#asset is_deferred = {true}
//#asset shading_mode = {opacue}

//#category attribute_normal
//#option_default enable
//#option enable

//#category attribute_uv0
//#option_default enable
//#option enable

//#category attribute_uv1
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

//#category environment_light
//#option_default on
//#option on

//#category vertex_input_type
//#option_default standard
//#option standard
//#option multi_draw_indirect
//#option nano

//#category rotation_animation
//#option_default disable
//#option enable
//#option disable

//#category Custom_color
//#option_default disable
//#option enable
//#option disable

//#category attribute_front_face
//#option_default disable
//#option enable
//#option disable

//#param float4 basecolor={default(1.0,1.0,1.0,1.0)};
//#param float alpha_clip_value={min(0.0), max(1.0), default(0.333)};
//#param float animation_speed = {min(0.0), max(200.0), default(1.0)};
//#param float animation_strength = {min(0.0), max(200.0), default(1.0)};
//#param float4 animation_coord_info={default(1.0, 2.0, 3.0, 1.0)};

//#param sampler2D base_color_opacity_map ={default(grey)};
//#param sampler2D orm_mask_map = {default{black_d}};
//#param sampler2D normal_map={default(_engine/textures/default/flat_n_bc5.texture.ast)};
//#param sampler2D baked_animation_pos_texture={default(black_d)};
//#param sampler2D baked_animation_rot_texture={default(black_d)};

// Notice: Only when you want to use the self-definition of the vertex shader, you need to copy the following code.

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

#if defined(VERTEX_SHADER)

    CHAOS_DECLARE_TEX2D(baked_animation_pos_texture);
    CHAOS_DECLARE_TEX2D(baked_animation_rot_texture);

    float animation_speed;
    float animation_strength;
    float4 animation_coord_info;

    #define fps_duation 0.033333333

    // If you can't handle the vertex input to be the same as the sample shows, you should rewrite the vertex shader.
    // Instead using the function struct in common_vertex_shader.hlsli, you need to write your own vertex shader.
    #include "core/vertex_shader_factory/vertex_parameters.hlsli"
    #include "core/common/texture_sampler.hlsli"

	float getCoord(float3 original, float info)
	{
		bool is_neg = info < 0;
		info = abs(info);
		float ret = 0.0;
		int int_info = round(info);
		if(int_info == 1)
		{
			ret = original.x;
		}
		else if(int_info == 2)
		{
			ret = original.y;
		}
		else if(int_info == 3)
		{
			ret = original.z;
		}
		ret = is_neg? -ret: ret;
		return ret; 
	}

    float4 Sample_vertex_animation_texture(float2 uv1, CHAOS_DECLARE_TEX2D_LOCAL(baked_animation_texture))
    {
        uint miplevel = 0;
        uint width,height,num_miplevels;
        baked_animation_texture.GetDimensions(miplevel,width,height,num_miplevels);

        uint vertex_count = width;
        uint animation_frame_count = height;

        float speed = frac(per_frame_time.x * animation_speed * 0.33333);
        float sampleUV_Y = ceil(speed  * (1.0f+(float)animation_frame_count))/(float)animation_frame_count;
        float2 sampleUV = float2(uv1.x, sampleUV_Y);

        float4 var_animation_texture = CHAOS_SAMPLE_TEX2D_SAMPLER_LOD(baked_animation_texture,CHAOS_GLOBAL_SAMPLER_WRAP_POINT,sampleUV,0);
        return var_animation_texture;
    }

    float4 customObjectTransformation(float4 input_object_position,CommonVertexShaderAccessibleParameters parameters)
    {
        uint miplevel = 0;
        uint width,height,num_miplevels;
        baked_animation_pos_texture.GetDimensions(miplevel,width,height,num_miplevels);

        uint vertex_count = width;
        uint animation_frame_count = height;

        float speed = frac(per_frame_time.x * animation_speed * 0.33333);
        float sampleUV_Y = ceil(speed  * (1.0f+(float)animation_frame_count))/(float)animation_frame_count;
        float2 sampleUV = float2(parameters.uv1.x, sampleUV_Y);

        float4 var_animation_pos_texture = CHAOS_SAMPLE_TEX2D_SAMPLER_LOD(baked_animation_pos_texture,CHAOS_GLOBAL_SAMPLER_WRAP_POINT,sampleUV,0);
        float3 object_position_offset = var_animation_pos_texture.xyz;
        float3 world_position_offset = object_position_offset * 0.01;
        return input_object_position + float4(world_position_offset,0) * animation_strength;
    }

    float4 customPreviousObjectTransformation(float4 input_previous_object_position,CommonVertexShaderAccessibleParameters parameters)
    {
        uint miplevel = 0;
        uint width,height,num_miplevels;
        baked_animation_pos_texture.GetDimensions(miplevel,width,height,num_miplevels);

        uint vertex_count = width;
        uint animation_frame_count = height;

        float speed = frac(per_frame_previous_time.x * animation_speed * 0.33333);
        float sampleUV_Y = ceil(speed  * (1.0f+(float)animation_frame_count))/(float)animation_frame_count;
        float2 sampleUV = float2(parameters.uv1.x, sampleUV_Y);

        float4 var_animation_pos_texture = CHAOS_SAMPLE_TEX2D_SAMPLER_LOD(baked_animation_pos_texture,CHAOS_GLOBAL_SAMPLER_WRAP_POINT,sampleUV,0);
        float3 object_position_offset = var_animation_pos_texture.xyz;
        float3 world_position_offset = object_position_offset * 0.01;
        return input_previous_object_position + float4(world_position_offset,0) * animation_strength;
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
        #if defined(ROTATION_ANIMATION_ENABLE)
            // sample baked_animation_rot_texture
            float4 var_animation_rot_texture = Sample_vertex_animation_texture(input.uv1, CHAOS_TEXTURE_2D(baked_animation_rot_texture));

            float3 quaternionxyz = var_animation_rot_texture.xyz;
            float quaternionw = var_animation_rot_texture.w;

            float3 up = float3(0,0,1);
            float3 normal_os = cross(quaternionxyz,up * quaternionw + cross(quaternionxyz,up)) * 2 + up;

            float3 right = float3(1,0,0);
            float3 tangent_os = cross(quaternionxyz,quaternionw * right + cross(quaternionxyz,right)) * 2 + right;
            
            float4 world_normal = float4(0.0,0.0,0.0,0.0);
            float4 world_tangent = float4(0.0,0.0,0.0,0.0);
            uint instance_matrix_start_index = input.instance_index * k_per_instance_float4_count;

            float3 instance_scale;
            float4 instance_rotate;
            // Old Gpu instanced Data
            // instance_scale = rigid_instance_matrixes[instance_matrix_start_index + 1].xyz;
            // instance_rotate = rigid_instance_matrixes[instance_matrix_start_index + 2];
            // New Gpu instanced Data
            instance_scale = per_instance_params[instance_matrix_start_index].scale;
            instance_rotate = per_instance_params[instance_matrix_start_index].orientation;

            float3 scaled_normal = input.object_normal;
            scaled_normal.x = scaled_normal.x * sign(instance_scale.y) * sign(instance_scale.z);
            scaled_normal.y = scaled_normal.y * sign(instance_scale.z) * sign(instance_scale.x);
            scaled_normal.z = scaled_normal.z * sign(instance_scale.x) * sign(instance_scale.y);

            scaled_normal = lerp(scaled_normal,normal_os,animation_strength);
            world_normal.xyz = normalize(quaternionMulVec(instance_rotate, scaled_normal));

            float3 scaled_tangent = input.tangent.xyz;
            scaled_tangent.x *= sign(instance_scale.x);
            scaled_tangent.y *= sign(instance_scale.y);
            scaled_tangent.z *= sign(instance_scale.z);

            scaled_tangent = lerp(scaled_tangent,tangent_os,animation_strength);
            world_tangent.xyz = normalize(quaternionMulVec(instance_rotate, scaled_tangent));
            world_tangent.w = input.tangent.w * 2.0f - 1.0f;

            // normal
            custom_data.custom_data1.xyz = world_normal.xyz;
            
            // tangent
            custom_data.custom_data2 = world_tangent;
        #endif
    }
    #endif
#endif

#include "core/gbuffer/gbuffer_mr.hlsli"
// for forward shading
#if defined(SHADING_PIPELINE_FORWARD)
#include "core/pixel_shader_factory/forward_shading_common.hlsli"
#include "core/common/reconstruct_position.hlsli"
#include "core/light/surface_data_common.hlsli"
#include "core/light/light_common.hlsli"
#include "core/light/environment_lighting/environment_lighting.hlsli"
#include "core/atmosphere/atmosphere_common.hlsli"
#endif
// can be customized
#include "core/material/material_template.hlsli"
#include "core/pixel_shader_factory/pixel_inoutput.hlsli"
#include "core/material/material_surface_convert.hlsli"


CHAOS_DECLARE_TEX2D(base_color_opacity_map);
CHAOS_DECLARE_TEX2D(orm_mask_map); // x: ao, y: roughess, z: metallic
CHAOS_DECLARE_TEX2D(normal_map);

#ifdef ALPHA_CLIP_ON
float alpha_clip_value;
#endif

float4 basecolor;
float opacity;

#if defined(PIXEL_SHADER)

float3 Transform3x3Matrix(float3 VectorToTransfrom,float3 t,float3 b,float3 n)
{
    return float3(t * VectorToTransfrom.x + b * VectorToTransfrom.y + n * VectorToTransfrom.z);
}

float assembleOpacityMaskDepthOnly(PixelParameters pixel_params)
{
    return CHAOS_SAMPLE_TEX2D(base_color_opacity_map, pixel_params.uvs[0]).w;
}

void assembleMaterialParams(PixelParameters pixel_params,inout MaterialParameters material_params)
{
	float2 uv = pixel_params.uvs[0].xy;
    float4 base_color_opacity = CHAOS_SAMPLE_TEX2D(base_color_opacity_map, uv);
    float3 base_color = base_color_opacity.xyz;
    float opacity = base_color_opacity.w;

    float3 orm = CHAOS_SAMPLE_TEX2D(orm_mask_map, uv);
    float ao = orm.r;
    float roughness = orm.g;
    float metallic = orm.b;

    float4 normal = CHAOS_SAMPLE_TEX2D(normal_map, uv);
    float3 local_normal = decodeNormalFromNormalMapValueBC5(normal);

    #ifdef ATTRIBUTE_FRONT_FACE_ENABLE
        local_normal = local_normal * pixel_params.is_front_face_float;
    #endif

    #if defined(ROTATION_ANIMATION_ENABLE)
    // vertex_animation_rot_texture
        float4 n = pixel_params.custom_data.custom_data1.xyzw;
        float4 t = pixel_params.custom_data.custom_data2.xyzw;
        float3x3 tbn = calcTBNMatrix(t, n);
    #else
        float3x3 tbn = pixel_params.TBN;
    #endif

    ////////////////////////////////////////////////////////
    material_params.normal = normalize(mul(local_normal, tbn));
    #if defined(CUSTOM_COLOR_ENABLE)
    material_params.base_color = basecolor.xyz;
    #else
    material_params.base_color = base_color * basecolor.xyz;
    #endif
    material_params.metallic = metallic;
    material_params.ao = ao;
    material_params.roughness = roughness;
    material_params.opacity_mask = opacity;
}

void customClip(PixelParameters pixel_params, MaterialParameters material_params)
{
#ifdef ALPHA_CLIP_ON
    clip(material_params.opacity_mask - alpha_clip_value);
#endif
    return;
}
#endif
