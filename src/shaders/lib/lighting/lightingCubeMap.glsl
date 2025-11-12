vec4 lightingCubeMap(
    samplerCube map,
    vec3 view,
    vec3 normal
)
{

    return texture( map, reflect( - view, normal ) );
    
}