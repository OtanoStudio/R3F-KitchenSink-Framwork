vec3 worldToTangent( vec3 dirWS, mat3 tangentToWorld )
{

    return transpose( tangentToWorld ) * dirWS;

}