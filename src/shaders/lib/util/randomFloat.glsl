float randomFloat(
    int index,
    int seed
)
{

    return sin( float( index + seed ) ) * 0.5 + 0.5;

}