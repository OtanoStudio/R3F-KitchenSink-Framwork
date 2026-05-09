// new motion path system used to move an object along a data texture as a motion path

/**
 * @param pos           - Raw position
 * @param uv            - Vertex UV
 * @param progress      - Master Progress (animated by GSAP)
 * @param velocity      - Scroll speed (from Lenis)
 * @param direction     - Normalized direction vector (from Lenis)
 * @param instanceOffset- Unique ID/Offset
 * @param useTwist      - Toggle rotation
 * @param floatIntensity- Strength of the R3F-style floating
 * @param pathSampler   - uCurvePath
 * @param weightSampler - uWeightMap
 */
vec3 getDeformedPosition(
    vec3 pos, 
    vec2 uv, 
    float progress, 
    float velocity,
    vec2 direction,
    float instanceOffset, 
    bool useTwist, 
    float floatIntensity,
    sampler2D pathSampler, 
    sampler2D weightSampler
) {
    // 1. Progress mapping (GSAP handles the easing of 'progress' before it gets here)
    float t = fract(progress + instanceOffset);

    // 2. Fetch Data
    vec4 curveData = texture2D(pathSampler, vec2(t, 0.5));
    float weight = texture2D(weightSampler, uv).r;

    // 3. Positional Displacement
    // We project the curve's XY onto the provided direction vector
    vec3 pathDisplacement = curveData.rgb;
    pathDisplacement.x *= direction.x;
    pathDisplacement.y *= direction.y;

    // 4. Elasticity: Velocity increases the bend and twist
    float bend = uBendStrength + (abs(velocity) * 0.4);
    float twist = uRotationEase + (abs(velocity) * 0.2);

    // 5. Apply Rotation (Ternary)
    float angle = useTwist ? (curveData.a * twist * weight) : 0.0;
    float s = sin(angle);
    float c = cos(angle);
    vec3 rotatedPos = vec3(pos.x * c - pos.z * s, pos.y, pos.x * s + pos.z * c);

    // 6. R3F-style Floating
    // Controlled by floatIntensity (passed as a uniform)
    float floating = sin(uTime + (instanceOffset * 15.0)) * 0.1 * floatIntensity * weight;

    return rotatedPos + (pathDisplacement * weight * bend) + vec3(0.0, floating, 0.0);
    
}