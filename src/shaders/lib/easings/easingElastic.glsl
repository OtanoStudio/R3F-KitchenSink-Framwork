float easeInElastic(float t) 
{
    float PI = 3.14159265359;
    if (t == 0.0 || t == 1.0) return t;
    return -pow(2.0, 10.0 * (t - 1.0)) * sin((t - 1.075) * (2.0 * PI) / 0.3);
}

float easeOutElastic(float t) 
{
    float PI = 3.14159265359;
    if (t == 0.0 || t == 1.0) return t;
    return pow(2.0, -10.0 * t) * sin((t - 0.075) * (2.0 * PI) / 0.3) + 1.0;
}

float easeInOutElastic(float t) 
{
    float PI = 3.14159265359;
    if (t < 0.5) {
        return -0.5 * pow(2.0, 20.0 * t - 10.0) * 
               sin((20.0 * t - 11.125) * (2.0 * PI) / 4.5);
    }
    return pow(2.0, -20.0 * t + 10.0) * 
           sin((20.0 * t - 11.125) * (2.0 * PI) / 4.5) * 0.5 + 1.0;
}
