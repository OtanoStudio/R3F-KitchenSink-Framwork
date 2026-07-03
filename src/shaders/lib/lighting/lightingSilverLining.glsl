float lightingSilverLining(
    float lightAngle,
    float intensity
)
{

    return pow( max( lightAngle, 0.0 ), intensity );

}