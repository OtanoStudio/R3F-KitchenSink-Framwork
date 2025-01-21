// Parallax Occulusion uv maping

vec2 uvPOM( sampler2D heightMap, vec2 uv, vec3 viewDir, float heightScale ) 
{

    float minLayers = 8.0;
    float maxLayers = 32.0;

    float layers = mix( maxLayers, minLayers, abs( dot( vec3( 0.0, 0.0, 1.0 ), viewDir ) ) );
    float layerDepth = 1.0 / layers;
    float currentLayer = 0.0;
    vec2 parallaxOffset = viewDir.xy / viewDir.z * heightScale;
    vec2 deltaUV = parallaxOffset / layers;

    vec2 currentUV = uv;
    float currentHeight = texture( heightMap, currentUV ).r;

    while( currentLayer < currentHeight )
    {

        currentUV -= deltaUV;
        currentHeight = texture( heightMap, currentUV ).r;
        currentLayer += layerDepth;

    }

    vec2 prevUV = currentUV + deltaUV;
    float heightAfter = currentHeight - currentLayer;
    float heightBefore = texture( heightMap, prevUV ).r - currentLayer + layerDepth;

    float weight = heightAfter / ( heightAfter - heightBefore );

    vec2 finalUV = prevUV * weight + currentUV * ( 1.0 - weight );

    return finalUV;

}

vec2 uvPOM( sampler2D heightMap, vec2 uv, vec3 viewDir, float heightScale, vec2 layersSet ) 
{

    float minLayers = layersSet.x;
    float maxLayers = layersSet.y;

    float layers = mix( maxLayers, minLayers, abs( dot( vec3( 0.0, 0.0, 1.0 ), viewDir ) ) );
    float layerDepth = 1.0 / layers;
    float currentLayer = 0.0;
    vec2 parallaxOffset = viewDir.xy / viewDir.z * heightScale;
    vec2 deltaUV = parallaxOffset / layers;

    vec2 currentUV = uv;
    float currentHeight = texture( heightMap, currentUV ).r;

    while( currentLayer < currentHeight )
    {

        currentUV -= deltaUV;
        currentHeight = texture( heightMap, currentUV ).r;
        currentLayer += layerDepth;

    }

    vec2 prevUV = currentUV + deltaUV;
    float heightAfter = currentHeight - currentLayer;
    float heightBefore = texture( heightMap, prevUV ).r - currentLayer + layerDepth;

    float weight = heightAfter / ( heightAfter - heightBefore );

    vec2 finalUV = prevUV * weight + currentUV * ( 1.0 - weight );

    return finalUV;

}

vec2 uvPOM( sampler2D heightMap, vec2 uv, vec3 viewDir, float heightScale, float minLayers, float maxLayers ) 
{

    float layers = mix( maxLayers, minLayers, abs( dot( vec3( 0.0, 0.0, 1.0 ), viewDir ) ) );
    float layerDepth = 1.0 / layers;
    float currentLayer = 0.0;
    vec2 parallaxOffset = viewDir.xy / viewDir.z * heightScale;
    vec2 deltaUV = parallaxOffset / layers;

    vec2 currentUV = uv;
    float currentHeight = texture( heightMap, currentUV ).r;

    while( currentLayer < currentHeight )
    {

        currentUV -= deltaUV;
        currentHeight = texture( heightMap, currentUV ).r;
        currentLayer += layerDepth;

    }

    vec2 prevUV = currentUV + deltaUV;
    float heightAfter = currentHeight - currentLayer;
    float heightBefore = texture( heightMap, prevUV ).r - currentLayer + layerDepth;

    float weight = heightAfter / ( heightAfter - heightBefore );

    vec2 finalUV = prevUV * weight + currentUV * ( 1.0 - weight );

    return finalUV;

}