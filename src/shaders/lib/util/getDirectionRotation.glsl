#include ./safeNormalize.glsl

mat2 getDirectionRotation( vec2 dir ) 
{

    vec2 d = safeNormalize(dir);

    return mat2(d.x, -d.y, d.y, d.x);

}