float3 Desaturation(float3 input, float fraction)
{
    float3 LuminanceFactors = float3(0.3,0.59,0.11);

    return lerp(input,dot(input,LuminanceFactors),fraction);
}
float3 primaryColorCorrection(float3 input, float saturation, float3 tint_color, float brightness, float contrast)
{
    float3 output = Desaturation(input, 1.0f - saturation) * tint_color.rgb * brightness;
    output = pow(output, contrast);
    output = max(output,0);
    return output;
}
float CheapContrast(float inScale, float Contrast)
{
    return saturate(lerp(0 - Contrast, Contrast + 1.0, inScale));
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
float nearClipHexahedron(
    PixelParameters pixel_params,
    float noise_value,
    float alpha = 1,
    float topWidth = 3,
    float topHeight = 3,
    float bottomWidth = 5,
    float bottomHeight = 6,
    float transition = 2,
    float MaxTranslucent = 0.65)
{
    // Dither
    float2 screen_pos = pixel_params.sv_clip_position.xy;
    float dither = temporalDither2(screen_pos, pixel_params.jitter_frame_index);
    float animated_dither = (dither + noise_value) * (1.0 / 6.0);

    // Trapezoidal Hexahedron Mask
    float3 character_position = per_frame_character_position.xyz + float3(0, -0.1, 0);

    float3 zAxis = normalize(character_position - per_view_camera_position.xyz);
    float3 up    = float3(0,0,1);
    float3 xAxis = normalize(cross(up, zAxis));
    float3 yAxis = cross(zAxis, xAxis);

    float3 localPos = pixel_params.world_position - per_view_camera_position.xyz;

    float projZ = dot(localPos, zAxis);
    float projX = dot(localPos, xAxis);
    float projY = dot(localPos, yAxis);

    float VolumeHeight = length(character_position - per_view_camera_position.xyz);

    float lambda = saturate(projZ / VolumeHeight);

    float width  = lerp(bottomWidth, topWidth, lambda);
    float height = lerp(bottomHeight, topHeight, lambda);

    float dx = projX;
    float dy = projY;

    float maskX = saturate((width  * 0.5 - abs(dx)) / transition);
    float maskY = saturate((height * 0.5 - abs(dy)) / transition);

    float maskZ_in = step(0, projZ) * step(projZ, VolumeHeight);
    float maskFull = maskZ_in * maskX * maskY;

    return animated_dither + alpha * clamp(1.0 - maskFull, MaxTranslucent, 1.0) - 0.5f;
}