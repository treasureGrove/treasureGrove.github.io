//#asset is_explicit = {true}
//#asset is_deferred = {true}
//#asset shading_mode = {default_lit}

//#category shared
//#option_default enable
//#option enable

//#category attribute_world_clip_position
//#option_default enable
//#option enable

//#category branch1
//#option_default enable
//#option enable

//#category branch2
//#option_default enable
//#option enable

//#category ripple
//#option_default enable
//#option enable

//#category ripple_shimmer
//#option_default enable
//#option enable

//#category subsurface
//#option_default off
//#option off
//#option on

//#category frensel
//#option_default off
//#option off
//#option on

//#category environment_light
//#option_default on
//#option on

//#category shading_pipeline
//#option_default forward
//#option forward

//#category z_terrain_blend
//#option_default off
//#option off
//#option on

//#category near_clip
//#option_default off
//#option off
//#option on

//#category interaction
//#option_default on
//#option off
//#option on

//#category lod_fade
//#option_default off
//#option off
//#option on

//#group Value = {index(0)}
//#param float4 uv_scale_offset = {default(1.0,1.0,0.0,0.0), group(Value), index(0)};

//#param float base_color_saturation = {min(0.0), max(5.0), default(1.0), group(Value), index(1)};
//#param float4 base_color_multiplier = {default(1.0,1.0,1.0,1.0), group(Value), index(2)};
//#param float base_color_brightness = {min(0.0), max(10.0), default(1.0), group(Value), index(3)};
//#param float base_color_contrast = {min(0.0), max(10.0), default(1.0), group(Value), index(4)};

//#param float subsurface_saturation = {min(0.0), max(10.0), default(1.0), group(Value), index(5)};
//#param float4 subsurface_color_multiplier = {default(1.0,1.0,1.0,1.0), group(Value), index(6)};
//#param float subsurface_brightness = {min(0.0), max(10.0), default(1.0), group(Value), index(7)};
//#param float subsurface_contrast = {min(0.0), max(10.0), default(1.0), group(Value), index(8)};

//#param float alpha_clip_value = {min(0.0), max(1.0), default(0.1), group(Value), index(9)};
//#param float roughness_contrast = {min(0.0), max(10.0), default(1.0), group(Value), index(10)};
//#param float roughness_scale = {min(0.0), max(10.0), default(1.0), group(Value), index(11)};
//#param float specular_value = {min(0.0), max(5.0), default(0.5), group(Value), index(12)};
//#param float fresnel_amount = {min(0.0), max(1.0), default(0.7), group(Value), index(13)};
//#param float ao_scale = {min(0.0), max(1.0), default(0.0), group(Value), index(14)};
//#param float density_value = {min(0.0), max(1.0), default(1.0), group(Value), index(15)};

//#group Texture = {index(1)}
//#param sampler2D base_color_opacity_map ={default(_engine/textures/default/flat_white_d.texture.ast)};
//#param sampler2D subsurface_color_map ={default(_engine/textures/default/flat_white_d.texture.ast)};
//#param sampler2D opacity_map ={default(_engine/textures/default/flat_white_d.texture.ast)};
//#param sampler2D normal_map ={default(_engine/textures/default/flat_n_bc5.texture.ast)};
//#param sampler2D ors_mask_map ={default(_engine/textures/default/flat_white_d.texture.ast)};
//#param sampler2D wind_noise_map ={default(_engine/textures/default/game_wind_noise.texture.ast)};

//#group NearClip = {index(2)}
//#param float nearclip_range={min(0.0), max(100.0), default(3.0), group(NearClip), index(1)};
//#param float nearclip_max_translucent={min(0.0), max(1.0), default(0.1), group(NearClip), index(7)};

//#group TerrainBlend = {index(4)}
//#param float terrain_blend_range = {min(0.1), max(20.0), default(1.0), group(TerrainBlend), index(0)};
//#param float terrain_blend_contrast = {min(0), max(20.0), default(0.5), group(TerrainBlend), index(1)};
//#param float height_add = {min(- 20.0), max(2000.0), default(0.2), group(TerrainBlend), index(2)};
//#param float noise_intense = {min(- 1.0), max(1.0), default(0.0), group(TerrainBlend), index(3)}
//#param float4 terrain_map_mutiplier = {default(1.0, 1.0, 1.0, 1.0), group(TerrainBlend), index(-1)};
//#param float terrain_map_roughness_add = {min(- 1.0), max(1.0), default(0.0), group(TerrainBlend), index(-2)};
//#param float terrain_map_metallic_add = {min(- 1.0), max(1.0), default(0.0), group(TerrainBlend), index(-3)};
//#param float terrain_map_normal_intensity = {min(0.0), max(10.0), default(1.0), group(TerrainBlend), index(-4)};
//#param sampler2D noise_map = {default(_engine/textures/default/Marcie_Grain_v3_128_M2_000.texture.ast), group(Mask), index(- 2)};

//#group SphereNormal = {index(6)}
//#param float normal_sphere_self = {min(0.0), max(1.0), default(0.0), group(SphereNormal), index(0)};

//#group Interactive= {index(5)}
//#param float sphere_radius = {min(0.0), max(1000.0), default(4), group(Interactive), index(2)};
//#param float sphere_velocity_radius = {min(0.0), max(1000.0), default(10), group(Interactive), index(3)};
//#param float wind_speed={min(0.0), max(100.0),default(1)};

//#group LodFade = {index(8)}
//#param float4 lod_screen_sizes = {default(2.0, 0.5, 0.25, 0.125), group(LodFade), index(0)};
//#param float lod_fade_ratio = {min(0.0), max(1.5), default(0.3), group(LodFade), index(1)};
//#param float lod_sphere_radius = {min(0.1), max(1000.0), default(4.549617), group(LodFade), index(2)};
//#param float lod_fade_min_alpha = {min(0.0), max(1.0), default(0.88), group(LodFade), index(3)};
//#param float lod_blur_strength = {min(0.0), max(4.0), default(2.0), group(LodFade), index(4)};

#ifndef CHAOS_SHADER_SPEEDTREE_BRANCH
#define CHAOS_SHADER_SPEEDTREE_BRANCH

#include "core/common/global_constants.hlsli"
#include "core/common/common_transformation.hlsli"
#include "core/common/math.hlsli"
#include "core/common/common_endecode.hlsli"
#include "core/common/temporal_dither.hlsli"

#include "tree/speedtree_v9_vertex.hlsli"
#include "tree/speedtree_common.hlsli"

#include "core/common/chaos_hlsl_support.hlsli"
#include "core/foliage/foliage_compute_common.hlsli"
#include "core/foliage/helicopter_offset.hlsli"
#include "core/vertex_shader_factory/vertex_common.hlsli"
#include "core/terrain/common_func.hlsli"

CHAOS_DECLARE_TEX2D(base_color_opacity_map);
CHAOS_DECLARE_TEX2D(normal_map);
CHAOS_DECLARE_TEX2D(ors_mask_map);
CHAOS_DECLARE_TEX2D(subsurface_color_map);
CHAOS_DECLARE_TEX2D(opacity_map);
CHAOS_DECLARE_TEX2D(noise_map);

float sphere_radius;
float sphere_velocity_radius;

#define WindNoise wind_noise_map
#include "tree/speedtree_wind_v9.hlsli"
float4 uv_scale_offset;
float4 base_color_multiplier;
float4 subsurface_color_multiplier;
float alpha_clip_value;
float roughness_contrast;
float roughness_scale;
float specular_value;
float base_color_contrast;
float base_color_saturation;
float base_color_brightness;
float subsurface_brightness;
float subsurface_saturation;
float subsurface_contrast;
float fresnel_amount;

float nearclip_offset;
float nearclip_range;
float density_value;

#if defined(NEAR_CLIP_ON)
float nearclip_top_width;
float nearclip_top_height;
float nearclip_bottom_width;
float nearclip_bottom_height;
float nearclip_transition;
float nearclip_max_translucent;
#endif

float ao_scale;

#ifdef SHADING_PIPELINE_FORWARD
 float2 near_far_plane_distance;
 float2 resolution;
 float4x4 view_proj_matrix;
 float4 occlusion_tint;
#endif
float4 instance_postion_normal_offset;
float normal_sphere_self;

float wind_speed;

uint indirect_arg_index;
uint render_entity_id;

float terrain_blend_range;
float terrain_blend_contrast;
float height_add;
float noise_intense;
float4 terrain_map_mutiplier;
float terrain_map_roughness_add;
float terrain_map_metallic_add;
float terrain_map_normal_intensity;

// LOD fade params
float4 lod_screen_sizes;
float lod_fade_ratio;
float lod_sphere_radius;
float lod_fade_min_alpha;
float lod_blur_strength;

//Hidden
float terrain_physical_page_size;
float terrain_physical_page_border_size;
float4 terrain_virtual_area;
float4 terrain_eye_to_visibility_ref;
float page_scale_factor;

CHAOS_DECLARE_TEX2D_FORMAT(terrain_page_table_texture, uint);
CHAOS_DECLARE_TEX2D(terrain_albedo_physical_texture);
CHAOS_DECLARE_TEX2D(terrain_normal_physical_texture);
CHAOS_DECLARE_TEX2D(terrain_pack_physical_texture);

CHAOS_DECLARE_STRUCTURED_BUFFER_AT_REG(instance_data_buffer, FoliageInstanceData, 30);
CHAOS_DECLARE_STRUCTURED_BUFFER_AT_REG(instance_id_buffer, uint, 31);
CHAOS_DECLARE_STRUCTURED_BUFFER_AT_REG(instance_id_offset_buffer, uint, 32);

uint getInstanceId(uint draw_instance_id)
{
	if (indirect_arg_index != -1)
	{
		return instance_id_buffer[instance_id_offset_buffer[indirect_arg_index] + draw_instance_id];
	}
	else
	{
		return draw_instance_id;
	}
}

// ------------------------------------------------------------------------------------------------------
// [GLOBAL STRUCT]
// ------------------------------------------------------------------------------------------------------
struct SpeedTreeV9DepthVertexOutput_Custom
{
	float4 position : SV_POSITION;
	float3 texcoord : TEXCOORD0;
	uint instance_id : TEXCOORD1;
	float lod_fade_alpha : TEXCOORD2;
	float4 world_position : TEXCOORD3; 
	float4 clip_position : TEXCOORD4; 
};

struct SpeedTreeV9VertexOutput_Custom
{
	float4 position : SV_POSITION;
	float3 texcoord : TEXCOORD0;
	float4 normal_ao : TEXCOORD1;
	float3 tangent : TEXCOORD2;
	float4 clip_position : TEXCOORD3;
	float4 previous_clip_position : TEXCOORD4;
	float4 object_position : TEXCOORD5;
	float4 world_position : TEXCOORD6;
	float lod_fade_alpha : TEXCOORD7;
};

float computeLodFadeAlphaVS(float3 instance_position)
{
#if defined(LOD_FADE_ON)
	if (lod_fade_ratio <= 0.0001) return 1.0;
	float distance_to_camera = distance(instance_position, per_view_camera_position.xyz);
	float screen_multiple = max(per_view_projection_matrix[0][0], per_view_projection_matrix[1][1]) * 0.5;
	float screen_radius = screen_multiple * lod_sphere_radius / max(1.0, distance_to_camera);
	float screen_size = screen_radius * 2.0;
	float lo, hi;
	if (screen_size >= lod_screen_sizes.y) {
		lo = lod_screen_sizes.y;
		hi = lod_screen_sizes.x;
	} else if (screen_size >= lod_screen_sizes.z) {
		lo = lod_screen_sizes.z;
		hi = lod_screen_sizes.y;
	} else if (screen_size >= lod_screen_sizes.w) {
		lo = lod_screen_sizes.w;
		hi = lod_screen_sizes.z;
	} else {
		lo = 0.0;
		hi = lod_screen_sizes.w;
	}
	float range = hi - lo;
	float band = range * lod_fade_ratio;
	float dist_to_lo = screen_size - lo;
	if (dist_to_lo >= band) return 1.0;
	float fade = saturate(dist_to_lo / band);
	return max(fade, lod_fade_min_alpha);
#else
	return 1.0;
#endif
}

// Compute mip level for LOD blur: uses UV derivatives + fade-based bias
float computeLodBlurMipLevel(float2 uv, float lod_fade_alpha)
{
#if defined(LOD_FADE_ON)
	// Calculate base mip level from UV derivatives (hardware would normally do this)
	float2 dx_uv = ddx(uv);
	float2 dy_uv = ddy(uv);
	float max_deriv = max(dot(dx_uv, dx_uv), dot(dy_uv, dy_uv));
	float base_mip = 0.5 * log2(max(max_deriv, 1e-10));
	base_mip = max(base_mip, 0.0);
	
	// Compute blur bias from fade alpha
	float fade_factor = 1.0 - saturate(lod_fade_alpha);
	// Smooth curve for natural transition
	fade_factor = fade_factor * fade_factor * (3.0 - 2.0 * fade_factor);
	float blur_bias = fade_factor * lod_blur_strength;
	
	return base_mip + blur_bias;
#else
	return 0.0;
#endif
}

static const float kTrailBendStrength = 0.38;
static const float kTrailMaxBendRatio = 0.46;

float3 foliageInteraction(float3 world_position, float3 object_pos, float bend_scale, float3 view_position, float bbox_height, float bbox_top_z)
{
	if (bbox_height > 2.0 || bbox_top_z > view_position.z + 1.0) return float3(0, 0, 0);
	float2 view_dir = per_view_camera_direction.xy;
	float view_dir_len = length(view_dir);
	if (view_dir_len <= 0.0001) { view_dir = per_frame_character_direction.xy; view_dir_len = length(view_dir); }
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
	float fBF = vPos.z * bend_scale; fBF += 1.0; fBF *= fBF; fBF = fBF * fBF - fBF;
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

#if defined(VERTEX_SHADER)
void SpeedTreeWind(SpeedTreeV9VertexLayout vAttrib, float3 vInstancePos, float fInstanceScalar, float fTimeOffset, inout float3 vOrientedPos, inout float3 vOrientedNormal)
{
	SWindInputSdk sWindInput = (SWindInputSdk)0;
	GetSpeedTreeWindState(sWindInput.m_sState);
	if (fTimeOffset != 0.0 && per_frame_time.x != 0.0) { float fTimeScale = (per_frame_time.x + fTimeOffset) / per_frame_time.x; sWindInput.m_sState.m_sShared.m_vNoisePosTurbulence *= fTimeScale; sWindInput.m_sState.m_sBranch1.m_vNoisePosTurbulence *= fTimeScale; sWindInput.m_sState.m_sBranch2.m_vNoisePosTurbulence *= fTimeScale; sWindInput.m_sState.m_sRipple.m_vNoisePosTurbulence *= fTimeScale; }
	float fWindBranch1Weight = vAttrib.texcoord3.x;
	float3 vWindBranch1NoiseOffset = Utility_UnpackInteger3(vAttrib.texcoord4.x, float3(9, 9, 3)) * (sWindInput.m_sState.m_vBoundingBoxMax - sWindInput.m_sState.m_vBoundingBoxMin);
	float fWindBranch2Weight = vAttrib.texcoord5.x;
	float3 vWindBranch2NoiseOffset = Utility_UnpackInteger3(vAttrib.texcoord6.x, float3(9, 9, 3)) * (sWindInput.m_sState.m_vBoundingBoxMax - sWindInput.m_sState.m_vBoundingBoxMin);
	float fWindRipple = vAttrib.texcoord4.y;
	float3 vWindBranch1Dir, vWindBranch2Dir;
	Utility_UnpackNormalFibonacci2(float2(vAttrib.texcoord3.y, vAttrib.texcoord5.y), vWindBranch1Dir, vWindBranch2Dir);
	sWindInput.m_sInstance.m_vPosition = vInstancePos;
	sWindInput.m_sVertex.m_vPosition = vOrientedPos;
	sWindInput.m_sVertex.m_vNormal = vOrientedNormal;
	sWindInput.m_sVertex.m_fRippleWeight = fWindRipple;
	sWindInput.m_sVertex.m_sBranch1.m_vDir = vWindBranch1Dir; sWindInput.m_sVertex.m_sBranch1.m_fWeight = fWindBranch1Weight; sWindInput.m_sVertex.m_sBranch1.m_vNoiseOffset = vWindBranch1NoiseOffset * fInstanceScalar;
	sWindInput.m_sVertex.m_sBranch2.m_vDir = vWindBranch2Dir; sWindInput.m_sVertex.m_sBranch2.m_fWeight = fWindBranch2Weight; sWindInput.m_sVertex.m_sBranch2.m_vNoiseOffset = vWindBranch2NoiseOffset * fInstanceScalar;
	WindSdk(sWindInput);
	vOrientedPos = sWindInput.m_sVertex.m_vPosition;
	vOrientedNormal = sWindInput.m_sVertex.m_vNormal;
}

SpeedTreeV9DepthVertexOutput_Custom VS_Entry_instance_depth_only_with_clip(SpeedTreeV9VertexLayout input)
{
	SpeedTreeV9DepthVertexOutput_Custom output = (SpeedTreeV9DepthVertexOutput_Custom)0;
	
	output.instance_id = getInstanceId(input.instance_index);
	FoliageInstanceData instance_data = instance_data_buffer[getInstanceId(input.instance_index)];
	float3 instance_position = instance_data.position;
	float instance_scale = instance_data.scale;
	float4 instance_orientation = instance_data.orientation;
	float lod_coeff = getLodInterp(instance_data, per_view_camera_position.xyz, per_view_projection_matrix);
	if (min_screen_size == 0.0) lod_coeff = 0.0;
	float3 position = input.position.xyz;
	float3 lod_position = float3(input.texcoord1.xy, input.texcoord2.x);
	float3 smooth_position = lerp(position, lod_position, lod_coeff);
	float3 oriented_pos = quaternionMulVec(instance_orientation, smooth_position);
	float3 oriented_normal = float3(0,0,0);
	SpeedTreeWind(input, instance_position, instance_scale, 0.0, oriented_pos, oriented_normal);
	SWindInputSdk sWindInput = (SWindInputSdk)0; GetSpeedTreeWindState(sWindInput.m_sState);
	float tree_height = sWindInput.m_sState.m_vBoundingBoxMax.z - sWindInput.m_sState.m_vBoundingBoxMin.z;
	float tree_top_z = instance_position.z + sWindInput.m_sState.m_vBoundingBoxMax.z * instance_scale;
	float bend_scale = 1.0/max(tree_height*instance_scale, 0.001);
	float3 world_pos_ws = oriented_pos * instance_scale + instance_position;
#if defined(INTERACTION_ON)
	float3 interaction_offset = foliageInteraction(world_pos_ws, instance_position, bend_scale, per_view_camera_position.xyz, tree_height * instance_scale, tree_top_z);
	oriented_pos += interaction_offset / instance_scale;
#endif
	float3 heli_offset = CalculateHelicopterOffset(oriented_pos * instance_scale + instance_position, instance_position, bend_scale);
	oriented_pos += heli_offset;
	output.world_position = float4(oriented_pos * instance_scale + instance_position - per_view_world_origin_offset.xyz, 1.0f);
	output.position = mul(per_view_view_proj_matrix, output.world_position);
	output.clip_position = output.position;
	output.texcoord = float3(input.texcoord0.xy, input.texcoord2.y);
	output.lod_fade_alpha = computeLodFadeAlphaVS(instance_position);
	bool is_orthographic_projection = per_view_view_proj_matrix[3].w == 1;
	if(is_orthographic_projection) { if(output.position.z > 1) output.position.z = 0.99999; }
	return output;
}

SpeedTreeV9VertexOutput_Custom VS_Entry_instance_lit(SpeedTreeV9VertexLayout input)
{
	SpeedTreeV9VertexOutput_Custom output = (SpeedTreeV9VertexOutput_Custom)0;
	FoliageInstanceData instance_data = instance_data_buffer[getInstanceId(input.instance_index)];
	float3 instance_position = instance_data.position;
	float instance_scale = instance_data.scale;
	float4 instance_orientation = instance_data.orientation;
	float lod_coeff = getLodInterp(instance_data, per_view_camera_position.xyz, per_view_projection_matrix);
	if (min_screen_size == 0.0) lod_coeff = 0.0;
	float3 position = input.position.xyz;
	float3 lod_position = float3(input.texcoord1.xy, input.texcoord2.x);
	float3 smooth_position = lerp(position, lod_position, lod_coeff);
	float3 normal, binormal, tangent;
	Utility_UnpackNormalFibonacci3(round(input.normal.xyz * 127.0f + 128.0f), normal, binormal, tangent);
	float3 oriented_pos = quaternionMulVec(instance_orientation, smooth_position);
	float3 oriented_normal = quaternionMulVec(instance_orientation, normal);
	float3 oriented_tangent = quaternionMulVec(instance_orientation, tangent);
	SpeedTreeWind(input, instance_position, instance_scale, 0.0, oriented_pos, oriented_normal);
	SWindInputSdk sWindInput = (SWindInputSdk)0; GetSpeedTreeWindState(sWindInput.m_sState);
	float tree_height = sWindInput.m_sState.m_vBoundingBoxMax.z - sWindInput.m_sState.m_vBoundingBoxMin.z;
	float tree_top_z = instance_position.z + sWindInput.m_sState.m_vBoundingBoxMax.z * instance_scale;
	float bend_scale = 1.0/max(tree_height*instance_scale, 0.001);
	float3 world_pos_ws = oriented_pos * instance_scale + instance_position;
	float3 instance_scale_vec = float3(instance_scale, instance_scale, instance_scale);
#if defined(INTERACTION_ON)
	float3 interaction_offset = foliageInteraction(world_pos_ws, instance_position, bend_scale, per_view_camera_position.xyz, tree_height * instance_scale, tree_top_z);
	oriented_pos += interaction_offset / instance_scale;
#endif
	float3 heli_offset = CalculateHelicopterOffset(oriented_pos * instance_scale + instance_position, instance_position, bend_scale);
	oriented_pos += heli_offset;
	float3 oriented_pos_previous = oriented_pos;
	float4 position_world = calcWorldPosition(instance_position, instance_scale, instance_orientation, oriented_pos);
	output.world_position = float4(oriented_pos * instance_scale + instance_position - per_view_world_origin_offset.xyz, 1.0f);
	output.position = output.world_position;
	output.object_position = mul(per_view_view_matrix, output.world_position);
#if defined(SHADING_PATH_MOBILE)
	output.object_position = position_world;
#endif
	output.position = mul(per_view_view_proj_matrix, output.position);
	output.clip_position = output.position;
	if (per_frame_temperal_effect_enabled.x == 1.0)
	{
		float3 oriented_pos_previous = quaternionMulVec(instance_orientation, smooth_position);
		float3 oriented_normal_previous = float3(0.0f, 0.0f, 0.0f);
		SpeedTreeWind(input, instance_position, instance_scale, per_frame_previous_time.x - per_frame_time.x, oriented_pos_previous, oriented_normal_previous);
		float3 world_pos_ws_previous = oriented_pos_previous * instance_scale + instance_position;
#if defined(INTERACTION_ON)
		float3 interaction_offset_previous = foliageInteraction(world_pos_ws_previous, instance_position, bend_scale, per_view_camera_previous_position.xyz, tree_height * instance_scale, tree_top_z);
		oriented_pos_previous += interaction_offset_previous / instance_scale;
#endif
		float3 heli_offset_previous = CalculateHelicopterOffset(oriented_pos_previous * instance_scale + instance_position, instance_position, bend_scale, per_frame_previous_time.x - per_frame_time.x);
		oriented_pos_previous += heli_offset_previous;
		output.previous_clip_position.xyz = oriented_pos_previous * instance_scale + instance_position - per_view_previous_world_origin_offset.xyz;
		output.previous_clip_position.w = 1.0f;
		output.previous_clip_position = mul(per_view_previous_view_proj_matrix, output.previous_clip_position);
	}
	output.texcoord = float3(input.texcoord0.xy, input.texcoord2.y);
	output.normal_ao.w = input.normal.w;
	output.normal_ao.xyz = oriented_normal;
	output.tangent = oriented_tangent;
	if (normal_sphere_self > 0.0)
	{
		float3 sphere_center = instance_position.xyz + instance_postion_normal_offset.xyz;
		float3 sphere_normal = normalize(output.world_position.xyz - sphere_center);
		output.normal_ao.xyz = normalize(lerp(oriented_normal, sphere_normal, normal_sphere_self));
		float3 ref_up = abs(output.normal_ao.xyz.z) < 0.999 ? float3(0, 0, 1) : float3(1, 0, 0);
		float3 sphere_tangent = normalize(cross(ref_up, output.normal_ao.xyz));
		output.tangent = normalize(lerp(oriented_tangent, sphere_tangent, normal_sphere_self));
		output.tangent = normalize(output.tangent - dot(output.tangent, output.normal_ao.xyz) * output.normal_ao.xyz);
	}
	output.lod_fade_alpha = computeLodFadeAlphaVS(instance_position);
	return output;
}
#endif

float cal_fresnel(float nDotV, float exponent = 5.0, float baseReflectFraction = 0.04)
{ return max(pow(max(abs(1 - max(0, nDotV)), 0.0001), exponent), 0) * (1.0 - baseReflectFraction) + baseReflectFraction; }

float3 desaturation(float3 input, float fraction)
{ float3 LuminanceFactors = float3(0.3,0.59,0.11); return lerp(input, dot(input, LuminanceFactors), fraction); }

float3 primaryColorCorrection(float3 input, float saturation, float3 tint_color, float brightness, float contrast)
{ float3 output = desaturation(input, 1.0f - saturation) * tint_color.rgb * brightness; output = pow(output, contrast); output = max(output, 0); return output; }

float ComputeHeightBlendMask(float mesh_z, float ground_z, float noise, float height_add, float terrain_blend_range, float terrain_blend_contrast, bool revert)
{ float blend_pos = mesh_z - ground_z; blend_pos = blend_pos / max(terrain_blend_range, 1e-5); blend_pos += noise * noise_intense - height_add; float mask = blend_pos; mask = pow(mask, terrain_blend_contrast); mask = saturate(mask); if (revert) mask = 1.0 - mask; return mask; }

#include "core/gbuffer/gbuffer_mr.hlsli"
#if defined(SHADING_PIPELINE_FORWARD)
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

#if defined(PIXEL_SHADER)

float4 terrain_pos_lb;
float4 terrain_ref_height_info_array[k_max_chunk_count]; 
CHAOS_DECLARE_TEX2DARRAY(terrain_block_height_map_array_for_mesh);

float GetHeightForMesh(float2 world_pos_xy)
{ int2 block_xy = (world_pos_xy - terrain_pos_lb.xy) / k_terrain_block_size; int block_index = clamp(block_xy.y * terrain_pos_lb.z + block_xy.x, 0, k_max_chunk_count - 1); int array_index = terrain_ref_height_info_array[block_index].y; int ref_height = terrain_ref_height_info_array[block_index].x; float2 chunk_lb_pos = terrain_pos_lb.xy + float2(block_xy) * k_terrain_block_size; float2 height_map_uv_xy = (world_pos_xy - chunk_lb_pos) / k_terrain_block_size; float3 height_map_uv = float3(height_map_uv_xy, array_index); float2 packed_value = CHAOS_SAMPLE_TEX2DARRAY_LOD(terrain_block_height_map_array_for_mesh, height_map_uv, 0.0).xy; float height = decodeHeightmapR8G8(packed_value); return height + ref_height; }

int isInVirtualArea(float2 dpos) { if (dpos.x > 0.0f && dpos.y > 0.0f && dpos.x < terrain_virtual_area.z && dpos.y < terrain_virtual_area.w) return 1; return 0; }

uint getPageIdFromRefPosition(float2 dpos, float lod) { float2 page_table_uv = dpos / terrain_virtual_area.zw; page_table_uv.y = 1.0f - page_table_uv.y; uint page_id; bool is_valid = GetPageTableId(terrain_page_table_texture, page_table_uv, 0.0f, page_id); return page_id; }

TerrainMaterialParameters getTerrainMaterialParameters(float3 world_position, float3 world_normal, float terrain_height)
{ float3 tighten_factor = float3(0.2, 0.2, 0.2); TerrainMaterialParameters terrain_paras = (TerrainMaterialParameters)0; float x_sign_value = sign(dot(world_normal, float3(-1, 0, 0))); float y_sign_value = sign(dot(world_normal, float3(0, -1, 0))); float height_diff = world_position.z - terrain_height; float3 position_ref_cam = world_position.xyz - per_view_camera_position.xyz; float2 pos_ref_virtual_area_xy = position_ref_cam.xy - terrain_virtual_area.xy; float2 pos_ref_virtual_area_xz = pos_ref_virtual_area_xy + float2(0, 1) * y_sign_value * height_diff; float2 pos_ref_virtual_area_yz = pos_ref_virtual_area_xy + float2(1, 0) * x_sign_value * height_diff; uint page_id_xy = getPageIdFromRefPosition(pos_ref_virtual_area_xy, 0); uint page_id_xz = getPageIdFromRefPosition(pos_ref_virtual_area_xz, 0); uint page_id_yz = getPageIdFromRefPosition(pos_ref_virtual_area_yz, 0); if (isInVirtualArea(pos_ref_virtual_area_xy) && isInVirtualArea(pos_ref_virtual_area_xz) && isInVirtualArea(pos_ref_virtual_area_yz) && IsValidPageId(page_id_xy) && IsValidPageId(page_id_xz) && IsValidPageId(page_id_yz)) { float2 physical_uv_x = GetPhysicalTextureUV(pos_ref_virtual_area_yz, page_id_yz, terrain_physical_page_size, terrain_physical_page_border_size, page_scale_factor); float2 physical_uv_y = GetPhysicalTextureUV(pos_ref_virtual_area_xz, page_id_xz, terrain_physical_page_size, terrain_physical_page_border_size, page_scale_factor); float2 physical_uv_z = GetPhysicalTextureUV(pos_ref_virtual_area_xy, page_id_xy, terrain_physical_page_size, terrain_physical_page_border_size, page_scale_factor); float3 albedo_x = CHAOS_SAMPLE_TEX2D(terrain_albedo_physical_texture, physical_uv_x).rgb; float3 albedo_y = CHAOS_SAMPLE_TEX2D(terrain_albedo_physical_texture, physical_uv_y).rgb; float3 albedo_z = CHAOS_SAMPLE_TEX2D(terrain_albedo_physical_texture, physical_uv_z).rgb; float3 normal_x = unpackNormalMap(CHAOS_SAMPLE_TEX2D(terrain_normal_physical_texture, physical_uv_x).yx); float3 normal_y = unpackNormalMap(CHAOS_SAMPLE_TEX2D(terrain_normal_physical_texture, physical_uv_y).yx); float3 normal_z = unpackNormalMap(CHAOS_SAMPLE_TEX2D(terrain_normal_physical_texture, physical_uv_z).yx); normal_x.y = -normal_x.y; normal_y.y = -normal_y.y; normal_z.y = -normal_z.y; float3 pack_x = CHAOS_SAMPLE_TEX2D(terrain_pack_physical_texture, physical_uv_x).rgb; float3 pack_y = CHAOS_SAMPLE_TEX2D(terrain_pack_physical_texture, physical_uv_y).rgb; float3 pack_z = CHAOS_SAMPLE_TEX2D(terrain_pack_physical_texture, physical_uv_z).rgb; float3 blend_weight = saturate(abs(world_normal) - tighten_factor); blend_weight /= (blend_weight.x + blend_weight.y + blend_weight.z); terrain_paras.base_color = (albedo_x * blend_weight.x + albedo_y * blend_weight.y + albedo_z * blend_weight.z) * terrain_map_mutiplier.rgb; terrain_paras.normal = (normal_x * blend_weight.x + normal_y * blend_weight.y + normal_z * blend_weight.z) * terrain_map_normal_intensity; terrain_paras.roughness = (pack_x.r * blend_weight.x + pack_y.r * blend_weight.y + pack_z.r * blend_weight.z) + terrain_map_roughness_add; terrain_paras.metallic = (pack_x.g * blend_weight.x + pack_y.g * blend_weight.y + pack_z.g * blend_weight.z) + terrain_map_metallic_add; } return terrain_paras; }

#if defined(NEAR_CLIP_ON)
float CircularNearClip(float2 screen_pos, float3 world_position, int jitter_frame_index, float alpha, float outer_radius, float min_opacity)
{ float dither = temporalDither2(screen_pos, jitter_frame_index); float2 noise_sample_uv = screen_pos / float2(64.0, 64.0); float4 noise_value = CHAOS_SAMPLE_TEX2D_LOD(noise_map, noise_sample_uv, 0); float animated_dither = (dither + noise_value.r) * (1.0 / 6.0); float3 character_pos = per_frame_character_position.xyz; float dist = distance(world_position.xy, character_pos.xy); float dist_factor = saturate(dist / max(0.001, outer_radius)); float opacity_multiplier = lerp(min_opacity, 1.0, dist_factor); float final_alpha = alpha * opacity_multiplier; return final_alpha - animated_dither; }
#endif

// Depth pass: NO LOD fade dither (preserves shadows)
float4 PS_Entry_depth_only_with_clip(SpeedTreeV9DepthVertexOutput_Custom input) : CHAOS_TARGET_OUTPUT0
{ 
	float opacity_mask_value = CHAOS_SAMPLE_TEX2D(base_color_opacity_map, input.texcoord.xy).a;
	clip(opacity_mask_value - alpha_clip_value);
#if defined(NEAR_CLIP_ON)
	int jitter_frame_index = (int)(per_frame_temperal_effect_enabled.y + 0.1);
	float2 screen_uv = input.clip_position.xy / input.clip_position.w;
	float2 screen_pos = (screen_uv * 0.5 + 0.5) * float2(1920, 1080);
	float clip_val = CircularNearClip(screen_pos, input.world_position.xyz, jitter_frame_index, opacity_mask_value, nearclip_range, nearclip_max_translucent);
	clip(clip_val); 
#endif
	return float4(0,0,0,1);
}

// Tree ID Pass - outputs instance ID for editor picking
int4 PS_Entry_tree_id_main(SpeedTreeV9DepthVertexOutput_Custom input) : CHAOS_TARGET_OUTPUT0
{
	float opacity_mask_value = CHAOS_SAMPLE_TEX2D(base_color_opacity_map, input.texcoord.xy).a;
	clip(opacity_mask_value - alpha_clip_value);
	FoliageInstanceData instance_data = instance_data_buffer[input.instance_id];
	return int4(1, asint(render_entity_id), asint(instance_data.id), 0);
}

float assembleOpacityMaskDepthOnly(PixelParameters pixel_params) { return CHAOS_SAMPLE_TEX2D(base_color_opacity_map, pixel_params.uvs[0]).w; }

void assembleMaterialParams_(PixelParameters pixel_params, float input_ao, float lod_mip_level, inout MaterialParameters material_params)
{
	float2 sample_uv = pixel_params.uvs[0] * uv_scale_offset.xy + uv_scale_offset.zw;
	
	// When LOD blur is active (lod_mip_level > 0), use explicit mip level sampling for blur effect
	// When not in transition (lod_mip_level == 0), use normal hardware-filtered sampling
	float4 base_color_opacity_value;
	float4 normal_value;
	float4 ors_value;
	
#if defined(LOD_FADE_ON)
	if (lod_mip_level > 0.01)
	{
		base_color_opacity_value = CHAOS_SAMPLE_TEX2D_LOD(base_color_opacity_map, sample_uv, lod_mip_level);
		normal_value = CHAOS_SAMPLE_TEX2D_LOD(normal_map, sample_uv, lod_mip_level);
		ors_value = CHAOS_SAMPLE_TEX2D_LOD(ors_mask_map, sample_uv, lod_mip_level);
	}
	else
#endif
	{
		base_color_opacity_value = CHAOS_SAMPLE_TEX2D(base_color_opacity_map, sample_uv);
		normal_value = CHAOS_SAMPLE_TEX2D(normal_map, sample_uv);
		ors_value = CHAOS_SAMPLE_TEX2D(ors_mask_map, sample_uv);
	}

#if defined(SUBSURFACE_ON)
	float4 subsurface_color_value;
	#if defined(LOD_FADE_ON)
	if (lod_mip_level > 0.01)
		subsurface_color_value = CHAOS_SAMPLE_TEX2D_LOD(subsurface_color_map, sample_uv, lod_mip_level);
	else
	#endif
		subsurface_color_value = CHAOS_SAMPLE_TEX2D(subsurface_color_map, sample_uv);
	float3 subsurface_color = primaryColorCorrection(subsurface_color_value.rgb, subsurface_saturation, subsurface_color_multiplier.rgb, subsurface_brightness, subsurface_contrast) * subsurface_color_value.a;
	material_params.subsurface_color = subsurface_color;
#endif
	float3 base_color = primaryColorCorrection(base_color_opacity_value.rgb, base_color_saturation, base_color_multiplier.rgb, base_color_brightness, base_color_contrast);
	float opacity_mask_value = base_color_opacity_value.a;
	float roughness = pow(ors_value.g * roughness_scale, roughness_contrast);
	float ao = lerp(1.0f, max(ors_value.r, input_ao), ao_scale);
	float specular = 0.5f;
#ifdef FRENSEL_ENABLE
	float ndotv = dot(pixel_params.world_normal.xyz, pixel_params.view_direction); float fresnel = cal_fresnel(ndotv); specular = lerp(specular_value * ors_value.b, fresnel_amount - 1.0f, fresnel);
#else
	specular = specular_value * ors_value.b;
#endif
	float3 local_normal = decodeNormalFromNormalMapValueBC5(normal_value);
	if (normal_sphere_self > 0.0) local_normal.xy *= saturate(1.0 - normal_sphere_self * 0.8);
	else local_normal *= pixel_params.is_front_face_float;
	
	// Flatten normal detail during LOD blur to reduce popping
#if defined(LOD_FADE_ON)
	if (lod_mip_level > 0.01)
	{
		float normal_flatten = saturate(lod_mip_level / max(lod_blur_strength, 0.01));
		local_normal.xy *= (1.0 - normal_flatten * 0.6);
		local_normal = normalize(local_normal);
	}
#endif
	
	float3 world_normal = normalize(mul(local_normal, pixel_params.TBN));
	material_params.base_color = base_color; material_params.normal = world_normal; material_params.metallic = 0.0f; material_params.density = density_value; material_params.roughness = roughness; material_params.emissive_color = 0.0f; material_params.ao = ao; material_params.dielectric_specular_multiplier = specular; material_params.shade_mode = SHADE_MODE_TWO_SIDED_FOLIAGE; material_params.opacity_mask = opacity_mask_value;
#if defined(Z_TERRAIN_BLEND_ON)
	float3 worldPos = pixel_params.world_position.xyz; float ground_world_height = GetHeightForMesh(worldPos.xy); TerrainMaterialParameters terrain_para = getTerrainMaterialParameters(worldPos, world_normal, ground_world_height); float noise = CHAOS_SAMPLE_TEX2D(noise_map, worldPos.xy).r; float mask = ComputeHeightBlendMask(worldPos.z, ground_world_height, noise, height_add, terrain_blend_range, terrain_blend_contrast, true); material_params.base_color = lerp(material_params.base_color, terrain_para.base_color, mask); material_params.normal = normalize(mul(lerp(local_normal, terrain_para.normal, mask), pixel_params.TBN)); material_params.roughness = lerp(material_params.roughness, terrain_para.roughness, mask); material_params.metallic = lerp(material_params.metallic, terrain_para.metallic, mask);
#endif
}

void customClip(PixelParameters pixel_params, MaterialParameters material_params, float lod_fade_alpha)
{
	clip(material_params.opacity_mask - alpha_clip_value);
#if defined(NEAR_CLIP_ON)
	float2 screen_pos = pixel_params.clip_position.xy / pixel_params.clip_position.w;
	screen_pos = (screen_pos * 0.5 + 0.5) * float2(1920, 1080); 
	float clip_val = CircularNearClip(screen_pos, pixel_params.world_position.xyz, pixel_params.jitter_frame_index, material_params.opacity_mask, nearclip_range, nearclip_max_translucent);
	clip(clip_val);
#endif
#if defined(LOD_FADE_ON)
	if (lod_fade_alpha < 0.999)
	{
		float2 lod_spos = pixel_params.clip_position.xy / pixel_params.clip_position.w;
		lod_spos = (lod_spos * 0.5 + 0.5) * float2(1920, 1080);
		float dither = temporalDither2(lod_spos, pixel_params.jitter_frame_index);
		float2 noise_uv = lod_spos / float2(64.0, 64.0);
		float noise_val = CHAOS_SAMPLE_TEX2D_LOD(noise_map, noise_uv, 0).r;
		float animated_dither = (dither + noise_val) * (1.0 / 3.0);
		float remapped_fade = lod_fade_alpha * (2.0 / 3.0);
		clip(remapped_fade - animated_dither);
	}
#endif
}

PixelParameters GetPixelParameters(float3 texcoord0, float4 normal_ao, float3 tangent, float4 clip_position, float4 previous_clip_position, float4 object_position, float4 world_position, CHAOS_IS_FRONT_FACE_TYPE is_front_face)
{
	PixelParameters params = (PixelParameters)0;
	params.uvs[0] = texcoord0.xy; params.world_normal = c_half4(normal_ao.xyz, 1.0); params.world_tangent = float4(tangent, 1.0f); params.TBN = calcTBNMatrix(c_half4(params.world_tangent), c_half4(params.world_normal));
#if defined(SHADING_PATH_MOBILE)
	params.world_position = object_position;
#endif
	params.world_position = world_position; params.clip_position = clip_position; params.prev_clip_position = previous_clip_position; params.is_front_face_float = GetFloatFacingSign(is_front_face); params.view_direction = normalize(per_view_camera_position.xyz - params.world_position.xyz); params.light_direction = -per_level_main_light_direction.xyz; params.is_temporal_enable = per_frame_temperal_effect_enabled.x; params.jitter_frame_index = (int)(per_frame_temperal_effect_enabled.y + 0.1); params.dither_clip_offset = per_frame_temperal_effect_enabled.z; params.transparency_distance_threshold = per_frame_temperal_effect_enabled.w; params.linear_depth = params.clip_position.w; params.screen_uvz = float3(screenUVFromNDCxy(params.clip_position.xy/params.clip_position.w), params.clip_position.z/params.clip_position.w); params.jitter_projection_offset = per_view_proj_offset;
	return params;
}

float4 PS_Entry_forward_scene(SpeedTreeV9VertexOutput_Custom input, in CHAOS_IS_FRONT_FACE_TYPE is_front_face : CHAOS_IS_FRONT_FACE) : CHAOS_TARGET_OUTPUT0
{
	float4 forward_color = float4(0.0f,0.0f,0.0f,1.0f);
	PixelParameters pixel_params = GetPixelParameters(input.texcoord, input.normal_ao, input.tangent, input.clip_position, input.previous_clip_position, input.object_position, input.world_position, is_front_face);
	MaterialParameters material_params = (MaterialParameters)0;
	initializeMaterialParameters(material_params, pixel_params.TBN);
	
	// Compute LOD blur mip level
	float2 blur_uv = pixel_params.uvs[0] * uv_scale_offset.xy + uv_scale_offset.zw;
	float lod_mip_level = computeLodBlurMipLevel(blur_uv, input.lod_fade_alpha);
	assembleMaterialParams_(pixel_params, input.normal_ao.w, lod_mip_level, material_params);
	customClip(pixel_params, material_params, input.lod_fade_alpha);
	SurfaceData surface_data = materialParamConvertToSurfaceData(material_params, pixel_params.world_position.xyz, pixel_params.clip_position.w);
	forward_color.rgb = shadeOnePixel(surface_data, pixel_params.screen_uvz.xy, per_view_camera_position) + material_params.emissive_color;
	LightAccum ambient_light = ApplyEnvironmentLightingInForwardShading(pixel_params.screen_uvz.xy, per_view_camera_position.xyz, surface_data, pixel_params.screen_uvz.z, per_view_proj_matrix_info, per_view_view_matrix);
	forward_color.rgb += ambient_light.diffuse + ambient_light.specular;
	float4 fog_color = getFogColor(surface_data.world_position, pixel_params.clip_position);
	forward_color.a = material_params.opacity_mask;
	forward_color.rgb = forward_color.rgb * PreExposure * fog_color.a + fog_color.rgb * PreExposure;
	return forward_color;
}

CommonPixelOutput PS_Entry_mars_speedtree_deferred(SpeedTreeV9VertexOutput_Custom input, in CHAOS_IS_FRONT_FACE_TYPE is_front_face : CHAOS_IS_FRONT_FACE)
{
	CommonPixelOutput pixel_output = (CommonPixelOutput)0;
	PixelParameters pixel_params = GetPixelParameters(input.texcoord, input.normal_ao, input.tangent, input.clip_position, input.previous_clip_position, input.object_position, input.world_position, is_front_face);
	MaterialParameters material_params = (MaterialParameters)0;
	initializeMaterialParameters(material_params, pixel_params.TBN);
	
	// Compute LOD blur mip level
	float2 blur_uv = pixel_params.uvs[0] * uv_scale_offset.xy + uv_scale_offset.zw;
	float lod_mip_level = computeLodBlurMipLevel(blur_uv, input.lod_fade_alpha);
	assembleMaterialParams_(pixel_params, input.normal_ao.w, lod_mip_level, material_params);
	ModifyMaterialParamsUsingDebugMode(pixel_params, material_params);
#ifdef MATERIAL_ENABLE_DEPTH_OFFSET
	ApplyPixelDepthOffset(pixel_params, material_params, pixel_output.depth);
#endif
	customClip(pixel_params, material_params, input.lod_fade_alpha);
	ApplySpecularAA(pixel_params.TBN[2], material_params.roughness);
	material_params.emissive_color *= PreExposure;
	GBufferData gbuffer_data;
	gbuffer_data = EncodeMaterialToGbuffer(material_params);
	EncodeVelocityBuffer(pixel_params.is_temporal_enable, pixel_params.clip_position, pixel_params.prev_clip_position, pixel_params.jitter_projection_offset, gbuffer_data.velocity);
	packGbufferToOutput(gbuffer_data, pixel_output);
	return pixel_output;
}

#endif

technique tree_geometry
{
	pass depth_only
	{
#if defined(VERTEX_SHADER)
		VertexShader = compile vs_5_0 VS_Entry_instance_depth_only_with_clip(); 
#endif
#if defined(PIXEL_SHADER)
		PixelShader = compile ps_5_0 PS_Entry_depth_only_with_clip(); 
#endif
	}
	pass default_pass
	{
#if defined(VERTEX_SHADER)
		VertexShader = compile vs_5_0 VS_Entry_instance_lit();
#endif
#if defined(PIXEL_SHADER)
		PixelShader = compile ps_5_0 PS_Entry_mars_speedtree_deferred();
#endif
	}
	pass forward_shading_default
	{
#if defined(VERTEX_SHADER)
		VertexShader = compile vs_5_0 VS_Entry_instance_lit();
#endif
#if defined(PIXEL_SHADER)
		PixelShader = compile ps_5_0 PS_Entry_forward_scene();
#endif
	}
	pass pick_tree_id
	{
#if defined(VERTEX_SHADER)
		VertexShader = compile vs_5_0 VS_Entry_instance_depth_only_with_clip(); 
#endif
#if defined(PIXEL_SHADER)
		PixelShader = compile ps_5_0 PS_Entry_tree_id_main();
#endif
	}
}
#endif