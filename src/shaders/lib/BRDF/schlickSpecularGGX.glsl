#include ./dGGX.glsl
#include ./geometrySchlickGGX.glsl
#include ./schlickFresnel.glsl

vec3 schlickSpecularGGX(
    vec3 N,
     vec3 L, 
     vec3 V, 
     float roughness, 
     vec3 F0,
     float PI 
) 
{

    vec3 H = normalize( L + V );
    float NdotL = clamp( dot( N, L ), 0.0, 1.0 );
    float NdotV = clamp( dot( N, V ), 0.0, 1.0 );
    float NdotH = clamp( dot( N, H ), 0.0, 1.0 );
    float HdotV = clamp( dot( H, V ), 0.0, 1.0 );

    float D = dGGX( NdotH, roughness, PI );
    float G = geometrySchlickGGX( NdotV, NdotL, roughness );
    vec3 F = schlickFresnel( HdotV, F0 );

    vec3 numerator = D * G * F;
    float denominator = 4.0 * NdotV * NdotL + 0.0001;
    
    return numerator / denominator;

}