vec3 bezierCubic( 
    vec3 p0, 
    vec3 p1,
     vec3 p2, 
     vec3 p3, 
     float t 
)
{

    vec3 a = mix(p0, p1, t);
    vec3 b = mix(p1, p2, t);
    vec3 c = mix(p2, p3, t);
    vec3 d = mix(a, b, t);
    vec3 e = mix(b, c, t);
    return mix(d, e, t);

}

vec3 bezierCubicGrad(
    vec3 p0,
    vec3 p1,
    vec3 p2,
    vec3 p3,
    float t
)
{

    vec3 a = 3.0 * (p1 - p0);
    vec3 b = 3.0 * (p2 - p1);
    vec3 c = 3.0 * (p3 - p2);

    vec3 d = mix(a, b, t);
    vec3 e = mix(b, c, t);

    return mix(d, e, t);

}

vec3 bezierQuad(
    vec3 p0,
    vec3 p1,
    vec3 p2,
    float t
)
{

    vec3 a = mix(p0, p1, t);
    vec3 b = mix(p1, p2, t);

    return mix(a, b, t);

}

vec3 bezierQuadGrad(
    vec3 p0,
    vec3 p1,
    vec3 p2,
    float t
)
{
    vec3 a = 2.0 * (p1 - p0);
    vec3 b = 2.0 * (p2 - p1);

    return mix(a, b, t);
}