#if defined(PIXEL_SHADER)
//To use this shader, add the following to your shader:

//#param sampler2D noise_map = {default(flat_white_d), group(TerrainBlend), index(-5)};
//#group TerrainBlend = {index(10)}
//#param float terrain_blend_range = {min(0.1), max(20.0), default(1.0), group(TerrainBlend), index(0)};
//#param float terrain_blend_contrast = {min(0), max(20.0), default(0.5), group(TerrainBlend), index(1)};
//#param float height_add = {min(- 20.0), max(20.0), default(0.2), group(TerrainBlend), index(2)};
//#param float noise_intense = {min(- 1.0), max(1.0), default(0.0), group(TerrainBlend), index(3)}
//#param float4 terrain_map_mutiplier = {default(1.0, 1.0, 1.0, 1.0), group(TerrainBlend), index(-1)};
//#param float terrain_map_roughness_add = {min(- 1.0), max(1.0), default(0.0), group(TerrainBlend), index(-2)};
//#param float terrain_map_metallic_add = {min(- 1.0), max(1.0), default(0.0), group(TerrainBlend), index(-3)};
//#param float terrain_map_normal_intensity = {min(0.0), max(10.0), default(1.0), group(TerrainBlend), index(-4)};




CHAOS_DECLARE_TEX2D(noise_map);
CHAOS_DECLARE_TEX2D_FORMAT(terrain_page_table_texture, uint);
CHAOS_DECLARE_TEX2D(terrain_albedo_physical_texture);
CHAOS_DECLARE_TEX2D(terrain_normal_physical_texture);
CHAOS_DECLARE_TEX2D(terrain_pack_physical_texture);

float4 terrain_pos_lb; // pos_x, pos_y, num_x, num_y
float4 terrain_ref_height_info_array[k_max_chunk_count]; // ref_height, pool_index_map, padding, padding
float is_terrain_existed;
CHAOS_DECLARE_TEX2DARRAY(terrain_block_height_map_array_for_mesh);

//Param
//Heihgt_Blend
float terrain_blend_range;
float terrain_blend_contrast;
float height_add;
float noise_intense;
float4 terrain_map_mutiplier;
float terrain_map_roughness_add;
float terrain_map_metallic_add;
float terrain_map_normal_intensity;
//Hidden
float terrain_physical_page_size;
float terrain_physical_page_border_size;
float4 terrain_virtual_area;
float4 terrain_eye_to_visibility_ref;
float page_scale_factor;

float ComputeHeightBlendMask(
    float mesh_z,
    float ground_z,
    float noise,
    float height_add,
    float terrain_blend_range,
    float terrain_blend_contrast,
    float noise_intense,
    bool revert
)
{
    float blend_pos = mesh_z - ground_z;
    blend_pos = blend_pos / max(terrain_blend_range, 1e-5);
    blend_pos += noise * noise_intense - height_add;

    float mask = blend_pos;
    mask = pow(mask, terrain_blend_contrast);
    mask = saturate(mask);

    if (revert)
    {
        mask = 1.0 - mask;
    }
    return mask;
}

int isInVirtualArea(float2 dpos)
{
    if (dpos.x > 0.0f && dpos.y > 0.0f && dpos.x < terrain_virtual_area.z && dpos.y < terrain_virtual_area.w)
    {
        return 1;
    }
    return 0;
}

uint getPageIdFromRefPosition(
    float2 dpos,
    float lod
)
{
    float2 page_table_uv = dpos / terrain_virtual_area.zw;
    page_table_uv.y = 1.0f - page_table_uv.y;

    uint page_id;
    bool is_valid = GetPageTableId(terrain_page_table_texture, page_table_uv, 0.0f, page_id);

    return page_id;
}

TerrainMaterialParameters getTerrainMaterialParameters(
    float3 world_position,
    float3 world_normal,
    float terrain_height
)
{
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

    if (isInVirtualArea(pos_ref_virtual_area_xy) &&
        isInVirtualArea(pos_ref_virtual_area_xz) &&
        isInVirtualArea(pos_ref_virtual_area_yz) &&
        IsValidPageId(page_id_xy) && IsValidPageId(page_id_xz) && IsValidPageId(page_id_yz))
    {
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

        float3 tighten = tighten_factor;
        float3 blend_weight = saturate(abs(world_normal) - tighten);
        blend_weight /= (blend_weight.x + blend_weight.y + blend_weight.z);

        terrain_paras.base_color = albedo_x * blend_weight.x + albedo_y * blend_weight.y + albedo_z * blend_weight.z;
        terrain_paras.base_color *= terrain_map_mutiplier.rgb;
        terrain_paras.normal = normal_x * blend_weight.x + normal_y * blend_weight.y + normal_z * blend_weight.z;
        terrain_paras.normal *= terrain_map_normal_intensity;
        terrain_paras.roughness = pack_x.r * blend_weight.x + pack_y.r * blend_weight.y + pack_z.r * blend_weight.z;
        terrain_paras.roughness += terrain_map_roughness_add;
        terrain_paras.metallic = pack_x.g * blend_weight.x + pack_y.g * blend_weight.y + pack_z.g * blend_weight.z;
        terrain_paras.metallic += terrain_map_metallic_add;
    }

    return terrain_paras;
}

float GetHeightForMesh(float2 world_pos_xy)
{
    if (is_terrain_existed < 0.01f)
    {
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

void ApplyTerrainBlend(
    float3 worldPos,
    float3 worldNormal,
    inout float3 final_base_color,
    inout float3 final_normal,
    inout float final_roughness,
    inout float final_metallic
)
{
    float ground_world_height = GetHeightForMesh(worldPos.xy);
    TerrainMaterialParameters terrain_para = getTerrainMaterialParameters(worldPos, worldNormal, ground_world_height);
    float noise = CHAOS_SAMPLE_TEX2D(noise_map, worldPos.xy).r;
    float mask = ComputeHeightBlendMask(
        worldPos.z,
        ground_world_height,
        noise,
        height_add,
        terrain_blend_range,
        terrain_blend_contrast,
        noise_intense,
        true
    );

    final_base_color = lerp(final_base_color, terrain_para.base_color, mask);
    final_normal = lerp(final_normal, terrain_para.normal, mask);
    final_roughness = lerp(final_roughness, terrain_para.roughness, mask);
    final_metallic = lerp(final_metallic, terrain_para.metallic, mask);
}

#endif // PIXEL_SHADER
