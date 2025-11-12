vec4 divergence(
    vec2 uv,
    sampler2D velocity,
    float halfRdx,     // 0.5 / gridScale
    vec2 texelSize,
    bool clampEdges,   // optional boundary handling
    bool mirrorEdges
) 
{
    // Neighbor UVs
    vec2 uvL = uv - vec2(texelSize.x, 0.0);
    vec2 uvR = uv + vec2(texelSize.x, 0.0);
    vec2 uvB = uv - vec2(0.0, texelSize.y);
    vec2 uvT = uv + vec2(0.0, texelSize.y);

    // Boundary handling
    if (clampEdges) {
        uvL = clamp(uvL, 0.0, 1.0);
        uvR = clamp(uvR, 0.0, 1.0);
        uvB = clamp(uvB, 0.0, 1.0);
        uvT = clamp(uvT, 0.0, 1.0);
    } else if (mirrorEdges) {
        uvL = abs(fract(uvL * 0.5) * 2.0 - 1.0);
        uvR = abs(fract(uvR * 0.5) * 2.0 - 1.0);
        uvB = abs(fract(uvB * 0.5) * 2.0 - 1.0);
        uvT = abs(fract(uvT * 0.5) * 2.0 - 1.0);
    }

    // Sample neighboring velocities
    vec2 wL = texture2D(velocity, uvL).xy;
    vec2 wR = texture2D(velocity, uvR).xy;
    vec2 wB = texture2D(velocity, uvB).xy;
    vec2 wT = texture2D(velocity, uvT).xy;

    // Compute divergence (scalar)
    float divValue = halfRdx * ((wR.x - wL.x) + (wT.y - wB.y));

    // Output as RGBA (divergence stored in R)
    return vec4(divValue, 0.0, 0.0, 1.0);

}