vec3 lightingHemi( 
    vec3 normal, 
    vec3 lightGround, 
    vec3 lightSky 
)
{

    return mix( lightGround, lightSky, normal );
    
}

float lightingHemi
(
 vec3 n,
 float s
)
{

    float t = n.y * 0.5 + 0.5;

    return smoothstep( 0.0 + s, 1.0 - s, t  );

}