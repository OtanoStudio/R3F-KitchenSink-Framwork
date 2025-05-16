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
    float height, // generated height
    float offset // offset for the depth
)
{
    return uv + ( height * offset );
}