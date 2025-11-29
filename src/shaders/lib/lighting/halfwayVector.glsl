vec3 halfwayVector(
    vec3 light,
    vec3 view
)
{

    return normalize( light + view );

}