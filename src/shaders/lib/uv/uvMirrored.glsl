vec2 uvMirrored( vec2 uv )
{
    
    vec2 mod( uv, 2.0 );

    return mix( m, 2.0 - m, step( 1.0, m ) );

}

vec2 uvMirrored2(
    vec2 uv
)
{
    uv = fract( uv );
    uv = 1.0 - abs( 2.0 * uv - 1.0 );

    return uv;

}