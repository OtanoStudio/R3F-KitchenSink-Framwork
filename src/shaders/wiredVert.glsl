attribute vec3 baryCoords;

varying vec3 vBaryCoords;
varying float vGradient;
    
void main()
{

    gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );

    vBaryCoords = baryCoords;
    vGradient = ( modelMatrix * vec4( position, 1.0 ) ).y * 0.5 + 0.5;

}