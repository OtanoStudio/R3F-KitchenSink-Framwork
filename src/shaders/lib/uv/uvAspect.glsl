vec2 uvAspect( vec2 uv, vec2 resolution )
{

    float aspect = resolution.x / resolution.y;

    return vec2( ( uv.x - 0.5 ) * aspect + 0.5, uv.y );

}