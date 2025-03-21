vec4 blurBox( sampler2D tex, vec2 uv, vec2 resolution, int radius ) 
{

    vec4 color = vec4(0.0);
    float count = 0.0;

    for ( int x = -radius; x <= radius; x++ ) 
    {

        for ( int y = -radius; y <= radius; y++ ) 
        {

            vec2 offset = vec2(float( x ), float( y ) ) / resolution;
            color += texture2D(tex, uv + offset);
            count += 1.0;

        }

    }
    
    return color / count;

}