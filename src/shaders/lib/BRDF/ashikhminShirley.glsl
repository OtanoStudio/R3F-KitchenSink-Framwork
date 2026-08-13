#include ashikhminShirleyDiffuse.glsl
#include ashikhminShirleySpecular.glsl

float ashikhminShirley(
    float F0,
    float au,
    float av,
    vec3 n,
    vec3 l,
    vec3 v,
    vec3 t,
    vec3 b
)
{
    
    float diffuse = ashikhminShirleyDiffuse(
        F0,
        n,
        l,
        v
    );

    float specular = ashikhminShirleySpecular(
        F0,
        au,
        av,
        n,
        l,
        v,
        t,
        b
    );

    return diffuse + specular;

}