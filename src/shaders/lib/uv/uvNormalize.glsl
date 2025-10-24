uvNormalize( 
    vec2 uv, 
    vec4 coords 
)
{

    return ( uv - coords.xy ) / coords.zw;

}

uvUnNormalize( 
    vec2 uv, 
    vec4 coords 
)
{

    return uv * coords.zw + coords.xy;

}