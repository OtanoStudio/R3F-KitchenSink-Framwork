#include ./mapLinear.glsl
#include ./rotateMat4.glsl


vec3 vertexFloat(
    vec3  pos,
    float time,
    float speed,
    float rotationIntensity,
    float floatIntensity,
    float floatRangeMin,
    float floatRangeMax,
    float offset
) {

    float t = offset + time;

    float rotX = (cos((t / 4.0) * speed) / 8.0) * rotationIntensity;
    float rotY = (sin((t / 4.0) * speed) / 8.0) * rotationIntensity;
    float rotZ = (sin((t / 4.0) * speed) / 20.0) * rotationIntensity;

    mat4 mX = rotationMatrix(vec3(1.0, 0.0, 0.0), rotX);
    mat4 mY = rotationMatrix(vec3(0.0, 1.0, 0.0), rotY);
    mat4 mZ = rotationMatrix(vec3(0.0, 0.0, 1.0), rotZ);

    vec3 rotated = (mX * mY * mZ * vec4(pos, 1.0)).xyz;


    float rawY = sin((t / 4.0) * speed) / 10.0;
    float mappedY = mapLinear(rawY, -0.1, 0.1, floatRangeMin, floatRangeMax);
    rotated.y += mappedY * floatIntensity;

    return rotated;

}