float smithGeometry(
    float ndotv, 
    float ndotl, 
    float ndoth, 
    float vdoth
) 
{

    float Gv = 2.0 * ndoth * ndotv / vdoth;
    float Gl = 2.0 * ndoth * ndotl / vdoth;

    return min(1.0, min(Gv, Gl));

}

float smithGeometry(
    float ndotv, 
    float ndotl, 
    float roughness
) 
{

    float k = ( roughness + 1.0 ) * ( roughness + 1.0 ) / 8.0;
    float G1V = ndotv / ( ndotv * ( 1.0 - k ) + k );
    float G1L = ndotl / ( ndotl * ( 1.0 - k ) + k );
    return G1V * G1L;

}