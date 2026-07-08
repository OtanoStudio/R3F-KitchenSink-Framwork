vec2 mappingSPM(
    vec2 uv, 
    vec3 viewDir, 
    sampler2D depthMap, 
    float heightScale, 
    float minLayers, 
    float maxLayers
) 
{

    float numLayers = mix( maxLayers, minLayers, abs( dot( vec3( 0.0, 0.0, 1.0 ), viewDir ) ) );  
    
    float layerDepth = 1.0 / numLayers;
    
    vec2 P = viewDir.xy / viewDir.z * heightScale; 
    vec2 uv0 = P / numLayers;
  
    vec2 uv1 = uv;
    float currentLayerDepth = 0.0;
    float currentDepthMapValue = texture( depthMap, uv1 ).r;
      
    while( currentLayerDepth < currentDepthMapValue ) 
    {

        uv1 -= uv0;
        
        currentDepthMapValue = texture( depthMap, uv1 ).r;  
        
        currentLayerDepth += layerDepth;  

    }
    
    return uv1;

}