attribute float instancePhase;

uniform sampler2D uNoiseTexture;
uniform float uTime;

varying vec2 vUv;

#include '../lib/util/wind.glsl'
#include '../lib/util/randomFloat.glsl'

void main()
{

    

    vec4 worldPosition = modelMatrix * vec4( position, 1.0 );
    float time = uTime * 0.3;
    float pulse = sin( uTime * 0.5 ) * 0.5 + 0.5;
    float gust  = sin( uTime * 0.13 ) * 0.5 + 0.5;
    float windStrengthPulse = mix( pulse, gust, 0.4 );

    vec2 phase = vec2(
        sin( instancePhase ),
        cos( instancePhase )
    );

    vUv = uv;

    vec3 windPosition = wind(
        uNoiseTexture,
        vec2( worldPosition.xz ),
        vec3( 0.02, 0.02, 0.3 ),
        time,
        vec2( 0.7, 0.8 ),
        windStrengthPulse,
        uv,
        vec2( 0.32, 1.5 ),
        phase,
        vec3( 2.23, 1.7, 0.3 )
    );

    vec3 positionFinal = position + windPosition;

    gl_Position = projectionMatrix * modelViewMatrix * vec4( instanceMatrix * vec4( positionFinal, 1.0 ) );



}