float easeInQuad( float t ) 
{
    return t * t;
}

float easeOutQuad( float t ) 
{
    return t * (2.0 - t);
}

float easeInOutQuad( float t ) 
{
    return t < 0.5 
        ? 2.0 * t * t 
        : -1.0 + (4.0 - 2.0 * t) * t;
}