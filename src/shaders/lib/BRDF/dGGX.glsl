float dGGX(
    float ndoth, 
    float roughness
) 
{

    float PI = 3.14159265358979323846;

    float a = roughness * roughness;
    float a2 = a * a;
    float denom = ndoth * ndoth * ( a2 - 1.0 ) + 1.0;

    return a2 / ( PI * denom * denom );

}