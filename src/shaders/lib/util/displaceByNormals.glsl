// basic normal deform

vec3 displaceByNormals(
    vec3 pos, // vertex position
    vec3 norm, // vertex normals
    float time, // time for animation
    sampler2D displacement, // texture to displace by
    vec2 uv, // texture coordinates
    float displaceOffset, // offset multiplier
    float direction, // direction of the displace position or uv individual value
    float speed // speed of the animation
)
{

    float normalDisplace = texture( displacement, uv ).r;

    float normalsAnimate = normalDisplace * ( sin( direction * speed + time ) * 0.5 + 0.5 );

    vec3 normalsDisplaced = norm * normalsAnimate * displaceOffset;

    return pos + normalsDisplaced;

}