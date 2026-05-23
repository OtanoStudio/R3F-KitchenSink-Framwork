vec3 lightingHemi( 
    vec3 normal, 
    vec3 lightGround, 
    vec3 lightSky 
)
{

    return mix( lightGround, lightSky, normal );
    
}