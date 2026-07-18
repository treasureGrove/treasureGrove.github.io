#include "core/common/global_constants.hlsli"
#include "core/common/chaos_hlsl_support.hlsli"
#include "core/common/texture_sampler.hlsli"
#include "core/vertex_shader_factory/vertex_common.hlsli"
#include "custom_render_target/custom_render_target_utility.hlsli"

CHAOS_DECLARE_TEX2D_NO_SAMPLER(colorSource);
CHAOS_DECLARE_TEX2D(heightSource);
CHAOS_DECLARE_TEX2D(track_map);

float2 coverage;
float SideLength;
float fadeDuration;

float3 currentPosition;
float3 previousPosition;
float3 centerPosition;
float deltaTime;
float4 rotation;
float4x4 render_target_view_proj_matrix;

struct RenderTargetOutput{
	float4  color  : CHAOS_TARGET_OUTPUT0;
	float  height : CHAOS_TARGET_OUTPUT1;
};

struct VS_Input
{
	float3 position : POSITION;
	float3 normal	: NORMAL;
	float4 tangent	: TANGENT;
	float4 color	: COLOR0;
	float2 uv0		: TEXCOORD0;
};

struct VS_Output
{	
	float4 position     : CHAOS_POSITION_OUTPUT;
	float3 world_normal : NORMAL;
	float3 world_tangent: TANGENT;
	float2 uv0			: TEXCOORD0;
};

float3 quaternionRotateVector(float4 q, float3 v) {
    float3 t = 2.0 * cross(q.xyz, v);
    return v + q.w * t + cross(q.xyz, t);
}
#if defined(VERTEX_SHADER)
void VS_Entry_TrailQuad(in  float4 pos : POSITION,
				    out float2 out_texcoord : TEXCOORD0,
				    out float4 out_position : CHAOS_POSITION_OUTPUT)
{
	out_position = pos;
	out_position.z = 0.0f;
	
	out_texcoord = pos.xy * 0.5f;
	out_texcoord.y *= -1.0f;
	out_texcoord.xy += float2(0.5f, 0.5f);
}
#endif

#if defined(VERTEX_SHADER)
VS_Output VS_Entry_TrailMesh(VS_Input input)
{
	VS_Output output = (VS_Output)0;
	
	//output.position  = calcWorldPosition(per_instance_matrixes[5].xyz, per_instance_matrixes[6].xyz, per_instance_matrixes[7], input.position);
	//output.position  = mul(render_target_view_proj_matrix, output.position);
	//output.position.xy = output.position.xy * -1.f;
	//output.uv0 = input.uv0;
	
	return output;
}
#endif

float4 SpiralBlurTexture(float2 uv)
{
    const int TOTAL_SAMPLES =16;
    const float DISTANCE_PIXELS = 16.0f;
    const float TWISTS = 1.0f;          
    const float ROTATION = 0.0f;         
    const float KERNEL_POWER = 1.0f;
    const float this_pi = 3.14159265359f;

    float2 texel_size = 1.0f / coverage;
    float max_texel = max(texel_size.x, texel_size.y);
    float max_radius = DISTANCE_PIXELS * max_texel;

    float4 accum = float4(0.0f,0.0f,0.0f,0.0f);
    float weightSum = 0.0f;

    for (int i = 0; i < TOTAL_SAMPLES; ++i)
    {
        float t = (i + 0.5f) / (float)TOTAL_SAMPLES;
        float radius = t * max_radius;
        float angle = t * TWISTS * 2.0f * this_pi + ROTATION;
        float2 offs = float2(cos(angle), sin(angle)) * radius;
        float2 sampleUV = uv + offs;

        if (all(sampleUV >= 0.0f) && all(sampleUV <= 1.0f))
        {
            float4 s = CHAOS_SAMPLE_TEX2D(track_map, sampleUV);
            float w = pow(1.0f - t, KERNEL_POWER);
            accum += s * w;
            weightSum += w;
        }
    }

    return (weightSum > 0.0f) ? (accum / weightSum) : CHAOS_SAMPLE_TEX2D(track_map, uv);
}
#if defined(PIXEL_SHADER)
RenderTargetOutput PS_Entry_TrailCopyFade(float2 uv: TEXCOORD0)
{
	RenderTargetOutput output;
    float2 distance = currentPosition.xy - previousPosition.xy;
    float2 copySourceUV = uv + distance / coverage * float2(1.0f, -1.0f);

    bool isValidUV = all(copySourceUV <= 1.0f) && all(copySourceUV >= 0.0f);

	// float alpha = 0.0f;
	// CHAOS_BRANCH if (isValidUV){
	// 	alpha = CHAOS_SAMPLE_TEX2D(colorSource, copySourceUV).a;
	// 	CHAOS_BRANCH if (alpha < 0.01f){
	// 		alpha = 0.0f;
	// 	}
			
	// }

	// float back_position = uv.y;
	

	// float fadeValue = getFadeValueLinear(deltaTime, fadeDuration);
	

	// float fade_start = back_position;
	// float position_fade = saturate((fadeValue - fade_start + 0.5f) / 0.5f); 
	
	float fadeValue = getFadeValueLinear(deltaTime, fadeDuration);


    float4 sourceValue = isValidUV ? CHAOS_SAMPLE_TEX2D_SAMPLER(colorSource, CHAOS_GLOBAL_SAMPLER_WRAP_LINEAR,copySourceUV).xyzw : 0.0f; 
	sourceValue.a *= 1-fadeValue;
	if (sourceValue.a < 0.01f){
		sourceValue = 0.0f;
	}

    output.color =sourceValue;
	output.height = isValidUV ? CHAOS_SAMPLE_TEX2D(heightSource, copySourceUV).r : 0.0f;
	
	return output;
}
#endif

#if defined(PIXEL_SHADER)
RenderTargetOutput PS_Entry_TrailRender(float2 uv: TEXCOORD0)
{	
	RenderTargetOutput output;
    float2 texelWorldPosition = (uv * float2(1.0f, -1.0f) + float2(-0.5f, 0.5f)) * coverage + centerPosition.xy;
	float2 texelLocalPosition = WorldToLocalXY(texelWorldPosition, currentPosition.xy, rotation);
	float2 texelTrackUV = (texelLocalPosition / SideLength - float2(-0.5f, 0.5f)) * float2(1.0f, -1.0f);
	
	bool isValidTrackUV = all(texelTrackUV <= 1.0f) && all(texelTrackUV >= 0.0f);
	if(isValidTrackUV == false)
		discard;
	
	float4 colorResult = CHAOS_SAMPLE_TEX2D(track_map, texelTrackUV).rgba;
	// float4 colorBlurResult = SpiralBlurTexture(texelTrackUV);
	// if(colorResult.a > 0.1){
	// 	colorResult.a =0;
	// }else{
	// 	colorResult.a =1;
	// }
	// colorResult = colorBlurResult;
    // if(colorResult.a < 1e-3) discard;

    // float3 localNormal;
    // localNormal.xy = colorResult.xy * 2.0f - 1.0f;

    // localNormal.z = sqrt(max(0.0f, 1.0f - dot(localNormal.xy, localNormal.xy)));

    // float3 normal = quaternionRotateVector(rotation, localNormal);
	colorResult.a = 0.8f;
    output.color = colorResult;
	output.height = currentPosition.z;
	
	return output;
}
#endif

#if defined(PIXEL_SHADER)
RenderTargetOutput PS_Entry_TrailRenderMesh()
{
	RenderTargetOutput output;
	
	output.color = float4(1.0f, 0.0f, 0.0f, 1.0f);
	output.height = 1.0f;
	
	return output;
}
#endif

technique actor_trail
{
    pass trail_copy_fade
    {
#if defined(VERTEX_SHADER)
        VertexShader = compile vs_5_0 VS_Entry_TrailQuad();
#endif
#if defined(PIXEL_SHADER)
        PixelShader = compile ps_5_0 PS_Entry_TrailCopyFade();
#endif
    }

    pass trail_render
    {
#if defined(VERTEX_SHADER)
        VertexShader = compile vs_5_0 VS_Entry_TrailQuad();
#endif
#if defined(PIXEL_SHADER)
        PixelShader = compile ps_5_0 PS_Entry_TrailRender();
#endif
    }
	
	pass trail_render_mesh
    {
#if defined(VERTEX_SHADER)
        VertexShader = compile vs_5_0 VS_Entry_TrailMesh();
#endif
#if defined(PIXEL_SHADER)
        PixelShader = compile ps_5_0 PS_Entry_TrailRenderMesh();
#endif
    }
}