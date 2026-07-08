float geometrySchlickGGX(
    float ndotv,
    float roughness
) 
{

    float a = roughness + 1.0;
    float k = ( a * a ) / 8.0;

    return ndotv / ( ndotv * ( 1.0 - k ) + k );

}

float geometrySchlickGGX(
    float NdotV, 
    float NdotL, 
    float roughness
) 
{

    float r = roughness + 1.0;
    float k = ( r * r ) / 8.0; 
    float g1v = NdotV / ( NdotV * ( 1.0 - k ) + k );
    float g1l = NdotL / ( NdotL * ( 1.0 - k ) + k );

    return g1v * g1l;

}