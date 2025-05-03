vec2 uvAspect( vec2 uv, vec2 resolution )
{

    float aspect = resolution.x / resolution.y;

    return vec2( ( uv.x - 0.5 ) * aspect + 0.5, uv.y );

}

vec2 uvAspect( vec2 uv, float scale )
{

    return (uv - 0.5 ) * scale + 0.5;
    
}

vec2 uvAspect( vec2 resolution )
{

    vec2 uv = gl_FragCoord.xy / resolution;
    float aspect = resolution.x / resolution.y;

    return vec2( ( uv.x - 0.5 ) * aspect + 0.5, uv.y );

}