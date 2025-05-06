vec3 worldCoordsFromDepth( 
    float depth, // depth value from depth texture,
    vec2 uv, // texture coords
    mat4 projectionMatrixInverse, // inverse projection matrix from vertex shader
    mat4 viewMatrixInverse // inverse view matrix from vertex shader
) 
{
    float z = depth * 2.0 - 1.0;

    vec4 clipSpaceCoordinate = vec4( uv * 2.0 - 1.0, z, 1.0);
    vec4 viewSpaceCoordinate = projectionMatrixInverse * clipSpaceCoordinate;

    viewSpaceCoordinate /= viewSpaceCoordinate.w;

    vec4 worldSpaceCoordinates = viewMatrixInverse * viewSpaceCoordinate;

    return worldSpaceCoordinates.xyz;
}