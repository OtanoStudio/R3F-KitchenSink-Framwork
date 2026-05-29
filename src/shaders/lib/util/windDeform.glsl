#include ../math/bezier.glsl

struct WindResult {
    vec3 position;
    vec3 tangent;
    vec3 normal;
};

WindResult windDeform(
    vec3 localPosition,
    vec2 uv,
    mat4 worldMat,
    sampler2D windNoiseMap,
    sampler2D turbulenceMap,
    vec3 windDirection,
    float time,
    float timeScale,
    float maxWindStrength,
    float turbFrequency,
    float turbStrength
) {

    WindResult result;

    vec3 rootWorldPos = (worldMat * vec4(0.0, 0.0, 0.0, 1.0)).xyz;

    vec3 rightDir = normalize(worldMat[0].xyz);
    vec3 upDir    = normalize(worldMat[1].xyz);

    float scaleX = length(worldMat[0].xyz);
    float scaleY = length(worldMat[1].xyz);

    float t = uv.y;

    vec2 macroUV =
        (rootWorldPos.xz * 0.05) -
        (windDirection.xz * time * timeScale);

    float macroGust =
        texture2D(windNoiseMap, macroUV).r;

    vec3 macroDisplacement =
        windDirection *
        macroGust *
        maxWindStrength;

    vec2 turbUV =
        (rootWorldPos.xz * turbFrequency) -
        (windDirection.xz * time * timeScale * 2.5);

    vec3 turbulenceDir =
        texture2D(turbulenceMap, turbUV).rgb * 2.0 - 1.0;

    vec3 turbDisplacement =
        turbulenceDir *
        turbStrength *
        macroGust;

    vec3 finalWindForce =
        macroDisplacement +
        turbDisplacement;

    float bladeHeight = scaleY;

    vec3 p0 = vec3(0.0);

    vec3 p1 =
        upDir *
        (bladeHeight * 0.333);

    vec3 p2 =
        (upDir * (bladeHeight * 0.666)) +
        (finalWindForce * 0.5);

    vec3 p3 =
        (upDir * bladeHeight) +
        finalWindForce;

    float p3Len = max(length(p3 - p0), 0.0001);

    p3 =
        p0 +
        normalize(p3 - p0) *
        bladeHeight;

    float p2Len = max(length(p2 - p0), 0.0001);

    p2 =
        p0 +
        normalize(p2 - p0) *
        (bladeHeight * 0.666);

    vec3 curvePos =
        bezierQuad(
            p0,
            p1,
            p2,
            p3,
            t
        );

    vec3 tangent =
        bezierQuadGrad(
            p0,
            p1,
            p2,
            p3,
            t
        );

    vec3 widthOffset =
        rightDir *
        (localPosition.x * scaleX);

    vec3 finalWorldPos =
        rootWorldPos +
        curvePos +
        widthOffset;

    vec3 normal =
        normalize(cross(rightDir, tangent));

    result.position = finalWorldPos;
    result.tangent  = tangent;
    result.normal   = normal;

    return result;

}