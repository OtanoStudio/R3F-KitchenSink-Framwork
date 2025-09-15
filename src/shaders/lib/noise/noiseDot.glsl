float noiseDot( 
    vec3 p
)
{
    //The golden ratio:
    //https://mini.gmshaders.com/p/phi
    const float PHI = 1.618033988;

    //Rotating the golden angle on the vec3(1, phi, phi*phi) axis
    const mat3 GOLD = mat3(
    -0.571464913, +0.814921382, +0.096597072,
    -0.278044873, -0.303026659, +0.911518454,
    +0.772087367, +0.494042493, +0.399753815);
    
    //Gyroid with irrational orientations and scales
    return dot(cos(GOLD * p), sin(PHI * p * GOLD));
    //Ranges from [-3 to +3]
}