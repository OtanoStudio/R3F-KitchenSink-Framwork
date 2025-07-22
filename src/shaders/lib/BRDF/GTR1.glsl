float GTR1(
    float ndoth, 
    float roughness
)
{
    float PI = 3.14159265358979323846;

    float a = mix( 0.1, 0.001, roughness );
    float a2 = a * a;
    float denom = PI * log( a2 ) * ( 1.0 + ( a2 - 1.0 ) * ndoth * ndoth );

    return a2 / denom;

}