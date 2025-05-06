vec2 uvParallax( 
    vec2 uv, // uv
    vec3 viewDir, // tangent space view direction
    float height // height of the parallax
)
{
    return uv + ( viewDir.xy * height );
}