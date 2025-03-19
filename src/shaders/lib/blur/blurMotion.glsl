vec4 blurRadial(sampler2D image, vec2 uv, vec2 center, float radius, int samples) 
{

    vec4 color = vec4(0.0);
    vec2 dir = uv - center;
    
    for (int i = 0; i < samples; i++) 
    {

        float t = float(i) / float(samples - 1);
        float scale = 1.0 - radius * t;
        color += texture(image, center + dir * scale);
        
    }
    
    return color / float(samples);

}