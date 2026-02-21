
uniform sampler2D uNoiseTexture;
uniform float uTime;

varying vec2 vUv;

#include '../lib/util/wind.glsl'
#include '../lib/util/randomFloat.glsl'

void main()
{

    

    vec4 worldPosition = modelMatrix * vec4( position, 1.0 );
    float time = uTime * 0.25;
    float pulse = sin( uTime * 0.6 ) * 0.5 + 0.5;
    float gust  = sin( uTime * 3.0 ) * 0.5 + 0.5;
    float windStrengthPulse = mix( pulse, gust, 0.12 );
    float windStrength = 0.15 + pow(max(0.0, sin(time * 0.4)), 3.0) * 0.85;
    float gustOffsetZ = pow(max(0.0, sin(time * 0.4)), 3.0);
    float gustPulse = sin(time * 0.18);
gustPulse = gustPulse * 0.5 + 0.5;   // 0-1
gustPulse = pow(gustPulse, 4.0);

    vec2 phase = vec2(
        randomFloat( gl_InstanceID, 2 ) * 0.37,
        randomFloat( gl_InstanceID, 2 ) * 0.19
    );

    vUv = uv;

    vec3 windPosition = wind(
        uNoiseTexture,
        vec2( worldPosition.xz * 0.1 ),
        vec3( 1.0, 1.0, 0.25 ),
        time,
        vec2( 0.6, 0.2 ),
        windStrengthPulse,
        uv,
        vec2( 1.0, 2.2 ),
        phase,
        vec3( 0.4, 0.6, gustPulse )
    );

    vec3 positionFinal = position + windPosition;

    gl_Position = projectionMatrix * modelViewMatrix * instanceMatrix * vec4( positionFinal, 1.0 );



}