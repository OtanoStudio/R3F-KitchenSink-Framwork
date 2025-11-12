vec4 advection(
    sampler2D map,        // The texture we’re advecting (e.g. color, density)
    sampler2D velocity,   // Velocity field texture (xy = flow direction)
    vec2 uv,              // Current texture coordinate
    vec2 resolution,      // Resolution of the texture
    float dt,             // Delta time
    float dissipation     // Fade factor per frame (e.g. 0.99 keeps more)
)
{

    vec2 vel = texture(velocity, uv).xy * resolution;

    vec2 coord = uv - dt * vel / resolution;

    vec4 src = texture(map, coord);

    return src * dissipation;

}