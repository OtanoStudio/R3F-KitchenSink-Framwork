float translucency( 
    vec3 lightDir, 
    vec3 viewDir, 
    vec3 normal, 
    float distortion, 
    float power )
{
    lightDir = normalize(lightDir);
    viewDir = normalize(viewDir);
    normal = normalize(normal);

    vec3 distortedLight = normalize(lightDir + normal * distortion);

    float transDot = max(dot(viewDir, -distortedLight), 0.0);

    return pow(transDot, power);
}

float translucency( 
    vec3 lightDir, 
    vec3 normal, 
    float distortion
)
{

    return pow(
        clamp(dot( -lightDir, normal), 0.0, 1.0 ),
        distortion
    );

}