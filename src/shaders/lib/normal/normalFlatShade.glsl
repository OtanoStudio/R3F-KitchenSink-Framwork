vec3 normalFlatShade(
    vec3 viewPosition;
)
{
    return normalize( cross( dFdx( viewPosition ), dFdy( viewPosition ) ) );
}