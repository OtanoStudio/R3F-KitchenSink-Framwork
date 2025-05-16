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
    float threshold, // threshold for the shaping function
    float width // width of the outline
)
{
    return smoothstep( threshold -  width, threshold, noise ) - smoothstep( threshold, threshold + width, noise );
}