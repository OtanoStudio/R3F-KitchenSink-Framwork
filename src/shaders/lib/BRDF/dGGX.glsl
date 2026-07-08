float dGGX(
    float ndoth, 
    float roughness,
    float PI
) 
{

    float a = roughness * roughness;
    float a2 = a * a;
    float n = ndoth * ndoth;
    float denom = n * ( a2 - 1.0 ) + 1.0;

    return a2 / ( PI * denom * denom );

}