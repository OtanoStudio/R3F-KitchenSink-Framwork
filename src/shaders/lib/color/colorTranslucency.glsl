float translucency( 
    vec3 lightDir, 
    vec3 viewDir, 
    vec3 normal, 
    float distortion, 
    float strength )
{

    vec3 H = normalize( -lightDir + normal * distortion );

    return pow(
        clamp(dot(viewDir, -H), 0.0, 1.0 ),
        strength
    );

}

float translucency( 
    vec3 lightDir, 
    vec3 normal, 
    float distortion
)
{

    return pow(
        clamp(dot( -lightDir, normal), 0.0, 1.0 ),
        strength
    );

}