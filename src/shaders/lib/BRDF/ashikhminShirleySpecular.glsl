#include schlickFresnel.glsl

float ashikhminShirleySpecular(
    float F0,
    float au,
    float av,
    vec3 n,
    vec3 l,
    vec3 v,
    vec3 t,
    vec3 b
)
{

    const float PI = 3.14159265358979323846;

    vec3 h = normalize( l + v );

    float NdotL = max( dot( n, l ), 0.0 );
    float NdotV = max( dot( n, v ), 0.0 );
    float NdotH = max( dot( n, h ), 0.0 );
    float VdotH = max( dot( v, h ), 0.0 );

    if ( NdotL <= 0.0 || NdotV <= 0.0 || NdotH <= 0.0 ) return 0.0;

    float TdotH = dot( t, h );
    float BdotH = dot( b, h );

    float NdotH2 = NdotH * NdotH;

    float denominator = max(
        1.0 - NdotH2,
        0.0001
    );

    float exponent =
        (
            au * TdotH * TdotH +
            av * BdotH * BdotH
        ) / denominator;

    float D = sqrt( ( au + 1.0 ) * ( av + 1.0 ) ) * pow( NdotH, exponent );

    float F = schlickFresnelFast( F0, VdotH );

    return D * F / ( 8.0 * PI * NdotL * NdotV );

}