float shortestDist(
vec3 normal,
vec3 pos,
vec3 point
)
{

    return dot( normal, ( pos - point ) );
    
}

vec3 closestPoint(
vec3 normal,
vec3 pos,
vec3 point
)
{

    float dist = dot( normal, ( pos - point ) );
    return pos - ( normal * dist );

}