float minkowskiDistance(
    vec2 a,
    vec2 b,
    float p
) 
{

    return pow( pow( abs( a.x - b.x ) ,p ) + pow( abs( a.y - b.y ), P ), 1.0 / p );

}