float utilNoiseOutline(
    float noise, // noise that has not had a smoothstep or step applied
    float threshold, // threshold for the shaping function
    float width, // width of the outline
    int type // 0 for step, 1 for smoothstep
)
{

    float rtn = 0.0;

    if( type == 0 )
    {

        rtn = step( threshold -  width, noise ) - step( threshold + width, noise );
    
    }
    else // we don't care if type is anything but 0 it will be smoothstep
    {

        rtn = smoothstep( threshold -  width, threshold, noise ) - smoothstep( threshold, threshold + width, noise );
    
    }

    return rtn;

}

float utilNoiseOutline(
    float direction,
    float progress,
    float thickness,
    float noise
)
{
    
    float edge = abs( direction - progress );

    cut = 1.0 - smoothstep( 0.0, thickness, edge );
    cut *= step( direction, progress );
    cut *= noise;

    return cut;

}