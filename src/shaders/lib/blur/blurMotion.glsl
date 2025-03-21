vec4 blurMotion(sampler2D image, vec2 uv, vec2 direction, float strength, int samples) 
{
    vec4 color = vec4(0.0);
    
    for (int i = 0; i < samples; i++) 
    {
        float t = ( float( i ) / float( samples - 1 ) - 0.5 ) * strength;
        vec2 offset = direction * t;
        color += texture( image, uv + offset );
    }
    
    return color / float( samples );

}

vec4 blurMotion(sampler2D tex, vec2 uv, vec2 resolution, vec2 direction, float strength) 
{
    vec4 color = vec4(0.0);
    float total = 0.0;

    for ( float i = -5.0; i <= 5.0; i++ ) 
    {
        float weight = 1.0 - abs(i) / 5.0;
        vec2 offset = direction * ( i * strength ) / resolution;
        color += texture2D(tex, uv + offset) * weight;
        total += weight;
    }

    return color / total;
    
}