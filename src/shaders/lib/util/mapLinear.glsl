// linear map function

float mapLinear(
    float x, 
    float inMin, 
    float inMax, 
    float outMin, 
    float outMax
) 
{

    return outMin + (x - inMin) * (outMax - outMin) / (inMax - inMin);

}