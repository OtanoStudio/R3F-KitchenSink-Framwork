float ashikhminShirleyAnisotropic(
    float rs,
    float au,
    float av,
    vec3 n,
    vec3 l,
    vec3 v,
    vec3 t,
    vec3 b

)
{

    vec3 h = normalize( l + v );

    float nDotH = max( dot( n, h ), 0.0001 );
    float nDotL = max( dot( n, l ), 0.0001 );
    float nDotV = max( dot( n, v ), 0.0001 );
    float vDotH = max( dot( v, h ), 0.0001 );
    float hDotT = dot( h, t );
    float hDotB = dot( h, b );
    float vh = 1.0 - vDotH;

    float exp = au *  ( hDotT * hDotT ) + av * ( hDotB * hDotB );
    exp /= 1.0 - nDotH * nDotH;

    float a = sqrt( ( au + 1.0 ) * ( av + 1.0 ) ) * pow( nDotH, exp );
    a /= ( 8.0 * PI ) * vDotH * max( nDotL, nDotV );

    float f = rs + ( 1.0 - rs ) * ( vh * vh * vh * vh * vh );

    a *= f;

    return a;

}