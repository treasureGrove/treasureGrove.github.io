//These options will remove in several months
//But you still need to copy and change these options for different materials
//#asset is_explicit = {true}
//#asset is_deferred = {true}
//#asset shading_mode = {opacue}

//#category alpha_clip
//#option_default off
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

//#category attribute_front_face
//#option_default disable
//#option disable

//#category attribute_world_clip_position
//#option_default enable
//#option enable

//#category attribute_custom_data
//#option_default enable
//#option enable

//#category vertex_input_type
//#option_default standard
//#option standard
//#option nano

// 红开关: 房间格子坐标来源
//   uv         = 原始行为, 格子来自 mesh UV0 (窗户靠 UV 排布)
//   object_pos = 格子/视差改由 object position 自建帧投影 (UV 无关, 立面投影, 舍弃 Z 朝向)
//#category room_projection
//#option_default uv
//#option uv
//#option object_pos

//#category interior_mapping
//#option_default off
//#option on
//#option off

//#category mid_layer
//#option_default off
//#option on
//#option off

//#category glass_reflection
//#option_default off
//#option on
//#option off

//#group BaseValue = {index(0)}
//#param float4 uv_scale_offset={default(1.0,1.0,0.0,0.0), group(BaseValue), index(0)};
//#param float4 base_color_multiplier={default(1.0,1.0,1.0,1.0), group(BaseValue), index(1)};
//#param float metallic_scale={min(0.0), max(10.0), default(1.0), group(BaseValue), index(2)};
//#param float metallic_add={min(0.0), max(1.0), default(0.0), group(BaseValue), index(7)};
//#param float roughness_scale={min(0.0), max(10.0), default(1.0), group(BaseValue), index(3)};
//#param float dielectric_specular_value={min(0.0), max(1000.0), default(0.5), group(BaseValue), index(4)};
//#param float ao_scale={min(0.0), max(10.0), default(1.0), group(BaseValue), index(5)};
//#param float alpha_clip_value={min(0.0), max(1.0), default(0.333), group(BaseValue), index(6)};

//#group Room = {index(1)}
//#param float4 rooms={default(2.0,4.0,16.0,18.0), group(Room), index(0)};
//#param float random_mask_min={min(0.0), max(1.0), default(0.3), group(Room), index(1)};
//#param float random_mask_max={min(0.0), max(1.0), default(1.0), group(Room), index(2)};
//#param float base_pow={min(0.0), max(10.0), default(3.0), group(Room), index(3)};
//#param float base_mul={min(0.0), max(100.0), default(0.3), group(Room), index(4)};
//#param float emissive_pow={min(0.0), max(30.0), default(5.0), group(Room), index(5)};
//#param float emissive_mul={min(0.0), max(100.0), default(1.0), group(Room), index(6)};
//#param float room_depth={min(0.0), max(1.0), default(0.5), group(Room), index(7)};
//#param float4 room_uv_scale_offset={default(1.0,1.0,0.0,0.0), group(Room), index(8)};
//#param float room_blend={min(0.0), max(1.0), default(1.0), group(Room), index(9)};
//#param float room_facing_cutoff={min(0.0), max(1.0), default(0.7), group(Room), index(10)};
//#param float room_height_cutoff={min(-100000.0), max(100000.0), default(100000.0), group(Room), index(11)};
//#param float room_height_fade={min(0.001), max(10000.0), default(1.0), group(Room), index(12)};

//#param sampler2D base_color_opacity_map ={default(_project/textures/default/flat_white_d.texture.ast)};
//#param sampler2D orm_mask_map = {default(_project/textures/default/flat_orm.texture.ast)};
//#param sampler2D normal_map={default(_project/textures/default/flat_n_bc5.texture.ast)};
//#param sampler2D room_tex ={default(_project/textures/default/flat_white_d.texture.ast)};
//#group MidLayer = {index(2)}
//#param sampler2D room_mid_tex ={default(_project/textures/default/flat_white_d.texture.ast)};
//#param float4 mid_rooms={default(4.0,4.0,16.0,18.0), group(MidLayer), index(0)};
//#param float mid_depth={min(0.0), max(1.0), default(0.3), group(MidLayer), index(1)};
//#param float mid_brightness={min(0.0), max(10.0), default(1.0), group(MidLayer), index(2)};

//#group Reflection = {index(3)}
//#param sampler2D matcap_map ={default(_project/textures/default/flat_white_d.texture.ast), group(Reflection), index(0)};
//#param float reflectivity={min(0.0), max(1.0), default(0.3), group(Reflection), index(1)};
//#param float4 reflection_tint={default(1.0,1.0,1.0,1.0), group(Reflection), index(2)};
//#param float fresnel_power={min(0.0), max(10.0), default(4.0), group(Reflection), index(3)};
//#param float fresnel_intensity={min(0.0), max(2.0), default(1.0), group(Reflection), index(4)};
//#param float reflection_intensity={min(0.0), max(10.0), default(1.0), group(Reflection), index(5)};

// ============================================================================
// Vertex custom data: 把 object position 透传给 pixel, 供 ROOM_PROJECTION_OBJECT_POS 使用
// object_pos 走 custom_data1.xyz (纯 object space, 已过骨骼但未乘 instance world 矩阵)
// ============================================================================
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
#include "core/vertex_shader_factory/animation_vertex_common.hlsli"
#include "core/vertex_shader_factory/default_input.hlsli"
#include "core/vertex_shader_factory/input_output_common.hlsli"
#include "core/gpu_driven/gpu_primitive_common.hlsli"
#include "core/vertex_shader_factory/vertex_parameters.hlsli"

float4 customObjectTransformation(float4 input_object_position, CommonVertexShaderAccessibleParameters parameters) {
    return input_object_position;
}

float4 customPreviousObjectTransformation(float4 input_previous_object_position, CommonVertexShaderAccessibleParameters parameters) {
    return input_previous_object_position;
}

float4 customWorldTransformation(float4 input_world_position, CommonVertexShaderAccessibleParameters parameters) {
    return input_world_position;
}

float4 customPreviousWorldTransformation(float4 input_previous_world_position, CommonVertexShaderAccessibleParameters parameters) {
    return input_previous_world_position;
}

#ifdef ATTRIBUTE_CUSTOM_DATA_ENABLE
void customOutputAssembling(CommonVertexShaderAccessibleParameters input, inout CustomDataInOutput custom_data) {
    // object space 顶点坐标 (未乘 instance world), 房间随物体走
    custom_data.custom_data1 = float4(input.object_position.xyz, 1.0);
    custom_data.custom_data2 = float4(0.0, 0.0, 0.0, 0.0);
    custom_data.custom_data3 = float4(0.0, 0.0, 0.0, 0.0);
    custom_data.custom_data4 = float4(0.0, 0.0, 0.0, 0.0);
    return;
}
#endif

#include "core/gbuffer/gbuffer_mr.hlsli"
// for forward shading
#include "core/pixel_shader_factory/forward_shading_common.hlsli"
#include "core/common/reconstruct_position.hlsli"
#include "core/light/surface_data_common.hlsli"
#include "core/light/light_common.hlsli"
#include "core/light/environment_lighting/environment_lighting.hlsli"
#include "core/atmosphere/atmosphere_common.hlsli"
// can be customized
#include "core/material/material_template.hlsli"
#include "core/pixel_shader_factory/pixel_inoutput.hlsli"
#include "core/material/material_surface_convert.hlsli"

#if defined(PIXEL_SHADER)

CHAOS_DECLARE_TEX2D(base_color_opacity_map);
CHAOS_DECLARE_TEX2D(orm_mask_map); // x: ao, y: roughess, z: metallic
CHAOS_DECLARE_TEX2D(normal_map);
CHAOS_DECLARE_TEX2D(room_tex);
CHAOS_DECLARE_TEX2D(room_mid_tex);
CHAOS_DECLARE_TEX2D(matcap_map);

float4 uv_scale_offset;
float4 room_uv_scale_offset;
float4 base_color_multiplier;
float4 rooms;
float random_mask_min;
float random_mask_max;
float metallic_scale;
float metallic_add;
float roughness_scale;
float ao_scale;
float dielectric_specular_value;
float room_blend;
float room_facing_cutoff;
float room_height_cutoff;
float room_height_fade;
float room_depth;
float base_pow;
float base_mul;
float emissive_pow;
float emissive_mul;
float mid_depth;
float mid_brightness;
float4 mid_rooms;
float reflectivity;
float4 reflection_tint;
float fresnel_power;
float fresnel_intensity;
float reflection_intensity;

#ifdef ALPHA_CLIP_ON
float alpha_clip_value;
#endif

float assembleOpacityMaskDepthOnly(PixelParameters pixel_params) {
    return CHAOS_SAMPLE_TEX2D(base_color_opacity_map, pixel_params.uvs[0]).w;
}

float2 rand2_id(float co) {
    return frac(sin(co * float2(12.9898,78.233)) * 43758.5453);
}

float random (float2 st) {
    return frac(sin(dot(floor(st.xy),
                float2(12.9898,78.233)))*
        43758.5453123);
}

// per-cell hash: 对负整数格子索引分布稳定, 避免 object space 下房间规律重复
float2 hashCell2(float2 cell) {
    float seed = dot(cell, float2(127.1, 311.7));
    return frac(sin(seed) * float2(43758.5453, 24634.6345));
}

float hashCell1(float2 cell, float2 salt) {
    return frac(sin(dot(cell, salt)) * 43758.5453);
}

void assembleMaterialParams(PixelParameters pixel_params,inout MaterialParameters material_params) {
    float2 sample_uv = pixel_params.uvs[0] * uv_scale_offset.xy + uv_scale_offset.zw;

    // ========================================================================
    // 红开关: room_uv (房间格子坐标) 的来源
    //   ROOM_PROJECTION_OBJECT_POS: 用 object position 在自建 (T,B) 帧上投影
    //   否则(uv): 沿用原始 mesh UV
    // 视差用的切向基 tangentViewDir 也随之切换, 保证格子与视差在同一坐标帧
    // ========================================================================
#if defined(ROOM_PROJECTION_OBJECT_POS)
    // 自建投影帧: 舍弃 Z 朝向, 只在 +-X / +-Y 墙面之间选主轴; B(竖直)恒为世界 Z
    float3 obj_pos = pixel_params.custom_data.custom_data1.xyz;
    float3 fn      = pixel_params.world_normal.xyz;

    float3 Nf = (abs(fn.x) >= abs(fn.y)) ? float3(sign(fn.x), 0.0, 0.0)
    : float3(0.0, sign(fn.y), 0.0);
    float3 B  = float3(0.0, 0.0, 1.0);   // 房间竖直 = 世界上, 楼层线恒垂直
    float3 T  = cross(B, Nf);            // 水平切向; cross 保证正/反面墙手性一致 (不里朝外)

    float2 proj    = float2(dot(obj_pos, T), dot(obj_pos, B));
    float2 room_uv = proj * room_uv_scale_offset.xy * rooms.zw + room_uv_scale_offset.zw;
#else
    float2 room_uv = pixel_params.uvs[0] * room_uv_scale_offset.xy * rooms.zw + room_uv_scale_offset.zw;
#endif

    // room uvs
    float2 roomUV = frac(room_uv);
    float2 roomIndexUV = floor(room_uv);

    // Per-room 随机选 atlas cell (2x4 = 8 个不同房间)
#if defined(ROOM_PROJECTION_OBJECT_POS)
    float2 atlasOffset = floor(hashCell2(roomIndexUV) * rooms.xy);
#else
    float2 atlasOffset = floor(rand2_id(roomIndexUV.x + roomIndexUV.y * (roomIndexUV.x + 1)) * rooms.xy);
#endif

#if defined(INTERIOR_MAPPING_ON)
    // Specify depth manually
    float farFrac = room_depth;

    // view dir -> box space. object_pos 模式用自建帧, uv 模式用 mesh TBN
#if defined(ROOM_PROJECTION_OBJECT_POS)
    float3 V = -pixel_params.view_direction.xyz;
    float3 tangentViewDir = float3(dot(V, T), dot(V, B), dot(V, Nf));
#else
    float3 tangentViewDir = mul(-pixel_params.view_direction.xyz, transpose(pixel_params.TBN));
#endif

    //remap [0,1] to [+inf,0]
    //->if input _RoomDepth = 0    -> depthScale = 0      (inf depth room)
    //->if input _RoomDepth = 0.5  -> depthScale = 1
    //->if input _RoomDepth = 1    -> depthScale = +inf   (0 volume room)
    float depthScale = 1.0 / (1.0 - farFrac) - 1.0;

    // raytrace box from view dir
    // normalized box space's ray start pos is on triangle surface, where z = -1
    float3 pos = float3(roomUV * 2 - 1, -1);
    // transform input ray dir from tangent space to normalized box space
    tangentViewDir.z *= -depthScale;

    // 预先处理倒数  t=(1-p)/view=1/view-p/view
    float3 id = 1.0 / tangentViewDir;
    float3 k = abs(id) - pos * id;
    float kMin = min(min(k.x, k.y), k.z);
    pos += kMin * tangentViewDir;

    // Equirectangular mapping: hit position -> spherical direction -> panorama UV
    // No rotation - these are fixed-angle interior captures, not 360 environment maps
    float3 dir = normalize(pos);

    const float INV_2PI = 0.15915494309;
    const float INV_PI  = 0.31830988618;
    float u = atan2(dir.x, dir.z) * INV_2PI + 0.5;
    float v = 1.0 - (asin(clamp(dir.y, -1.0, 1.0)) * INV_PI + 0.5);
    float2 interiorUV = float2(u, v);
#endif

    //Texture Sample
    float4 base_color_opacty_value = CHAOS_SAMPLE_TEX2D(base_color_opacity_map, sample_uv);
    float4 normal                  = CHAOS_SAMPLE_TEX2D(normal_map, sample_uv);
    float4 orm_value               = CHAOS_SAMPLE_TEX2D(orm_mask_map, sample_uv);

#if defined(ROOM_PROJECTION_OBJECT_POS)
    float random_mask = smoothstep(random_mask_min, random_mask_max, hashCell1(roomIndexUV, float2(269.5, 183.3)));
#else
    float random_mask = smoothstep(random_mask_min, random_mask_max, random(room_uv));
#endif

    // ---- facing mask: kill room emission on up/down-facing surfaces (same as random miss, random_mask -> 0) ----
    // world_normal.z near +-1 = facing sky/ground; fade to 0 past room_facing_cutoff
    float facing_z = abs(pixel_params.world_normal.z);
    float facing_mask = 1.0 - smoothstep(room_facing_cutoff, min(room_facing_cutoff + 0.1, 1.0), facing_z);
    random_mask *= facing_mask;

    // ---- height mask: kill emission where world position z exceeds threshold ----
    float height_mask = 1.0 - smoothstep(room_height_cutoff, room_height_cutoff + room_height_fade, pixel_params.world_position.z);
    random_mask *= height_mask;

    // sample room texture: HDR equirectangular atlas (2x4 cells)
#if defined(INTERIOR_MAPPING_ON)
    // cell 内 UV 已在 [0,1], 加 atlasOffset 后除 rooms.xy 落到 atlas 中对应 cell
    float3 room_back = CHAOS_SAMPLE_TEX2D(room_tex, (atlasOffset + interiorUV) / rooms.xy).xyz;

#if defined(MID_LAYER_ON)
    // ============ Mid layer: flat furniture silhouettes ============
    // mid_depth uses same formula as room_depth:
    //   0   = flush with window (no depth)
    //   0.5 = medium depth (depthScale=1)
    //   approaching room_depth = same depth as back wall
    // mid_brightness: intensity multiplier for mid layer color

    // Same depth formula as back wall, just with mid_depth instead of room_depth
    float midFarFrac = clamp(mid_depth, 0.001, 0.999);
    float midDepthScale = 1.0 / (1.0 - midFarFrac) - 1.0;

    // Ray-Box intersection at mid depth (与 back wall 用同一投影帧)
#if defined(ROOM_PROJECTION_OBJECT_POS)
    float3 midV = -pixel_params.view_direction.xyz;
    float3 midTangentViewDir = float3(dot(midV, T), dot(midV, B), dot(midV, Nf));
#else
    float3 midTangentViewDir = mul(-pixel_params.view_direction.xyz, transpose(pixel_params.TBN));
#endif
    midTangentViewDir.z *= -midDepthScale;

    float3 midStartPos = float3(roomUV * 2 - 1, -1);
    float3 midId = 1.0 / midTangentViewDir;
    float3 midK = abs(midId) - midStartPos * midId;
    float midKMin = min(min(midK.x, midK.y), midK.z);
    float3 midHitPos = midStartPos + midKMin * midTangentViewDir;

    // Map mid hit position to UV: just use xy (flat 2D sampling)
    float2 midUV;
    midUV.x = midHitPos.x * 0.5 + 0.5;
    midUV.y = midHitPos.y * 0.5 + 0.5;
    midUV = saturate(midUV);

    // Per-room random mid atlas cell (4x4 = 16 variants, different random seed from back wall)
#if defined(ROOM_PROJECTION_OBJECT_POS)
    float2 midAtlasOffset = floor(hashCell2(roomIndexUV + float2(37.0, 91.0)) * mid_rooms.xy);
#else
    float2 midAtlasOffset = floor(rand2_id(roomIndexUV.x * 3.17 + roomIndexUV.y * (roomIndexUV.x + 7)) * mid_rooms.xy);
#endif

    // Sample mid texture (RGBA - alpha for transparency)
    float4 room_mid = CHAOS_SAMPLE_TEX2D(room_mid_tex, (midAtlasOffset + midUV) / mid_rooms.xy);

    // Composite: mid layer over back wall, with brightness control
    float3 room = lerp(room_back, room_mid.rgb * mid_brightness, room_mid.a) * orm_value.a * random_mask;
#else
    float3 room = room_back * orm_value.a * random_mask;
#endif
#else
    // 非 interior mapping: 直接拿 cell 内的 roomUV 当 equirectangular UV 采样
    float3 room = CHAOS_SAMPLE_TEX2D(room_tex, (atlasOffset + roomUV) / rooms.xy).xyz * orm_value.a * random_mask;
#endif

    float3 room_base_pow = pow(room, base_pow) * base_mul;// 定义参数
    float3 room_emissive_pow = pow(room, emissive_pow) * emissive_mul;// 定义参数

    //pixel 
    float3 base_color_value = base_color_opacty_value.rgb * base_color_multiplier.rgb;
    float opacity_mask_value = base_color_opacty_value.a;

    float metallic_value = saturate(orm_value.b * metallic_scale + metallic_add);
    float roughness_value = orm_value.g * roughness_scale;
    float ao_value = ao_scale * (orm_value.r - 1.0) + 1.0;

    float3 local_normal = decodeNormalFromNormalMapValueBC5(normal);
    float3 normal_value = normalize(mul(local_normal, pixel_params.TBN));

    //out material parameters to gbuffer

    // room_blend interpolates between:
    //   room_blend = 0 -> PBR glass shading (metallic/roughness reflection, no interior)
    //   room_blend = 1 -> interior emissive (room shows through)
    // The two sides fade in/out against each other.
    material_params.base_color = base_color_value + room_base_pow * room_blend;
    material_params.normal = normal_value;
    // Kill PBR reflectivity as the interior takes over (metallic -> 0 when room_blend -> 1)
    material_params.metallic = metallic_value * (1.0 - room_blend);
    material_params.roughness = roughness_value;
    material_params.dielectric_specular_multiplier = dielectric_specular_value;
    material_params.ao = ao_value;

    // ============ Interior emissive (room shows through glass) ============
    // Interior fades in as room_blend -> 1
    float3 interior_emissive = room_emissive_pow * 10000 * room_blend;

#if defined(GLASS_REFLECTION_ON)
    // ============ Glass fake reflection via matcap ============
    // 1. World normal -> view space normal (matcap uses view-space normal)
    float3 view_normal = normalize(mul((float3x3)per_view_view_matrix, normal_value));

    // 2. View-space normal xy -> matcap UV.
    //    Shrink the sampling disc slightly (0.98) to avoid the ugly stretched
    //    edge/seam of the matcap texture at grazing angles.
    float2 matcap_uv = view_normal.xy * 0.5 * 0.98 + 0.5;
    matcap_uv.y = 1.0 - matcap_uv.y;

    // 3. Sample matcap reflection color
    float3 reflection = CHAOS_SAMPLE_TEX2D(matcap_map, matcap_uv).rgb;
    reflection *= reflection_tint.rgb * reflection_intensity;

    // 4. Grazing-angle fade: when the surface is nearly edge-on to the camera,
    //    the matcap samples its distorted rim -> fade reflection out there to hide it.
    //    view_normal.z near 0 = grazing (ugly), near 1 = facing camera (clean).
    float facing = saturate(abs(view_normal.z));
    float edge_fade = smoothstep(0.0, 0.25, facing);  // fade out last ~25% rim
    reflection *= edge_fade;

    // 5. Fresnel term: 1.0 at grazing angle, lower head-on. Used to bend the middle range.
    float NdotV = saturate(dot(normal_value, pixel_params.view_direction));
    float fresnel_amount = pow(1.0 - NdotV, fresnel_power);
    float fresnel_mod = lerp(1.0, fresnel_amount, saturate(fresnel_intensity));

    // 6. Mode B: reflectivity hard-controls both ends.
    //    reflectivity = 0 -> refl_ratio = 0 (pure interior)
    //    reflectivity = 1 -> refl_ratio = 1 (pure reflection)
    //    Fresnel only modulates the transition, and its influence itself fades
    //    to zero at both ends so 0 and 1 stay absolute.
    float mid_weight = 1.0 - abs(reflectivity * 2.0 - 1.0);   // 0 at ends, 1 at middle
    float refl_ratio = reflectivity * lerp(1.0, fresnel_mod, mid_weight);

    // 7. Hide ugly matcap rim: fade reflection out at grazing angles.
    refl_ratio = saturate(refl_ratio * edge_fade);

    // 8. Reflection belongs to the PBR side, so it fades out as interior takes over.
    refl_ratio *= (1.0 - room_blend);

    // 9. Blend interior and reflection, output to emissive
    float3 emissive_scaled = reflection * 10000;  // match interior emissive magnitude
    material_params.emissive_color = lerp(interior_emissive, emissive_scaled, refl_ratio);
#else
    material_params.emissive_color = interior_emissive;
#endif

#ifdef ALPHA_CLIP_ON
    material_params.opacity_mask = opacity_mask_value;
#endif
}

void customClip(PixelParameters pixel_params, MaterialParameters material_params) {
#ifdef ALPHA_CLIP_ON
    clip(material_params.opacity_mask - alpha_clip_value);
#endif
    return;
}

#endif
