

out vec3 vViewDir;
out vec2 vUv;
out vec3 vNormals;
out vec3 vNormalWS;

void main()
{

    vec4 mp = modelMatrix * vec4( position, 1.0 );

    

    gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );

    vViewDir = normalize( cameraPosition - mp );
    vUv = uv;
    vNormals = normal;
    vNormalWS = ( normalMatrix * vec4( normal, 0.0 ) ).xyz;

}