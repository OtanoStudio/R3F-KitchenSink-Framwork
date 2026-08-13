vec3 viewDirTangent(
    vec3 normal,
    vec3 tangent,
    vec3 bitangent,
    vec3 viewDirectionWS,
    float bitangentFlip,
    bool negBiTan
)
{

    mat3 tbn = mat3(
        normalize( tangent ),
        ( negBiTan ) ? -normalize( bitangent ) * bitangentFlip : normalize( bitangent ) * bitangentFlip,
        normalize( normal )
    );

    return normalize( transpose( tbn ) * normalize( viewDirectionWS ) );

}

vec3 viewDirTangent(
    vec3 normal,
    vec3 bitangent,
    vec3 tangent,
    vec3 view
)
{

    float t = dot( tangent, view );
    float b = dot( bitangent, view );
    float n = dot( normal, view );

    return normalize( vec3( t, b, n ) );

}