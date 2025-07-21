float tanh(
    float x
)
{

    float e2x = exp( -2.0 * x );

    return -1.0 + 2.0 / ( 1.0 + e2x );
    
}