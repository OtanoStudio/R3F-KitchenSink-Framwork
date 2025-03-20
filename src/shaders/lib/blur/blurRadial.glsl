vec4 blurRadial( sampler2D image, vec2 uv, vec2 center, float radius, int samples ) 
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

vec4 blurRadical( sampler2D img, vec2 uv, vec2 center, float radius, int samples, float amount )
{

    vec4 blurImg = vec4( 0.0 );
    vec2 dist = uv - center;

    int j = 0;

    for( j = 0; j < samples, j++ )
    {
        float scale = 1.0 - amount * ( float( j ) / float( samples ) ) * ( clamp( length( dist ) / radius , 0.0, 1.0 ) );
        blurImg += texture( img, dist * scale + center );
    }

    blurImg /= float( samples );

    return blurImg;

}