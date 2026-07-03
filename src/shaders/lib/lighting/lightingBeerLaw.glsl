float lightingBeerLaw(
    float density,
    float span
)
{

    return exp( -density * span );

}