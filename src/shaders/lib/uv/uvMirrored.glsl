vec2 uvMirrored( vec2 uv )
{
    
    vec2 mod( uv, 2.0 );

    return mix( m, 2.0 - m, step( 1.0, m ) );

}