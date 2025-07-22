#include GTR1.glsl
#include dGGX.glsl
#include schlickFresnel.glsl
#include smithGeometry.glsl

// provide floats instead of using vec3 for dots
float clearcoat(
    float ndotv,
    float ndotl,
    float hdotv,
    float ndoth,
    float roughness,
    float strength,
    bool disney
)
{
    float D = ( disney ? GTR1( ndoth, roughness ) : dGGx( hdotv, roughness ) );
    float F = schlickFresnelFast( ndotv );
    float G = smithGeometry( ndotv, ndotl, roughness );

    return strength * D * F * G / ( 4.0 * ndotv * ndotl + 0.001 );

}

float clearcoat(
    vec3 n,
    vec3 l,
    vec3 v,
    float roughness,
    float strength,
    bool disney
)
{

    vec3 h = normalize( l + v );
    float ndotv = max( dot( n, v ), 0.001 );
    float ndotl = max( dot( n, l ), 0.001 );
    float ndoth = max( dot( n, h ), 0.0 );
    float hdotv = max( dot( h, v ), 0.001 );

    float D = ( disney ? GTR1( ndoth, roughness ) : dGGx( ndoth, roughness ) );
    float F = schlickFresnelFast( hdotv );
    float G = smithGeometry( ndotv, ndotl, roughness );

    return strength * D * F * G / ( 4.0 * ndotv * ndotl + 0.001 );

}