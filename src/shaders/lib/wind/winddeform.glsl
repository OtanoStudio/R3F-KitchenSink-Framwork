#include ../lib/math/bezier.glsl

struct GrassResult {
    vec3 position;
    vec3 normal;
};

// -----------------------------------------------------

GrassResult WindDeform(

    vec3 localPosition,
    vec2 uv,

    vec3 instancePosition,
    float instanceRotation,
    vec2 instanceScale,
    vec2 phaseOffset,

    sampler2D windNoiseMap,
    sampler2D turbulenceMap,

    vec3 windDirection,

    float time,
    float timeScale,
    float windScale,

    float maxWindStrength,
    float turbStrength,
    float turbFrequency,

    // Bézier controls
    float bendLower,
    float bendMid,
    float bendUpper,
    float windInfluence,
    float widthScale

) {

    GrassResult r;

    float t = uv.y;

    // -------------------------------------------------
    // INSTANCE BASIS
    // -------------------------------------------------

    float s = sin(instanceRotation);
    float c = cos(instanceRotation);

    vec3 rightDir = vec3(c, 0.0, -s);

    float bladeWidth  = instanceScale.x * widthScale;
    float bladeHeight = instanceScale.y;

    // -------------------------------------------------
    // WIND
    // -------------------------------------------------

    vec2 macroUV =
        (instancePosition.xz * windScale) -
        (windDirection.xz * time * timeScale);

    float macroGust =
        texture2D(windNoiseMap, macroUV).r;

    vec3 macroWind =
        windDirection *
        macroGust *
        maxWindStrength;

    vec2 turbUV =
        (instancePosition.xz * turbFrequency) -
        (windDirection.xz * time * timeScale ) + phaseOffset;

    vec3 turbulence =
        texture2D(turbulenceMap, turbUV).rgb * 2.0 - 1.0;

    vec3 microWind =
        turbulence *
        turbStrength *
        macroGust;

    vec3 windForce =
        (macroWind + microWind) *
        windInfluence;

    // -------------------------------------------------
    // BEZIER SHAPE (wind-driven bend)
    // -------------------------------------------------

    vec3 p0 = vec3(0.0);

    vec3 p1 = vec3(0.0, bladeHeight * bendLower, 0.0);

    vec3 p2 =
        vec3(0.0, bladeHeight * bendMid, 0.0) +
        (windForce * 0.5);

    vec3 p3 =
        vec3(0.0, bladeHeight * bendUpper, 0.0) +
        windForce;

    // -------------------------------------------------
    // STABILITY (length preservation)
    // -------------------------------------------------

    p2 = normalize(p2) * (bladeHeight * 0.666);
    p3 = normalize(p3) * bladeHeight;

    // -------------------------------------------------
    // CURVE EVALUATION
    // -------------------------------------------------

    vec3 bezierPos =
        bezierQuad(p0, p1, p2, p3, t);

    vec3 tangent =
        bezierQuadGrad(p0, p1, p2, p3, t);

    // -------------------------------------------------
    // WIDTH OFFSET
    // -------------------------------------------------

    vec3 widthOffset =
        rightDir *
        (localPosition.x * bladeWidth);

    // -------------------------------------------------
    // FINAL POSITION
    // -------------------------------------------------

    vec3 finalPos =
        instancePosition +
        bezierPos +
        widthOffset;

    // -------------------------------------------------
    // FINAL NORMAL
    // -------------------------------------------------

    vec3 normal =
        normalize(
            cross(rightDir, tangent)
        );

    // -------------------------------------------------

    r.position = finalPos;
    r.normal   = normal;

    return r;
}