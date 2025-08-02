float inverseSmoothstep( 
    float x
) 
{

  return 0.5 - sin( asin( 1.0 - 2.0 * x ) / 3.0 );

}