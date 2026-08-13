float ashikhminShirleyDiffuse(
    float F0,
    vec3 n,
    vec3 l,
    vec3 v
)
{
    
    const float PI = 3.14159265358979323846;

    float NdotL = max( dot( n, l ), 0.0 );
    float NdotV = max( dot( n, v ), 0.0 );

    if ( NdotL <= 0.0 || NdotV <= 0.0 ) return 0.0;

    float L = 1.0 - pow( 1.0 - 0.5 * NdotL, 5.0 );
    float V = 1.0 - pow( 1.0 - 0.5 * NdotV, 5.0 );

    return ( 28.0 / ( 23.0 * PI ) ) * ( 1.0 - F0 ) * L * V;

}