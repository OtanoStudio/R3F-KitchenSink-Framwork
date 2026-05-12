vec3 worldToTangent( vec3 dirWS, mat3 tangentToWorld )
{

    return transpose( tangentToWorld ) * dirWS;

}

vec3 worldToTangent(
    vec3 dir,
    vec3 t,
    vec3 b,
    vec3 n
 )
{

    return vec3(
        dot( dir, t ),
        dot( dir, b ),
        dot( dir, n )
    );

}