float easeInSine(float t) 
{
    float PI = 3.14159265359;
    return -1.0 * cos(t * PI * 0.5) + 1.0;
}

float easeOutSine(float t) 
{
    float PI = 3.14159265359;
    return sin(t * PI * 0.5);
}

float easeInOutSine(float t) 
{
    float PI = 3.14159265359;
    return -0.5 * (cos(PI * t) - 1.0);
}