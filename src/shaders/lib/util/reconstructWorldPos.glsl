vec3 reconstructWorldPos(
    vec2 uv,
    float depth,
    mat4 invProjMat,
    mat4 invViewMat,
    int renderType,
)
{

    vec3 NDC = vec3(0.0 );

    switch( renderType )
    {
        case 0:
            NDC = vec3(uv, depth)  * 2.0 - 1.0;
        break;

        case 1:
            NDC = vec3(uv  * 2.0 - 1.0, depth);
        break;

        default:
            NDC = vec3(uv, depth)  * 2.0 - 1.0;
        break;
    }

    vec4 world = invViewMat * invProjMat * vec4(NDC, 1.0);
    world.xyz /= world.w;

    return world.xyz;

}