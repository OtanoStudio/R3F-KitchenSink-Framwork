float attenuation(
    vec3 view,
    vec3 light,
    vec3 normal,
    bool saturate
)
{
    float rtn = ( dot( normal, light ) + dot( view, -light ) );

    if( saturate )
    {
        rtn = clamp( dot( normal, light ), 0.0, 1.0 ) + clamp( dot( view, -light ), 0.0, 1.0 );
    }

    return rtn;
}

vec3 translucent(
    vec3 light,
    vec3 normal,
    vec3 view,
    float lightDistortion,
    float lightPow,
    float lightScale,
    float lightAmbient,
    float lightThickness

)
{

    vec3 distortedLight = normalize( light + normal * lightDistortion );
    float atten = attenuation( view, light, normal, true );
    float lightFactor = pow( clamp( dot( view, -distortedLight ), 0.0, 1.0 ), lightPow ) * lightScale;
    vec3 lightTranslucency = vec3( atten * ( lightFactor + lightAmbient )* lightThickness);

    return lightTranslucency;
    
}