float range(
    float oldValue, 
    float oldMin, 
    float oldMax, 
    float newMin, 
    float newMax
) 
{

    vec3 sub = vec3(oldValue, newMax, oldMax) - vec3(oldMin, newMin, oldMin);

    return sub.x * sub.y / sub.z + newMin;

}

vec2 range(
    vec2 oldValue, 
    vec2 oldMin, 
    vec2 oldMax, 
    vec2 newMin, 
    vec2 newMax
) 
{

    vec2 oldRange = oldMax - oldMin;
    vec2 newRange = newMax - newMin;
    vec2 val = oldValue - oldMin;

    return val * newRange / oldRange + newMin;

}

vec3 range(
    vec3 oldValue, 
    vec3 oldMin, 
    vec3 oldMax, 
    vec3 newMin, 
    vec3 newMax
) 
{

    vec3 oldRange = oldMax - oldMin;
    vec3 newRange = newMax - newMin;
    vec3 val = oldValue - oldMin;

    return val * newRange / oldRange + newMin;

}

float crange(
    float oldValue, 
    float oldMin, 
    float oldMax, 
    float newMin, 
    float newMax
) 
{

    return clamp(range(oldValue, oldMin, oldMax, newMin, newMax), min(newMin, newMax), max(newMin, newMax));

}

vec2 crange(
    vec2 oldValue,
    vec2 oldMin, 
    vec2 oldMax, 
    vec2 newMin, 
    vec2 newMax
) 
{

    return clamp(range(oldValue, oldMin, oldMax, newMin, newMax), min(newMin, newMax), max(newMin, newMax));

}

vec3 crange(
    vec3 oldValue, 
    vec3 oldMin,
     vec3 oldMax, 
     vec3 newMin, 
     vec3 newMax
) 
{

    return clamp(range(oldValue, oldMin, oldMax, newMin, newMax), min(newMin, newMax), max(newMin, newMax));

}