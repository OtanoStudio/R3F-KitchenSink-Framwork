// new motion path system used to move an object
// along quaternion motion textures

#include ./getDirectionRotation.glsl
#include ../math/tanh.glsl
#include ./rotateByQuat.glsl

vec3 motionPathDeform(
    vec3 pos,
    vec2 uv,
    float progress,
    float velocity,
    float intensity,
    vec2 direction,
    float instanceOffset,
    bool useTwist,
    sampler2D pathSampler,
    sampler2D rotationSampler,
    sampler2D weightSampler
)
{

    float t = fract( progress + instanceOffset );


    vec4 curveData = texture2D(
            pathSampler,
            vec2( t, 0.5 )
        );

    vec4 rotationData = texture2D(
            rotationSampler,
            vec2( t, 0.5 )
        );

    float weight = texture2D(
            weightSampler,
            uv
        ).r;

    vec3 pathDisplacement = curveData.rgb;

    pathDisplacement.xy = getDirectionRotation( direction ) * pathDisplacement.xy;


    float bend = uBendStrength + ( intensity * 0.4 );
    float twist = uRotationEase + ( intensity * 0.2 );

    vec3 transformed = pos;

    if( useTwist ) 
    {

        transformed = rotateVectorByQuat(
                rotationData,
                transformed
            );

        transformed = mix(
                pos,
                transformed,
                twist * weight
            );

    }

    float lean = tanh( velocity ) * 0.1 * weight;

    vec2 leanVec = vec2(
            -direction.y,
             direction.x
        ) * lean;

    transformed += pathDisplacement * weight * bend;

    transformed.xy += leanVec;

    return transformed;

}