// disperse grass based on objects position in world space
// original idea from minionsart https://www.patreon.com/posts/19844414

// return only the dispersion value as a vector 2
vec2 grassDispersion(
    vec3 positionWorld,
    vec3 positionObj,
    float radius
)
{

    float dist = distance( positionObj, positionWorld );

    float circle = 1.0 - clamp( dist / radius, 0.0, 1.0 );

    vec3 dispersion = positionWorld - positionObj;
    dispersion *= circle;

    return dispersion.xz;

}

// return original position modified
vec3 grassDispersion(
    vec3 positionWorld,
    vec3 positionObj,
    vec3 position,
    float radius
)
{

    float dist = distance( positionObj, positionWorld );

    float circle = 1.0 - clamp( dist / radius, 0.0, 1.0 );

    vec3 dispersion = positionWorld - positionObj;
    dispersion *= circle;

    position.xz += dispersion.xz;

    return position;

}