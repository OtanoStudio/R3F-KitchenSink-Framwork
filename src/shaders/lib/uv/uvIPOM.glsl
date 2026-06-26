
vec2 uvIPOM(
    vec2 uv,
    vec2 uvScale,
    vec2 uvOffset,
    float heightScale,
    vec3 viewDir, // must be in tangent space use the viewDirTangent function
    vec2 heightMinMax,
    sampler2D heightMap
)
{

    vec2 uv1 = uv * uvScale + uvOffset;
    float numLayers = mix( heightMinMax.y, heightMinMax.x, abs( dot( vec3( 0.0, 0.0, 1.0 ), viewDir ) ) / 2.0 );
    numLayers = round( numLayers / 3.0 ) * 3.0;

    for( float i = 0.0; i < numLayers; i++ )
    {

        float h = textureLod( heightMap, uv1, 0.0 ).a - 0.5;
        h *= heightScale / numLayers;
        h -= ( 1.0 / ( i + 1.0 ) ) * ( 1.0 / numLayers );
        h = clamp( h, -0.5, 0.5 );
        h -= 0.5 / numLayers;

        vec2 view = viewDir.xy;
        view *= 0.01;
        view *= h;

        uv1 += view;

    }

    return uv1;

}