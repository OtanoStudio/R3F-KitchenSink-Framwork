float easeInCirc(float t) 
{
    return -1.0 * (sqrt(1.0 - t * t) - 1.0);
}

float easeOutCirc(float t) 
{
    float t1 = t - 1.0;
    return sqrt(1.0 - t1 * t1);
}

float easeInOutCirc(float t) 
{
    float t1 = 2.0 * t;
    float t2 = t1 - 2.0;
    return t < 0.5
        ? -0.5 * (sqrt(1.0 - t1 * t1) - 1.0)
        : 0.5 * (sqrt(1.0 - t2 * t2) + 1.0);
}