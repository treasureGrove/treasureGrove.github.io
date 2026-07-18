//#group Trail_intensity = {index(1)}
//#param float edge_step_factor = {default(0.35), group(Trail_intensity), index(1)};
//#param float edge_range_min = {default(0.01), group(Trail_intensity), index(2)};
//#param float edge_range_max = {default(0.35), group(Trail_intensity), index(3)};
//#param float edge_strength_scale = {min(0.0), max(100.0), default(1.0), group(Trail_intensity), index(4)};
//#param float tilt_edge_min = {default(0.03), group(Trail_intensity), index(5)};
//#param float tilt_edge_max = {default(0.65), group(Trail_intensity), index(6)};
//#param float tilt_strength_scale = {min(0.0), max(100.0), default(1.0), group(Trail_intensity), index(7)};

//#group Water_intensity = {index(2)}
//#param float water_transition = {min(0.0), max(100), default(1.0), group(Water_intensity), index(2)};
//#param float water_contrast = {min(0.0), max(100), default(1.0), group(Water_intensity), index(3)};
//#param float water_roughness = {min(0.0), max(1.0), default(0.0), group(Water_intensity), index(4)};
//#param float water_edgeFalloff_strength = {min(0.0), max(100.0), default(5.0), group(Water_intensity), index(5)};
//#param float water_edgeFalloff_distance = {min(0.0), max(100.0), default(12.0), group(Water_intensity), index(6)};
//#param float water_opacity = {min(0.0), max(100.0), default(1.0), group(Water_intensity), index(7)};
//#param float inner_min = {min(0.0), max(1.0), default(0.2), group(Water_intensity), index(8)};
//#param float inner_max = {min(0.0), max(10.0), default(0.4), group(Water_intensity), index(9)};

//#group Detail_settings = {index(3)}
//#param float bump_scale = {min(0.0), max(10.0), default(1.0), group(Detail_settings), index(1)};
//#param float height_scale = {default(0.1), group(Detail_settings), index(2)};
//#param float max_step = {min(1.0), max(30.0), default(12.0), group(Detail_settings), index(3)};
//#param float min_step = {min(1.0), max(30.0), default(5.0), group(Detail_settings), index(4)};
//#param float detail_uv_scale = {min(0.0), max(100.0), default(1.0), group(Detail_settings), index(5)};

#include "core/common/global_constants.hlsli"
#include "core/common/chaos_hlsl_support.hlsli"
#include "core/common/reconstruct_position.hlsli"
#include "core/common/common_transformation.hlsli"

CHAOS_DECLARE_TEX2D(color);
CHAOS_DECLARE_TEX2D(scene_depth);
CHAOS_DECLARE_TEX2D(tank_trail_normal);
CHAOS_DECLARE_TEX2D(tank_trail_detail_height);
CHAOS_DECLARE_TEX2D(noise_map);


float edge_step_factor;
float edge_range_min;
float edge_range_max;
float edge_strength_scale;
float tilt_edge_min;
float tilt_edge_max;
float tilt_strength_scale;

float water_transition;
float water_contrast;
float water_roughness;
float water_edgeFalloff_strength;
float water_edgeFalloff_distance;
float water_opacity;
float inner_min;
float inner_max;

float bump_scale;
float height_scale;
float max_step;
float min_step;
float detail_uv_scale;

float2 coverage;
float3 centerPosition;
float4x4 prev_view_proj_matrix;

float4x4 InverseMatrix(float4x4 m)
{
    float n11 = m[0][0], n12 = m[1][0], n13 = m[2][0], n14 = m[3][0];
    float n21 = m[0][1], n22 = m[1][1], n23 = m[2][1], n24 = m[3][1];
    float n31 = m[0][2], n32 = m[1][2], n33 = m[2][2], n34 = m[3][2];
    float n41 = m[0][3], n42 = m[1][3], n43 = m[2][3], n44 = m[3][3];

    float t11 = n23 * n34 * n42 - n24 * n33 * n42 + n24 * n32 * n43 - n22 * n34 * n43 - n23 * n32 * n44 + n22 * n33 * n44;
    float t12 = n14 * n33 * n42 - n13 * n34 * n42 - n14 * n32 * n43 + n12 * n34 * n43 + n13 * n32 * n44 - n12 * n33 * n44;
    float t13 = n13 * n24 * n42 - n14 * n23 * n42 + n14 * n22 * n43 - n12 * n24 * n43 - n13 * n22 * n44 + n12 * n23 * n44;
    float t14 = n14 * n23 * n32 - n13 * n24 * n32 - n14 * n22 * n33 + n12 * n24 * n33 + n13 * n22 * n34 - n12 * n23 * n34;

    float det = n11 * t11 + n21 * t12 + n31 * t13 + n41 * t14;
    float idet = 1.0f / det;

    float4x4 ret;

    ret[0][0] = t11 * idet;
    ret[0][1] = (n24 * n33 * n41 - n23 * n34 * n41 - n24 * n31 * n43 + n21 * n34 * n43 + n23 * n31 * n44 - n21 * n33 * n44) * idet;
    ret[0][2] = (n22 * n34 * n41 - n24 * n32 * n41 + n24 * n31 * n42 - n21 * n34 * n42 - n22 * n31 * n44 + n21 * n32 * n44) * idet;
    ret[0][3] = (n23 * n32 * n41 - n22 * n33 * n41 - n23 * n31 * n42 + n21 * n33 * n42 + n22 * n31 * n43 - n21 * n32 * n43) * idet;

    ret[1][0] = t12 * idet;
    ret[1][1] = (n13 * n34 * n41 - n14 * n33 * n41 + n14 * n31 * n43 - n11 * n34 * n43 - n13 * n31 * n44 + n11 * n33 * n44) * idet;
    ret[1][2] = (n14 * n32 * n41 - n12 * n34 * n41 - n14 * n31 * n42 + n11 * n34 * n42 + n12 * n31 * n44 - n11 * n32 * n44) * idet;
    ret[1][3] = (n12 * n33 * n41 - n13 * n32 * n41 + n13 * n31 * n42 - n11 * n33 * n42 - n12 * n31 * n43 + n11 * n32 * n43) * idet;

    ret[2][0] = t13 * idet;
    ret[2][1] = (n14 * n23 * n41 - n13 * n24 * n41 - n14 * n21 * n43 + n11 * n24 * n43 + n13 * n21 * n44 - n11 * n23 * n44) * idet;
    ret[2][2] = (n12 * n24 * n41 - n14 * n22 * n41 + n14 * n21 * n42 - n11 * n24 * n42 - n12 * n21 * n44 + n11 * n22 * n44) * idet;
    ret[2][3] = (n13 * n22 * n41 - n12 * n23 * n41 - n13 * n21 * n42 + n11 * n23 * n42 + n12 * n21 * n43 - n11 * n22 * n43) * idet;

    ret[3][0] = t14 * idet;
    ret[3][1] = (n13 * n24 * n31 - n14 * n23 * n31 + n14 * n21 * n33 - n11 * n24 * n33 - n13 * n21 * n34 + n11 * n23 * n34) * idet;
    ret[3][2] = (n14 * n22 * n31 - n12 * n24 * n31 - n14 * n21 * n32 + n11 * n24 * n32 + n12 * n21 * n34 - n11 * n22 * n34) * idet;
    ret[3][3] = (n12 * n23 * n31 - n13 * n22 * n31 + n13 * n21 * n32 - n11 * n23 * n32 - n12 * n21 * n33 + n11 * n22 * n33) * idet;

    return ret;
}
void recontructTB(float3 N, float3 p, float2 uv,
out float3 T, out float3 B)
{
    // get edge vectors of the pixel triangle
    float3 dp1 = ddx(p);
    float3 dp2 = ddy(p);
    float2 duv1 = ddx(uv);
    float2 duv2 = ddy(uv);

    float3 dp2perp = cross(dp2, N);
    float3 dp1perp = cross(N, dp1);
    T = dp2perp * duv1.x + dp1perp * duv2.x;
    B = dp2perp * duv1.y + dp1perp * duv2.y;

    // construct a scale - invariant frame
    float invmax = max(dot(T, T), dot(B, B));
    invmax = 1.0f / sqrt(invmax);

    T *= invmax;
    B *= invmax;
}

float2 BlendAngleCorrectedNormalsPack(float2 base_packed_01, float2 detail_packed_01, float inner_mask)
{
    float2 base_xy = base_packed_01 * 2.0f - 1.0f;
    float2 detail_xy = (detail_packed_01 * 2.0f - 1.0f) * bump_scale * inner_mask;

    float3 n1 = float3(base_xy, sqrt(saturate(1.0f - dot(base_xy, base_xy))));
    float3 n2 = float3(detail_xy, sqrt(saturate(1.0f - dot(detail_xy, detail_xy))));

    float3 t = n1 + float3(0.0f, 0.0f, 1.0f);
    float3 u = n2 * float3(- 1.0f, - 1.0f, 1.0f);
    float3 blended = normalize(t * dot(t, u) - u * t.z);

    return saturate(blended.xy * 0.5f + 0.5f);
}

float2 parallaxMapping(CHAOS_DECLARE_TEX2D_LOCAL(height_map), float3 view_dir, float depthscale, float max_step, float min_step, float2 uv)
{
    float Alpha = dot(float3(0, 0, 1), view_dir);

    float viewZ = abs(view_dir.z);
    if(viewZ < 0.001)
    {
        return uv;
    }

    float LayerNum = floor(lerp(max_step, min_step, clamp(abs(Alpha), 0, 1)));
    LayerNum = max(LayerNum, 1.0);
    float LayerDepth = 1.0 / LayerNum;

    float2 DeltaUV = view_dir.xy / max(viewZ, 0.001) / LayerNum * depthscale;

    float maxDelta = 0.05;
    DeltaUV = clamp(DeltaUV, - maxDelta, maxDelta);

    float2 CurrentUV = uv;
    float CurrentLayerDepth = 0;
    float CurrentTexDepth = 1 - CHAOS_SAMPLE_TEX2D(height_map, uv).r;

    int maxIterations = (int)LayerNum + 2;
    int iteration = 0;
    [loop]
    while(CurrentLayerDepth < CurrentTexDepth && iteration < maxIterations)
    {
        CurrentUV -= DeltaUV;
        CurrentTexDepth = 1 - CHAOS_SAMPLE_TEX2D(height_map, CurrentUV).r;
        CurrentLayerDepth += LayerDepth;
        iteration ++;
    }

    float2 PreUV = CurrentUV + DeltaUV;
    float Current = abs(CurrentTexDepth - CurrentLayerDepth);
    float Pre = abs((1 - CHAOS_SAMPLE_TEX2D(height_map, PreUV).r) - (CurrentLayerDepth - LayerDepth));

    float divisor = Current + Pre;
    float Weight = divisor > 0.0001 ? Current / divisor : 0.5;
    Weight = saturate(Weight);

    return lerp(CurrentUV, PreUV, Weight);
}
float height_lerp(float height, float contrast, float transition)
{
    height = clamp(height - 1.0f + transition * 2.0f, 0, 1);
    height = clamp(lerp(0.0f - contrast, contrast + 1.0f, height), 0.0f, 1.0f);
    return height;
}

#if defined(VERTEX_SHADER)
void VS_Entry_Trail(in float4 pos : POSITION,
out float2 out_texcoord : TEXCOORD0,
out float4 out_position : CHAOS_POSITION_OUTPUT)
{
    out_position = pos;
    out_position.z = 0.0f;



    out_texcoord = pos.xy * 0.5f;
    out_texcoord.y *= - 1.0f;
    out_texcoord.xy += float2(0.5f, 0.5f);
}
#endif

#if defined(PIXEL_SHADER)

struct PS_Output
{
    float4 color : CHAOS_CHAOS_TARGET_OUTPUT0;
    float depth : CHAOS_DETPH_OUTPUT;
};

PS_Output PS_Entry_TrailGBuffer(float2 uv : TEXCOORD0) : CHAOS_TARGET_OUTPUT0
{
    PS_Output output;
    float4 result = float4(0.f, 0.f, 0.f, 0.f);

    float4x4 prev_inv_view_proj = InverseMatrix(prev_view_proj_matrix);

    float depth = CHAOS_SAMPLE_TEX2D(scene_depth, uv).r;
    float2 curr_ndc_xy;
    curr_ndc_xy = uv * 2.0f - 1.0f;
    curr_ndc_xy.y *= - 1.0f;

    float4 curr_clip = float4(curr_ndc_xy, depth, 1.0);

    float4 curr_world_homo = mul(per_view_inverse_view_proj_matrix, curr_clip);
    float3 curr_world = curr_world_homo.xyz / curr_world_homo.w;

    float4 clip_prev = mul(prev_view_proj_matrix, float4(curr_world, 1.0));

    float2 prev_ndc = clip_prev.xy / clip_prev.w;
    float2 prev_uv;
    prev_uv.x = prev_ndc.x * 0.5 + 0.5;
    prev_uv.y = 0.5 - prev_ndc.y * 0.5;

    if (any(prev_uv < 0.0) || any(prev_uv > 1.0))
    {
        discard;
    }

    float prev_depth = CHAOS_SAMPLE_TEX2D(scene_depth, prev_uv).r;

    float3 world_position = computeWorldPosition(prev_uv, prev_depth, prev_inv_view_proj);

    float2 rt_uv = ((world_position.xy - centerPosition.xy) / coverage - float2(- 0.5f, 0.5f)) * float2(1.0f, - 1.0f);
    bool isValidRtUV = all(rt_uv <= 1.0f) && all(rt_uv >= 0.0f);




    if(isValidRtUV == false)
    discard;

    // float rt_height = CHAOS_SAMPLE_TEX2D_LOD(color_height, rt_uv, 0).r;
    // if(rt_height - world_position.z < - 10.f)
    // discard;

    float4 macro_data = CHAOS_SAMPLE_TEX2D_LOD(color, rt_uv, 0);


    float2 rt_texel_size = 0.5f / coverage;
    float alpha_right = CHAOS_SAMPLE_TEX2D_LOD(color, rt_uv + float2(rt_texel_size.x, 0), 0).a;
    float alpha_left = CHAOS_SAMPLE_TEX2D_LOD(color, rt_uv - float2(rt_texel_size.x, 0), 0).a;
    float alpha_up = CHAOS_SAMPLE_TEX2D_LOD(color, rt_uv + float2(0, rt_texel_size.y), 0).a;
    float alpha_down = CHAOS_SAMPLE_TEX2D_LOD(color, rt_uv - float2(0, rt_texel_size.y), 0).a;

    float2 alpha_gradient = float2(alpha_right - alpha_left, alpha_up - alpha_down);
    float edge_strength = length(alpha_gradient) * edge_strength_scale;
    float edge_factor = smoothstep(edge_range_min, edge_range_max, edge_strength);


    if(macro_data.a < 0.05f && edge_factor < 0.08f) discard;

    float2 detail_uv = world_position.xy * detail_uv_scale;


    float detail_height = CHAOS_SAMPLE_TEX2D(tank_trail_detail_height, detail_uv).r;

    float2 edge_normal_unpacked = float2(0, 0); // 默认平坦

    if (edge_strength > 0.005f) {

        float tilt_strength = smoothstep(tilt_edge_min, tilt_edge_max, edge_strength) * 0.5f * tilt_strength_scale;
        edge_normal_unpacked = - normalize(alpha_gradient) * tilt_strength;
    }


    float2 blended_normal_packed;

    if (edge_factor < 0.02f) {

        blended_normal_packed = float2(0.5f, 0.5f);
    } else {

        blended_normal_packed = clamp(edge_normal_unpacked * 0.5f + 0.5f, 0.1f, 0.9f);
    }





    //Parallax mapping
    float3 N, T, B;
    N = float3(0.0f, 0.0f, 1.0f);
    T = float3(0.0f, 1.0f, 0.0f);
    B = float3(1.0f, 0.0f, 0.0f);

    N = reconstructNormalFromWorldPosition(world_position);
    float3 prev_view = normalize(per_view_camera_previous_position.xyz - world_position.xyz);
    recontructTB(N, prev_view, detail_uv, T, B);
    float3x3 TBN = float3x3(T, B, N);
    float3 local_view_dir = normalize(mul(prev_view, transpose(TBN)));
    float weight = 1;
    if(per_frame_temperal_effect_enabled.x){
        float2 screen_uv = uv;
        float2 screen_pos = screen_uv * float2(1920, 1080);
        screen_pos += (int)(per_frame_temperal_effect_enabled.y + 0.1);
        weight = ((screen_pos.x) + 2 * (screen_pos.y)) % 5.0f;
        screen_uv *= float2(64, 64);
        float noise = CHAOS_SAMPLE_TEX2D(noise_map, screen_uv).r;
        weight += noise;
        weight /= 0.166666;
        weight = lerp(0.0f, 1.2f, weight);
    }
    detail_uv = parallaxMapping(CHAOS_TEXTURE_2D(tank_trail_detail_height), local_view_dir, height_scale, max_step * weight, min_step, detail_uv);

    float4 tank_trail_normal_map = CHAOS_SAMPLE_TEX2D(tank_trail_normal, detail_uv);
    //water_mask calculation
    float water_mask = 1 - CHAOS_SAMPLE_TEX2D(tank_trail_detail_height, detail_uv).r;
    water_mask = height_lerp(water_mask, water_contrast, water_transition);
    // float edge01 = smoothstep(edge_range_min, edge_range_max, edge_strength);
    // float edge01 = smoothstep(edge_range_min, edge_range_max, edge_strength); // 边缘 = 1
    // float inner_mask = 1.0f - smoothstep(inner_min, inner_max, edge01);
    // water_mask *= inner_mask;
    float edge01 = edge_strength;
    // hard inner mask (1 inside inner_min, 0 otherwise)
    float hardInner = 1.0f - step(inner_min, edge01);
    // soft falloff between inner_min and inner_max
    float softFalloff = 1.0f - smoothstep(inner_min, inner_max, edge01);
    // use the harder of the two so interior stays 1 and edge fades out smoothly
    float inner_mask = max(hardInner, softFalloff);
    inner_mask = saturate(inner_mask);

    water_mask = clamp(water_mask * inner_mask, 0.0f, 1.0f);

    float2 detail_normal_packed = tank_trail_normal_map.rg;
    float2 final_normal_packed = BlendAngleCorrectedNormalsPack(blended_normal_packed, detail_normal_packed, inner_mask);

    result = float4(final_normal_packed.xy, water_mask, macro_data.a); //xy : normal(BC5 0 - 1) b : roughness a : blendFactor


    if(macro_data.a < 0.01f && edge_factor < 0.05f) discard;

    output.color = result;
    return output;
}
#endif

technique trail_view_draw
{
    pass trail_view_draw
    {
        #if defined(VERTEX_SHADER)
        VertexShader = compile vs_5_0 VS_Entry_Trail();
        #endif
        #if defined(PIXEL_SHADER)
        PixelShader = compile ps_5_0 PS_Entry_TrailGBuffer();
        #endif
    }
}


