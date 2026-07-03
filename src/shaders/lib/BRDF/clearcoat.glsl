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

vec4 clearcoat(
    vec3 N, 
    vec3 V, 
    vec3 L, 
    vec3 H, 
    float coatRoughness, 
    float coatIntensity,
    vec3 lightColor
) 
{

    float dotNH = max( 0.0, dot( N, H ) );
    float dotNV = max( 0.0, dot( N, V ) );
    float dotNL = max( 0.0, dot( N, L ) );

    float F0 = 0.04; 
    float coatFresnel = F0 + ( 1.0 - F0 ) * pow( 1.0 - dotNV, 5.0 );
    coatFresnel *= coatIntensity; 

    float alpha = coatRoughness * coatRoughness;
    float alphaSq = alpha * alpha;
    float denom = ( dotNH * dotNH ) * ( alphaSq - 1.0 ) + 1.0;
    float D = alphaSq / ( 3.14159265359 * denom * denom );

    vec3 specularReflection = vec3( D * coatFresnel * 0.25 ) * dotNL * lightColor;

    return vec4( specularReflection, coatFresnel );

}