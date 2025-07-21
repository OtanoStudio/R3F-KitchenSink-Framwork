float anisotropicPhong(
    vec3 n,
    vec3 l,
    vec3 v,
    vec3 t,
    vec3 b,
    float au,
    float av
)
{

    float PI = 3.14159265358979323846;

    vec3 h = normalize( l + v );
    float hdotn = dot( h, n );
    float hdott = dot( h, t );
    float hdotb = dot( h, b );

    float exponent = au * pow( hdott, 2.0 ) + av * pow( hdotb, 2.0 );
    exponent /= 1.0 - pow( hdotn, 2.0 );

    float specular = ( ( au + 1.0 ) * ( av + 1.0 ) ) / 8.0 * PI;
    float a = dot( specular, pow( hdotn, exponent ) );

    return a;
    
}

float anisotropicSimplePhong(
    vec3 n,
    vec3 l,
    vec3 v,
    vec3 t,
    vec3 b,
    float au,
    float av
)
{

    float PI = 3.14159265358979323846;

    vec3 h = normalize( l + v );
    float ndoth = max( dot( n, h ), 0.001 );
    float hdott = dot( h, t );
    float hdotb = dot( h, b );

    float exponent = au * pow( hdott, 2.0 ) + av * pow( hdotb, 2.0 );

    float specular = pow( ndoth, exponent );

    return specular;

}