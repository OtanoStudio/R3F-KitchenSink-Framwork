float easeInExpo(float t) 
{
    return t == 0.0 ? 0.0 : pow(2.0, 10.0 * (t - 1.0));
}

float easeOutExpo(float t) 
{
    return t == 1.0 ? 1.0 : 1.0 - pow(2.0, -10.0 * t);
}

float easeInOutExpo(float t) 
{
    if (t == 0.0 || t == 1.0) return t;
    
    return t < 0.5
        ? 0.5 * pow(2.0, (20.0 * t) - 10.0)
        : 0.5 * (-pow(2.0, (-20.0 * t) + 10.0) + 2.0);
}