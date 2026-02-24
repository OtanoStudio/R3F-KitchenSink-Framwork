
uniform sampler2D uNoiseTexture;
uniform float uTime;

varying vec2 vUv;
flat varying int vInstance;
varying vec3 vNormals;
varying vec3 vView;

#include '../lib/util/wind.glsl'
#include '../lib/util/randomFloat.glsl'

void main()
{

    

    vec4 worldPosition = modelMatrix * vec4( position, 1.0 );
    float time = uTime * 0.22;
    float pulse = sin( uTime * 0.06 ) * 0.5 + 0.5;
    float gust  = sin( uTime * 2.0 ) * 0.5 + 0.5;
    float windStrengthPulse = mix( pulse, gust, 0.6 );


    vec2 phase = vec2(
        randomFloat( gl_InstanceID, 2 ) * 0.37,
        randomFloat( gl_InstanceID, 4 ) * 0.19
    );

    vUv = uv;

    vec3 windPosition = wind(
        uNoiseTexture,
        vec2( worldPosition.xz * 0.1 ),
        vec3( 1.3, 2.6, 0.3 ),
        time,
        vec2( 0.6, 0.3 ),
        3.0,
        uv,
        vec2( 0.4, 2.6 ),
        phase,
        vec3( 0.4, 0.6, windStrengthPulse )
    );

    vec3 positionFinal = position + windPosition;

    gl_Position = projectionMatrix * modelViewMatrix * instanceMatrix * vec4( positionFinal, 1.0 );

    vInstance = gl_InstanceID;
    vNormals = normalize( normalMatrix * normal );
    vView = normalize( cameraPosition - worldPosition.xyz );

}