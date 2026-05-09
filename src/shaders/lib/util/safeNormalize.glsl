vec2 safeNormalize(vec2 v) 
{

    float len = length(v);

    vec2 rtn = ( len < 0.0001 ) ? vec2( 1.0, 0.0 ) : v / len;

    return rtn;

}