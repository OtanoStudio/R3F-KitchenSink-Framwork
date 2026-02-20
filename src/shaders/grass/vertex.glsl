#include '../lib/util/wind.glsl'
#include '../lib/util/randomFloat.glsl'

uniform sampler2D uNoiseTexture;
uniform float uTime;
uniform float uPhase;

varying vec2 vUv;

void main()
{

    

    vec4 worldPosition = modelMatrix * vec4( position, 1.0 );
    float time = sin( ( uTime * 0.5 ) * 0.3 );
    vec2 phase = vec2(
        sin( uPhase ),
        cos( uPhase )
    );

    vUv = uv;

    vec3 windPosition = wind(
        uNoiseTexture,
        vec2( worldPosition.xz ),
        vec3( 0.02, 0.03, 0.1 ),
        time,
        vec2( 0.5, 0.5 ),
        1.0,
        uv,
        vec2( 0.5, 1.5 ),
        phase,
        vec3( 2.3, 1.7, 0.2 )
        
    );

    vec3 positionFinal = position + windPosition;

    gl_Position = projectionMatrix * modelViewMatrix * vec4( positionFinal, 1.0 );



}