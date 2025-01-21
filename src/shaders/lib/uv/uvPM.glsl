// parallax mapping functions
// all functions require the usage of the TBN matrix transposed in the vetex shader
// use computeTangent() on geometry in threejs or calculate tangent manually as an attribute
// not tsl ready because of the usage of tangent space

// basic parallax mapping
vec2 uvPM( sampler2D heightMap, vec2 uv, vec3 viewDir, float heightScale ) 
{

    float height = texture( heightMap, uv ).r;

    vec2 parallaxOffset = viewDir.xy / viewDir.z  * ( height * heightScale );

    return uv - parallaxOffset;

}

// steep parallax mapping
vec2 uvPM( sampler2D heightMap, vec2 uv, vec3 viewDir, float heightScale, int t ) 
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

    vec2 finalUV = currentUV;

    return finalUV;

}

vec2 uvPM( sampler2D heightMap, vec2 uv, vec3 viewDir, float heightScale, float minLayers, float maxLayers ) 
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

    vec2 finalUV = currentUV;

    return finalUV;

}