vec2 uvParallax( 
    vec2 uv, // uv
    vec3 viewDir, // tangent space view direction
    float height, // height of the parallax
    float offset // offset for the depth
)
{
    return uv + ( viewDir.xy * ( height * offset ) );
}

vec2 uvParallax( 
    vec2 uv, // uv
    sampler2D height, // texture for depth
    float offset // offset for the depth
)
{
    float depth = texture( height, uv ).r;
    return uv + ( depth * offset );
}

vec2 uvParallax( 
    vec2 uv, // uv
    sampler2D height, // texture for depth
    float depthOffset, // depth offset
    float offset // offset 
)
{

    float depth = texture( height, uv ).r;
    vec2 rtn = uv - 0.5;
    rtn *= ( depth * depthOffset );

    return rtn + offset;

}

vec2 uvParallax( 
    vec2 uv, // uv
    float height, // generated height
    float offset // offset for the depth
)
{
    return uv + ( height * offset );
}

vec2 uvParallax( 
    vec2 uv, // uv
    float height, // texture for depth
    float depthOffset, // depth offset
    float offset // offset 
)
{
    
    vec2 rtn = uv - 0.5;
    rtn *= ( height * depthOffset );

    return rtn + offset;

}

// these scroll the depth texture
vec2 uvParallax( 
    vec2 uv, // uv
    sampler2D height, // texture for depth
    float depthOffset, // depth offset
    float offset, // offset
    vec2 time, // fixed time with scroll speed included

)
{
    vec2 scroll = uv + time;

    float depth = texture( height, scroll ).r;
    vec2 rtn = uv - 0.5;
    rtn *= ( depth * depthOffset );

    return rtn + offset;

}
