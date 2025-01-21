float easeInBack(float t) 
{
    float s = 1.70158;
    return t * t * ((s + 1.0) * t - s);
}

float easeOutBack(float t) 
{
    float s = 1.70158;
    float t1 = t - 1.0;
    return t1 * t1 * ((s + 1.0) * t1 + s) + 1.0;
}

float easeInOutBack(float t) 
{
    float s = 1.70158 * 1.525;
    t *= 2.0;
    if (t < 1.0) {
        return 0.5 * (t * t * ((s + 1.0) * t - s));
    }
    t -= 2.0;
    return 0.5 * (t * t * ((s + 1.0) * t + s) + 2.0);
}