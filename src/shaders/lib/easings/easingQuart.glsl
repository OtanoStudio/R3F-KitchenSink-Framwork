float easeInQuart( float t ) 
{
    return t * t * t * t;
}

float easeOutQuart( float t ) 
{
    float t1 = t - 1.0;
    return 1.0 - t1 * t1 * t1 * t1;
}

float easeInOutQuart( float t ) 
{
    float t1 = t - 1.0;
    return t < 0.5
        ? 8.0 * t * t * t * t
        : 1.0 - 8.0 * t1 * t1 * t1 * t1;
}