vec3 normalWorldSpace
(
    vec3 positionWS // position in world space
)
{

    return normalize( cross( dFdx( positionWS ), dFdy( positionWS ) ) );

}