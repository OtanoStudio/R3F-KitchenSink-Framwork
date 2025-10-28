// blend an image over the other using alpha, second imag has to be transparent or black

vec4 blendImgOver( 
    sampler2D bottom, 
    sampler2D top, 
    vec2 uv, 
    float factor 
)
{

    vec4 img = texture( bottom, uv );
    vec4 img2 = texture( top, uv );

    return mix( img, img2, img2.a * factor );

}