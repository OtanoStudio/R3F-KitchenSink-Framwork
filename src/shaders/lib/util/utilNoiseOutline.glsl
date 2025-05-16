float utilNoiseOutline(
    float noise, // noise that has not had a smoothstep or step applied
    float threshold, // threshold for the shaping function
    float width // width of the outline
)
{
    return step( threshold -  width, noise ) - step( threshold + width, noise );
}

float utilNoiseOutline(
    float noise, // noise that has not had a smoothstep or step applied
    float start, // start for the smoothstep
    float end, // end for the smoothstep
    float width // width of the outline
)
{
    return smoothstep( start -  width, end, noise ) - smoothstep( start + width, end, noise );
}