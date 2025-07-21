float specular(
    vec3 l,
    vec3 n,
    vec3 v,
    float p
)
{

    vec3 lv =  l + v;
    vec3 h = lv / length( lv );
    float ndotl = step( 0.0, dot( n, l ) );
    float ndoth = max( dot( n, h ), 0.0 );

    return pow( ndoth, p ) * ndotl;
    
}