
out vec2 vUv;
out vec3 worldPosition;
out vec3 worldNormal;
out vec3 viewDirection;
out vec3 normals;
out vec3 normalNormals;
out vec2 matcapUV;
out vec2 matcapUV2;

#include ./lib/uv/uvMatcap.glsl

void main()
{

    vec4 worldPos = modelMatrix * vec4( position, 1.0 );
    vec4 worldNorm = modelMatrix * vec4( normal, 0.0 );

    gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );

    vUv = uv;
    worldPosition = worldPos.xyz;
    vec3 mvPosition = ( modelViewMatrix * vec4( position, 1.0 ) ).xyz;
    worldNormal = worldNorm.xyz;
    viewDirection = cameraPosition - worldPosition.xyz;
    normals = normal;
    normalNormals = normalMatrix * normal;
    matcapUV = uvMatcap( worldNorm.xyz, viewMatrix );
    matcapUV2 = uvMatcap( normalize( normalMatrix * normal ), normalize( mvPosition ) );
    
}