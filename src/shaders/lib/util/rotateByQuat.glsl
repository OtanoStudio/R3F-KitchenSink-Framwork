// roate vector by quaturion

vec3 rotateByQuat(
    vec4 q, 
    vec3 v
) 
{

    return v + 2.0 * cross(
        q.xyz,
        cross( q.xyz, v ) + q.w * v
    );

}