attribute vec4 tangent;

out vec3 worldPosition;
out vec3 worldNormal;
out vec2 vUv;
out mat3 TBN;
out vec3 viewDir;

void main()
{
    

    gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );

    vUv = uv;
    worldPosition = ( modelMatrix * vec4( position, 1.0 ) ).xyz;
    worldNormal = ( modelMatrix * vec4( normal, 0.0 ) ).xyz;
    viewDir = normalize( worldPosition - cameraPosition );

    vec3 N = normalize( normalMatrix * normal );
    vec3 T = normalize( normalMatrix * tangent.xyz );
    vec3 B = normalize( cross( N, T ) * tangent.w );
    TBN = mat3( T, B, N );

}