vec4 blurRadical(sampler2D tex, vec2 uv, vec2 center,int samples, float blurAmount ) 
{
    vec4 color = vec4(0.0);
    vec2 dir = uv - center;
    
    for ( int i = 0; i < samples; i++ ) 
    {
        float t = float( i ) / float( samples ) - 1.0;
        float scale = 1.0 - blurAmount * t;
        color += texture2D(tex, dir * scale + center );
    }
    
    color /= float( samples );

    return color;

}
// original author using hlsl https://halisavakis.com/my-take-on-shaders-radial-blur/
vec4 blurRadical( sampler2D img, vec2 uv, vec2 center, float radius, int samples, float amount )
{

    vec4 blurImg = vec4( 0.0 );
    vec2 dist = uv - center;
    float t = length( dist ) / radius;

    for( int j = 0; j < samples; j++ )
    {
        float scale = 1.0 - amount * ( float( j ) / float( samples ) ) * ( clamp( t , 0.0, 1.0 ) );
        blurImg += texture( img, dist * scale + center );
    }

    blurImg /= float( samples );

    return blurImg;

}
