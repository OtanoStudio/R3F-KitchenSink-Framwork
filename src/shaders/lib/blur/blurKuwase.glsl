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

vec4 dualKawaseDown(
    sampler2D tex, 
    vec2 uv, 
    vec2 texelSize
) 
{

    vec4 sum = texture2D( tex, uv ) * 4.0;
    sum += texture2D( tex, uv + vec2( -1.0, -1.0 ) * texelSize );
    sum += texture2D( tex, uv + vec2(  1.0, -1.0 ) * texelSize );
    sum += texture2D( tex, uv + vec2( -1.0,  1.0 ) * texelSize );
    sum += texture2D( tex, uv + vec2(  1.0,  1.0 ) * texelSize );

    return sum * 0.125;

}

vec4 dualKawaseUp(
    sampler2D tex, 
    vec2 uv, 
    vec2 texelSize, 
    float radius
) 
{

    vec2 d = texelSize * radius;
    vec4 sum = vec4( 0.0 );
    
    sum += texture2D( tex, uv + vec2( -d.x * 2.0, 0.0 ) );
    sum += texture2D( tex, uv + vec2( -d.x, d.y ) ) * 2.0;
    sum += texture2D( tex, uv + vec2( 0.0, d.y * 2.0 ) );
    sum += texture2D( tex, uv + vec2( d.x, d.y ) ) * 2.0;
    sum += texture2D( tex, uv + vec2( d.x * 2.0, 0.0 ) );
    sum += texture2D( tex, uv + vec2( d.x, -d.y ) ) * 2.0;
    sum += texture2D( tex, uv + vec2( 0.0, -d.y * 2.0 ) );
    sum += texture2D( tex, uv + vec2( -d.x, -d.y ) ) * 2.0;
    
    return sum * 0.08333333333;

}