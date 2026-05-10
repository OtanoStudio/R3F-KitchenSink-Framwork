vec4 parallaxImage(
    sampler2D color,
    sampler2D depthText,
    vec2 uv,
    vec2 mouseCoords,
    float intensity
)
{

    float depthSample = texture( depthText, uv ).r;

    float depth = dot( depthSample, vec3( 0.299, 0.587, 0.114 ) );

    vec2 displacement = mouseCoords * depth * intensity;

    uv += displacement;

    return texture( color, uv );

}