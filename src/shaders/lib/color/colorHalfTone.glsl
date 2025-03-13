vec3 colorHalfTone(
    vec3 color,
    vec2 resolution,
    float reps,
    vec3 direction,
    float low,
    float high,
    vec3 pointColor,
    vec3 normal
)
{
    vec2 uv = gl_FragCoord.xy / resolution.y;

    float intensity = dot( normal, direction );
    intensity = smoothstep( low, high, intensity );
    uv *= reps;
    uv = mod( uv, 1. );

    float point = distance( uv, vec2(0.5 ) );
    point = 1. - step( 0.5 * intensity, point );

    return mix( color, pointColor, point );

}
// used for a noise that you'd map to 2 colors using mix
float colorHalfTone( vec2 uv, float noise, float gridSize, float dotSize )
{
    vec2 uvGrid = ( uv * gridSize ) - gridSize;
    uvGrid = mod( uvGrid, 1.0 );

    float gridDot = distance( uvGrid, vec2( 0.5 ) );
    gridDot = 1.0 - step( dotSize * noise, gridDot );

    return gridDot;
}