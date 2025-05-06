// vertex shader only, will not work otherwise

vec3 positionToScreen( 
    vec4 position, // gl_Position
    bool z,
) 
{

    vec3 NDC = position.xyz / position.w; // Normalized Device Coordinates
    NDC.xy *= 0.5;
    NDC.xy += 0.5;

    if( z )
    {
        return NDC.xy;
    }

    return NDC;

}