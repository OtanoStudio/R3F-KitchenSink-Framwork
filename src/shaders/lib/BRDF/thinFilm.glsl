#include ./util/constants.glsl

vec3 thinFilmFast(
    vec3 viewDir,
    vec3 normal,
    float thickness,
    float ior
)
{
  
  float NoV = clamp( dot( normal, viewDir ), 0.0, 1.0 );

    vec3 lambda = vec3(
        650.0,
        510.0,
        475.0
    );

    float opd = 2.0 * thickness * ior * NoV;

    vec3 phase = ( 2.0 * PI * opd ) / lambda;

    return 0.5 + 0.5 * cos( phase );

}

vec3 thinFilmAngle(
    vec3 normal,
    vec3 viewDir,
    float thickness,
    float ior
)
{
    
    float NoV = clamp(dot(normal, viewDir), 0.0, 1.0);

    vec3 wavelength =
    vec3(
        650.0,
        510.0,
        475.0
    );

    float opticalLength = ( 2.0 * ior * thickness ) / max( NoV,0.01 );

    vec3 phase = opticalLength * 2.0 * PI / wavelength;

    return 0.5 + 0.5 * cos( phase );

}

vec3 thinFilm(
    vec3 normal,
    vec3 viewDir, 
    float thickness, 
    float IOR
) 
{

    float dotNV = max( 0.0, dot( normalize( normal ), normalize( viewDir ) ) );

    float sinSqT = ( 1.0 - dotNV * dotNV ) / ( IOR * IOR );
    
    if ( sinSqT > 1.0 ) return vec3( 0.0 );

    float cosThetaT = sqrt( 1.0 - sinSqT );

    float opd = 2.0 * IOR * thickness * cosThetaT;

    vec3 wavelengths = vec3( 650.0, 532.0, 440.0 );

    vec3 phase = ( 2.0 * PI * opd ) / wavelengths;

    vec3 interference = 0.5 + 0.5 * cos( phase );

    return clamp( interference, 0.0, 1.0 );

}