float easeInQuint(float t) 
{
    return t * t * t * t * t;
}

float easeOutQuint(float t) 
{
    float t1 = t - 1.0;
    return 1.0 + t1 * t1 * t1 * t1 * t1;
}

float easeInOutQuint(float t) 
{
    float t1 = t - 1.0;
    return t < 0.5
        ? 16.0 * t * t * t * t * t
        : 1.0 + 16.0 * t1 * t1 * t1 * t1 * t1;
}