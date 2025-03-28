vec2 mappingCRPOM(
    sampler2D heightMap,   // Height map texture
    vec2 texCoords,        // Original texture coordinates
    vec3 viewDir,          // View direction in tangent space
    float heightScale,     // Scaling factor for height map
    int maxSteps,          // Maximum number of ray march steps
    float refinementSteps  // Number of refinement steps
) {

    float height = texture(heightMap, texCoords).r;
    vec2 parallaxCoords = texCoords - viewDir.xy * (height * heightScale);
    
    float currentHeight = 0.0;
    vec2 currentTexCoords = parallaxCoords;
    vec2 deltaTexCoords = viewDir.xy * heightScale / float(maxSteps);
    
    for (int i = 0; i < maxSteps; i++) 
    {
        currentTexCoords -= deltaTexCoords;
        currentHeight = texture(heightMap, currentTexCoords).r;
        
        if (currentHeight > 1.0 - float(i) / float(maxSteps)) 
        {
            break;
        }
    }
    
    vec2 finalTexCoords = currentTexCoords;

    for (int j = 0; j < int(refinementSteps); j++) 
    {
        deltaTexCoords *= 0.5;
        
        height = texture(heightMap, finalTexCoords).r;
        
        if (height > 1.0 - float(j + 1) / refinementSteps) 
        {
            finalTexCoords += deltaTexCoords;
        } 
        else 
        {
            finalTexCoords -= deltaTexCoords;
        }
    }
    
    return finalTexCoords;
}