float geometrySchlickGGX(
    float ndotv,
    float roughness
) 
{

    float a = roughness + 1.0;
    float k = ( a * a ) / 8.0;

    return ndotv / ( ndotv * ( 1.0 - k ) + k );

}