// resolution is the image or screen size.

vec4 blurKuwase(
    sampler2D screenTexture, 
    vec2 uv, 
    vec2 resolution, 
    float offset
) 
{

    vec2 halfpixel = (1.0 / resolution) / 2.0;
    
    vec4 sum = texture(screenTexture, uv + vec2(-halfpixel.x * 2.0, 0.0) * offset);
    sum += texture(screenTexture, uv + vec2(-halfpixel.x, halfpixel.y) * offset) * 2.0;
    sum += texture(screenTexture, uv + vec2(0.0, halfpixel.y * 2.0) * offset);
    sum += texture(screenTexture, uv + vec2(halfpixel.x, halfpixel.y) * offset) * 2.0;
    sum += texture(screenTexture, uv + vec2(halfpixel.x * 2.0, 0.0) * offset);
    sum += texture(screenTexture, uv + vec2(halfpixel.x, -halfpixel.y) * offset) * 2.0;
    sum += texture(screenTexture, uv + vec2(0.0, -halfpixel.y * 2.0) * offset);
    sum += texture(screenTexture, uv + vec2(-halfpixel.x, -halfpixel.y) * offset) * 2.0;
    
    return sum / 12.0;

}