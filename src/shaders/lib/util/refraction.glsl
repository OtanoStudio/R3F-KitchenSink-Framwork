// accurate refract built-in usage to refract light for materials
// see ior for different types of materials

vec3 refraction(
    vec3 viewDir,
    vec3 worldNormal,
    float ior,
    float refractionScale
)
{
    return refract( -viewDir, worldNormal, ior ) * refractionScale;
}