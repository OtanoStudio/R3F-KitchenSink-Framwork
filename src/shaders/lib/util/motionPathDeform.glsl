// new motion path system used to move an object along a data texture as a motion path
#include ./getDirectionRotation.glsl
#include ../math/tanh.glsl

vec3 getDeformedPosition(
    vec3 pos,
    vec2 uv,
    float progress,
    float velocity,
    float intensity,
    vec2 direction,
    float instanceOffset,
    bool useTwist,
    sampler2D pathSampler,
    sampler2D weightSampler
) 
{

    float t = fract(progress + instanceOffset);
    vec4 curveData = texture2D(pathSampler, vec2(t, 0.5));
    float weight = texture2D(weightSampler, uv).r;

    vec3 pathDisplacement = curveData.rgb;
    pathDisplacement.xy = getDirectionRotation(direction) * pathDisplacement.xy;

    float bend = uBendStrength + (intensity * 0.4);
    float twist = uRotationEase + (intensity * 0.2);

    float lean = tanh( velocity ) * 0.1 * weight;

    float angle = useTwist ? (curveData.a * twist * weight) : 0.0;
    vec3 transformed = rotateY(pos, angle);

    // Apply Lean based on direction
    vec2 leanVec = vec2(-direction.y, direction.x) * lean; 
    
    transformed += (pathDisplacement * weight * bend);
    transformed.xy += leanVec;

    return transformed;

}