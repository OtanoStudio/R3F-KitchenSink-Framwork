vec4 gradient(
    vec2 uv,
    sampler2D pressure,
    sampler2D velocity,
    float halfRdx,      // 0.5 / gridScale
    vec2 texelSize,
    bool clampEdges,    // optional edge handling
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

    // Sample neighboring pressures
    float pL = texture2D(pressure, uvL).r;
    float pR = texture2D(pressure, uvR).r;
    float pB = texture2D(pressure, uvB).r;
    float pT = texture2D(pressure, uvT).r;

    // Sample current velocity
    vec4 vel = texture2D(velocity, uv);

    // Subtract pressure gradient
    vel.xy -= halfRdx * vec2(pR - pL, pT - pB);

    return vel;

}