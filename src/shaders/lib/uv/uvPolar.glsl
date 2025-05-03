vec2 uvPolar(vec2 uv) 
{
    float pi = 3.1416;
    vec2 mappedUV = uv * 2.0 - 1.0;
    
    // Get angle in [0, 2π] range instead of [-π, π]
    float angle = atan(mappedUV.y, mappedUV.x);
    if (angle < 0.0) angle += 2.0 * pi;
    
    vec2 polarUV = vec2(
        angle / (2.0 * pi), // Normalize to [0,1]
        length(mappedUV)
    );
    
    return polarUV;
}

vec2 uvPolar(vec2 uv, vec2 center, float zoom, float repeat)
{
    float pi = 3.1416;
    vec2 dir = uv - center;
    float radius = length(dir) * 2.0;
    
    // Get angle in [0, 1] range, handling the discontinuity
    float angle = atan(dir.y, dir.x);
    if (angle < 0.0) angle += 2.0 * pi;
    angle /= (2.0 * pi);
    
    // Apply zoom and repeat
    return mod(vec2(radius * zoom, angle * repeat), 1.0);
}

vec2 uvPolar(vec2 uv, vec2 center, float radius)  
{
    float pi = 3.14159;
    
    vec2 uvCenter = uv - center;
    
    // Get angle and handle the discontinuity
    float angle = atan(uvCenter.y, uvCenter.x);
    if (angle < 0.0) angle += 2.0 * pi;
    
    float dist = length(uvCenter);
    
    float correctedDist = dist / radius;
    
    // Return polar coordinates (angle, distance)
    // Angle is normalized to [0,1] range
    return vec2(angle / (2.0 * pi), correctedDist);
}

vec2 uvPolar(vec2 uv, vec2 multiplier, vec2 offset)
{
    float pi = 3.14159;
    
    // Center UV coordinates
    vec2 centerUV = uv - 0.5;
    
    // Calculate distance to center
    float distToCenter = length(centerUV);
    
    // Calculate angle and fix the discontinuity
    float angle = atan(centerUV.y, centerUV.x);
    if (angle < 0.0) angle += 2.0 * pi;
    
    // Normalize angle to [0,1] range
    float normalizedAngle = angle / (2.0 * pi);
    
    // Create polar coordinates
    vec2 polarUV = vec2(normalizedAngle, distToCenter);
    
    // Apply multiplier and offset
    polarUV *= multiplier;
    polarUV += offset;
    
    return polarUV;
}