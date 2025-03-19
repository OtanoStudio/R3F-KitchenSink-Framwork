vec4 blurBox(sampler2D tex, vec2 uv, vec2 resolution, float radius) 
{

    vec4 color = vec4(0.0);
    float count = 0.0;

    for ( float x = -radius; x <= radius; x++ ) 
    {

        for ( float y = -radius; y <= radius; y++ ) 
        {

            vec2 offset = vec2(x, y) / resolution;
            color += texture2D(tex, uv + offset);
            count += 1.0;

        }

    }
    
    return color / count;

}