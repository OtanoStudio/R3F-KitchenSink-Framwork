float lightingHGPhase(
    float lightAngle,
    float scatter
)
{

    float scatter2 = scatter * scatter;
    float denom = 1.0 + scatter2 - 2.0 * scatter * lightAngle;
    denom = max( denom, 0.0001 );

    return ( 1.0 - scatter2 ) / ( 4.0 * 3.14159265 * denom * sqrt( denom ) );

}