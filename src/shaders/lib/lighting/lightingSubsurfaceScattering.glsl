vec3 lightingSubsurfaceScattering(
    vec3 normal,
    vec3 viewDir,
    vec3 lightDir,
    vec3 lightColor,
    vec3 sssColor,
    float thickness,
    float distortion,
    float power,
    float scale,
    float ambient,
    bool backlighting
)
{
    
    vec3 distortedLight = normalize(lightDir + normal * distortion );

    float transmission = pow(
        max( dot(viewDir, -distortedLight ), 0.0 ),
        power
    );

    if( backlighting ) transmission *= max( dot( -normal, lightDir ), 0.0 );

    transmission *= thickness;
    transmission *= scale;

    return lightColor * sssColor * ( transmission + ambient * thickness );

}