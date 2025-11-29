float attenuationInverseSquare( float dist )
{

    return 1.0 / max( dist * dist, 0.00001);

}

float attenuationSmoothRange( 
    float dist
    float range
)
{

    float d = clamp( dist / range, 0.0, 1.0 );
    return ( 1.0 - d * d ) ( 1.0 - d * d );
    
}

float attenuationCLQ(
    float dist, 
    float kc, 
    float kl, 
    float kq
)
{

    return 1.0 / ( kc + kl * dist + kq * dist * dist );
    
}

float attenuationSmoothstep(
    float dist, 
    float inner, 
    float outer
)
{

    return 1.0 - smoothstep( inner, outer, dist );

}