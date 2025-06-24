float positionDistance( 
    vec3 position, // position of the mesh vertex as a uniform
    vec3 worldPosition // world space position of the mesh vertex (modelMatrix * vec4( position, 1.0 )).xyz;
    float radius; // radius of the sphere 
)
{

    float dist = distance( position, worldPosition );

    return 1.0 - clamp( dist / radius, 0.0, 1.0 );

}