float lightingBeerLaw(
    float density,
    float span
)
{

    return exp( -density * span );

}

vec3 lightingBeerLaw(
    vec3 attenuationColor,
    float attenuationDistance,
    vec3 scatterColor,
    float span
) 
{

    if (span <= 0.0) return vec3(1.0);

    vec3 safeColor = max(attenuationColor, vec3(0.0001));
    float safeDistance = max(attenuationDistance, 0.0001);

    vec3 sigma_a = -log(safeColor) / safeDistance;
    vec3 sigma_s = max(scatterColor, vec3(0.0));
    vec3 sigma_t = sigma_a + sigma_s;

    return exp(-sigma_t * span);

}