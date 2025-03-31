vec4 uvFauxDepth( vec2 uv, vec2 mouse, sampler2D mainImage, sampler2D depthImage )
{

    float depth = texture( depthImage, uv ).r;

    return texture( mainImage, uv + mouse * depth );

}

vec4 uvFauxDepth( vec2 uv, vec2 mouse, sampler2D mainImage, sampler2D depthImage, vec2 threshold, vec2 offset )
{

    float depth = texture( depthImage, uv ).r;

    vec2 mouseThreshold = mouse / threshold;
    vec2 depthOffset = vec2( depth ) - offset;

    return texture( mainImage, uv + depthOffset * mouseThreshold );

}

vec4 uvFauxDepth( vec2 uv, vec2 mouse, sampler2D mainImage, sampler2D depthImage, float powIntensity )
{

    float depth = texture( depthImage, uv ).r;

    depth = pow( depth, powIntensity );

    return texture( mainImage, uv + mouse * depth );

}

vec4 uvFauxDepth( vec2 uv, vec2 mouse, sampler2D mainImage, sampler2D depthImage, vec2 threshold, vec2 offset, float powIntensity )
{

    float depth = texture( depthImage, uv ).r;
    depth = pow( depth, powIntensity );

    vec2 mouseThreshold = mouse / threshold;
    vec2 depthOffset = vec2( depth ) - offset;

    return texture( mainImage, uv + depthOffset * mouseThreshold );

}

vec2 uvFauxDepth( vec2 uv, vec2 mouse, sampler2D depthImage )
{

    float depth = texture( depthImage, uv ).r;

    return uv + mouse * depth;

}

vec2 uvFauxDepth( vec2 uv, vec2 mouse, sampler2D depthImage, vec2 threshold, vec2 offset )
{

    float depth = texture( depthImage, uv ).r;

    vec2 mouseThreshold = mouse / threshold;
    vec2 depthOffset = vec2( depth ) - offset;

    return uv + depthOffset * mouseThreshold;

}

vec2 uvFauxDepth( vec2 uv, vec2 mouse, sampler2D depthImage, float powIntensity )
{

    float depth = texture( depthImage, uv ).r;

    depth = pow( depth, powIntensity );

    return uv + mouse * depth;

}

vec2 uvFauxDepth( vec2 uv, vec2 mouse, sampler2D depthImage, vec2 threshold, vec2 offset, float powIntensity )
{

    float depth = texture( depthImage, uv ).r;
    depth = pow( depth, powIntensity );

    vec2 mouseThreshold = mouse / threshold;
    vec2 depthOffset = vec2( depth ) - offset;

    return uv + depthOffset * mouseThreshold;

}