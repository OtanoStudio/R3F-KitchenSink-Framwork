lightingBeerPowder(
    float density,
    float absorption
)
{

    float beer = exp( -density * absorption );
    float powder = 1.0 - exp( -density * absorption );

    return beer * powder;

}