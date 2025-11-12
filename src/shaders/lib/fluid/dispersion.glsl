vec4 dispersion(
    sampler2D map,        // Texture to disperse (e.g. color or density)
    vec2 uv,              // Current texture coordinate
    vec2 resolution,      // Resolution of texture
    float strength,       // Spread strength (higher = more diffusion)
    float decay           // Fade factor (0.0 - 1.0)
) 
{
    vec2 texel = 1.0 / resolution;

    // 5-point diffusion kernel (center + 4 neighbors)
    vec4 center = texture(map, uv);
    vec4 up     = texture(map, uv + vec2(0.0,  texel.y));
    vec4 down   = texture(map, uv - vec2(0.0,  texel.y));
    vec4 left   = texture(map, uv - vec2(texel.x, 0.0));
    vec4 right  = texture(map, uv + vec2(texel.x, 0.0));

    // Average neighboring samples
    vec4 diffusion = (up + down + left + right) * 0.25;

    // Blend original and diffused color
    vec4 result = mix(center, diffusion, strength);

    // Apply decay to fade the dispersed ink over time
    result *= decay;

    return result;

}