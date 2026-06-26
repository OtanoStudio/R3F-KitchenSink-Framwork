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