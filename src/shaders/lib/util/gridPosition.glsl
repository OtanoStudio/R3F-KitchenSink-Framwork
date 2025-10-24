// creates a grid of the position to simulate low poly by rounding the postion with granular control over the rounding factor
vec3 gridPosition( vec3 position, float gridSize )
{

    return round( position * gridSize ) / gridSize;

}