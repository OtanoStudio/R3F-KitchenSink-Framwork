vec2 uvCalc(
    vec3 viewDir,
    vec3 normal
)
{

    vec3 x = normalize( vec3( viewDir.z, 0.0, - viewDir.x ) );
    vec3 y = cross( viewDir, x );

    vec2 uv = vec2( dot( x, normal ), dot( y, normal ) ) * 0.495 + 0.5;

    return uv;

}