// Ashikhmin-Shirley anisotropic BRDF

float anisotropicAS(
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
    float PI = 3.14159265358979323846;
    vec3 h = normalize(l + v);
    float ndoth = max( dot( n, h ), 0.0001 );
    float ndotl = max( dot( n, l ), 0.0001 );
    float ndotv = max( dot( n, v ), 0.0001 );
    float vdoth = max( dot( v, h ), 0.0001 );

    float hdott = dot( h, t );
    float hdotb = dot( h, b );

    float exponent = au * pow( hdott, 2.0 ) + av * pow( hdotb, 2.0 );
    exponent /= 1.0 - pow( ndoth, 2.0 );

    float a = sqrt( ( au + 1.0 ) * ( av + 1.0 ) ) * pow( ndoth, exponent );
    a /= ( 8.0 * PI ) * vdoth * max( ndotl, ndotv );

    float f = rs + ( 1.0 - rs ) * pow( 1.0 - vdoth, 5.0 );
    a *= f;

    return a;
    
}
