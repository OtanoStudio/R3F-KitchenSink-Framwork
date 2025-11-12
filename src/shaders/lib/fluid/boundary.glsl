// ============================================================
// Boundary Utility Functions for 2D Fluid Simulation
// Compatible with velocity, pressure, dye, etc.
// ============================================================

vec4 sampleField(sampler2D field, vec2 uv, vec2 texelSize) {
    return texture2D(field, clamp(uv, 0.0, 1.0));
}

// ------------------------------------------------------------
// Base Boundary Function
// Applies scale * sample(field, uv + offset)
// ------------------------------------------------------------
vec4 boundaryBase(
    vec2 uv,
    vec2 offset,
    sampler2D field,
    float scale,
    vec2 texelSize
) {
    vec2 sampleUV = uv + offset * texelSize;
    sampleUV = clamp(sampleUV, 0.0, 1.0);
    return scale * texture2D(field, sampleUV);
}

// ------------------------------------------------------------
// Boundary Application by Edge
// These handle reflection or damping on specific edges.
// ------------------------------------------------------------
vec4 applyBoundaryX(
    vec2 uv,
    sampler2D field,
    vec2 texelSize,
    float scale
) {
    // Reflect horizontally
    if (uv.x <= texelSize.x) {
        return boundaryBase(uv, vec2(1.0, 0.0), field, scale, texelSize);
    }
    if (uv.x >= 1.0 - texelSize.x) {
        return boundaryBase(uv, vec2(-1.0, 0.0), field, scale, texelSize);
    }
    return texture2D(field, uv);
}

vec4 applyBoundaryY(
    vec2 uv,
    sampler2D field,
    vec2 texelSize,
    float scale
) {
    // Reflect vertically
    if (uv.y <= texelSize.y) {
        return boundaryBase(uv, vec2(0.0, 1.0), field, scale, texelSize);
    }
    if (uv.y >= 1.0 - texelSize.y) {
        return boundaryBase(uv, vec2(0.0, -1.0), field, scale, texelSize);
    }
    return texture2D(field, uv);
}

// ------------------------------------------------------------
// Combined Boundary (handles both X and Y walls)
// Useful for general fluid boundary enforcement
// ------------------------------------------------------------
vec4 applyBoundaries(
    vec2 uv,
    sampler2D field,
    vec2 texelSize,
    float scale
) {
    vec4 result = texture2D(field, uv);

    if (uv.x <= texelSize.x) {
        result = boundaryBase(uv, vec2(1.0, 0.0), field, scale, texelSize);
    }
    else if (uv.x >= 1.0 - texelSize.x) {
        result = boundaryBase(uv, vec2(-1.0, 0.0), field, scale, texelSize);
    }

    if (uv.y <= texelSize.y) {
        result = boundaryBase(uv, vec2(0.0, 1.0), field, scale, texelSize);
    }
    else if (uv.y >= 1.0 - texelSize.y) {
        result = boundaryBase(uv, vec2(0.0, -1.0), field, scale, texelSize);
    }

    return result;
}

// ------------------------------------------------------------
// Optional: Corner Boundary (stabilizes diagonal artifacts)
// ------------------------------------------------------------
vec4 applyBoundaryCorners(
    vec2 uv,
    sampler2D field,
    vec2 texelSize,
    float scale
) {
    bool left = uv.x <= texelSize.x;
    bool right = uv.x >= 1.0 - texelSize.x;
    bool bottom = uv.y <= texelSize.y;
    bool top = uv.y >= 1.0 - texelSize.y;

    vec4 color = texture2D(field, uv);

    if ((left && bottom) || (left && top) || (right && bottom) || (right && top)) {
        color *= scale;
    }

    return color;
}