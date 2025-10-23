uniform float uTime;

out vec2 vUv;
out vec3 worldPosition;
out vec3 worldNormal;
out vec3 viewDirection;
out vec3 normals;

void main()
{

    vec4 worldPos = modelMatrix * vec4( position, 1.0 );
    vec4 worldNorm = modelMatrix * vec4( normal, 0.0 );

    vec3 nPos = position;

    nPos.y *= 1.0 - cos( 10.0 ) * 0.1;
    nPos.x *= 1.0 - sin( 15.0 ) * 5.0;

    nPos += normal * 0.01;

    gl_Position = projectionMatrix * modelViewMatrix * vec4( nPos, 1.0 );

    vUv = uv;
    worldPosition = worldPos.xyz;
    worldNormal = worldNorm.xyz;
    viewDirection = cameraPosition - worldPosition.xyz;
    normals = normal;
    
}