
uniform mat4 uInvViewMat;

out vec2 vUv;
out vec3 vRayOrigin;
out vec3 vRayDir;
out vec3 vOffset;

void main()
{

    vec3 rayOriginWS = ( modelMatrix * vec4( position, 1.0 ) ).xyz;
    vec3 rayDir = normalize( rayOriginWS - cameraPosition );
    vec4 transform = modelMatrix * vec4( 0.0, 0.0, 0.0, 1.0 );
    vec3 offset = vec3(0.5 ) - transform.xyz;

    gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );

    vUv = uv;
    vRayOrigin = rayOriginWS;
    vRayDir = rayDir;
    vOffset = offset;

}