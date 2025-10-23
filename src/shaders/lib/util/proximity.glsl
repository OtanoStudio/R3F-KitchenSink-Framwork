float proximitySqr( 
    vec3 a,
    vec3 b
) 
{

    vec3 diff = a - b;

    return dot(diff, diff);

}

float proximitySqr( 
    vec2 a,
    vec2 b
) 
{

    vec2 diff = a - b;

    return dot(diff, diff);
    
}

float proximitySmooth(
    vec3 a,
    vec3 b,
    float radius,
    bool fast
)
{

    float dist = fast ? proximitySqr( a, b ) : distance( a, b );

    return 1.0 - smoothstep( 0.0, radius, dist );

}

float proximityExp(
    vec3 a,
    vec3 b,
    float falloff,
    bool fast
)
{

    float dist = fast ? proximitySqr( a, b ) : distance( a, b );

    return exp( -dist * falloff );

}

float proximityInverse(
    vec3 a,
    vec3 b,
    bool fast
)
{

    float dist = fast ? proximitySqr( a, b ) : distance( a, b );

    return 1.0 / ( 1.0 + dist * dist );

}