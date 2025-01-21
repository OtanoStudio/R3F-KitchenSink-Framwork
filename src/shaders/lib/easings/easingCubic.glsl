float easeInCubic( float t ) 
{
    return t * t * t;
}

float easeOutCubic( float t ) 
{
    float t1 = t - 1.0;
    return 1.0 + t1 * t1 * t1;
}

float easeInOutCubic( float t ) 
{
    return t < 0.5
        ? 4.0 * t * t * t
        : (t - 1.0) * (2.0 * t - 2.0) * (2.0 * t - 2.0) + 1.0;
}