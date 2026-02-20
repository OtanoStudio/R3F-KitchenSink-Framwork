#include '../lib/util/wind.glsl'
#include '../lib/util/randomFloat.glsl'

uniform sampler2D uNoiseTexture;
uniform float uTime;
uniform float uPhase;

varying vec2 vUv;

void main()
{

    

    vec4 worldPosition = modelMatrix * vec4( position, 1.0 );
    float time = uTime * 0.3;
    float pulse = sin( uTime * 0.5 ) * 0.5 + 0.5;
    float gust  = sin( uTime * 0.13 ) * 0.5 + 0.5;
    float windStrengthPulse = mix( pulse, gust, 0.4 );

    vec2 phase = vec2(
        sin( uPhase ),
        cos( uPhase )
    );

    vUv = uv;

    vec3 windPosition = wind(
        uNoiseTexture,
        vec2( worldPosition.xz ),
        vec3( 0.02, 0.02, 0.3 ),
        time,
        vec2( 0.4, 0.707 ),
        windStrengthPulse,
        uv,
        vec2( 0.25, 2.0 ),
        phase,
        vec3( 2.23, 1.7, 0.3 )
    );

    vec3 positionFinal = position + windPosition;

    gl_Position = projectionMatrix * modelViewMatrix * vec4( positionFinal, 1.0 );



}