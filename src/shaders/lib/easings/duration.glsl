// clean looping timer for animations that is between 0 - 1, loops repeatedly as 0-1 values for the duration

float normalizedDuration( 
    float time, 
    float duration 
)
{

    return mod( time, duration ) / duration;
    
}
// variation that adds a start delay 
float normalizedDuration( 
    float time, 
    float delay,
    float duration 
)
{

    return mod( time + delay, duration ) / duration;

}
// looping easing like inout
float normalizedLoop( 
    float time
)
{

    return 0.5 - 0.5 * cos( time * PI2 );

}
float normalizedLoop( 
    float time,
    float delay
)
{

    time += delay;
    return 0.5 - 0.5 * cos(  time * PI2 );

}
// fract duration, not clean for looping
float duration(
    float time,
    float speed
)
{

    return fract( time * speed );

}

float duration(
    float time,
    float speed,
    float delay
)
{

    return fract( time * speed + delay );

}

/*

timing = lerp( start, end, fn( time / duration ) );

*/