vec4 jacobi(
    vec2 uv,
    sampler2D x,
    sampler2D b,
    float alpha,
    float rBeta,
    vec2 texelSize,
    bool clampEdges,   // if true: clamp to border
    bool mirrorEdges   // if true: mirror instead of clamp
) 
{
    // Handle boundary UVs
    vec2 uvL = uv - vec2(texelSize.x, 0.0);
    vec2 uvR = uv + vec2(texelSize.x, 0.0);
    vec2 uvB = uv - vec2(0.0, texelSize.y);
    vec2 uvT = uv + vec2(0.0, texelSize.y);

    // Optional edge control
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

    // Sample neighbors
    vec4 xL = texture2D(x, uvL);
    vec4 xR = texture2D(x, uvR);
    vec4 xB = texture2D(x, uvB);
    vec4 xT = texture2D(x, uvT);

    // Sample the source term
    vec4 bC = texture2D(b, uv);

    // Jacobi iteration
    vec4 xNew = (xL + xR + xB + xT + alpha * bC) * rBeta;

    return xNew;

}