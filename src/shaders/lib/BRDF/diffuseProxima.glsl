vec3 diffuseProxima(
    vec3 N, 
    vec3 L, 
    vec3 V, 
    vec3 albedo,
    float smoothTerminator,
    float smoothTerminatorLength,
    float diffuseFresnel,
    float diffuseFresnelFalloff,
    vec3 diffuseFresnelTint,
    float PI
) 
{

    float NdotL = dot( N, L );
    
    float softenedNdotL = clamp( ( NdotL + smoothTerminator ) / ( 1.0 + smoothTerminator ), 0.0, 1.0);
    softenedNdotL = smoothstep( 0.0, smoothTerminatorLength, softenedNdotL );
    
    float NdotV = clamp( dot( N, V ), 0.0, 1.0 );
    float fresnelFactor = pow( 1.0 - NdotV, diffuseFresnelFalloff ) * diffuseFresnel;
    
    vec3 baseDiffuse = albedo * softenedNdotL;
    vec3 rimDiffuse = diffuseFresnelTint * fresnelFactor * softenedNdotL;
    
    return ( baseDiffuse + rimDiffuse ) / PI;

}