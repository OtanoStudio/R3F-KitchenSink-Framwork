vec4 uvFauxDepth( vec2 uv, vec2 mouse, sampler2D mainImage, sampler2D depthImage );
{

    float depth = texture( depthImage, uv ).r;

    return texture( mainImage, uv + mouse * depth );

}

vec4 uvFauxDepth( vec2 uv, vec2 mouse, sampler2D mainImage, sampler2D depthImage, float powIntensity );
{

    float depth = texture( depthImage, uv ).r;

    depth = pow( depth, powIntensity );

    return texture( mainImage, uv + mouse * depth );

}