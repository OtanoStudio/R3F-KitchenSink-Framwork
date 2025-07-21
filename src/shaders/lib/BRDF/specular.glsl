float specular(
    vec3 l,
    vec3 n,
    vec3 v,
    float p
)
{

    vec3 lv = normalize( l + v );
    vec3 h = lv / length( lv );
    float ndotl = ( dot( n, l ) > 0.0 );
    float ndoth = max( dot( n, h ), 0.0 );

    return pow( ndoth, p ) * ndotl;
    
}