vec2 uvCalculate(
    vec2 position,
    vec2 boundsMin,
    vec2 boundsMax
)
{

    return ( position - boundsMin ) / ( boundsMax - boundsMin );

}