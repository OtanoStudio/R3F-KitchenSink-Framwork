
out vec2 vUv;
out vec3 worldPosition;
out vec3 worldNormal;
out vec3 viewDirection;
out vec3 normals;

void main()
{

    vec4 worldPos = modelMatrix * vec4( position, 1.0 );
    vec3 worldNorm = normalMatrix * normal;

    gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );

    vUv = uv;
    worldPosition = worldPos.xyz;
    worldNormal = worldNorm;
    viewDirection = cameraPosition - worldPosition;
    normals = normal;
    
}