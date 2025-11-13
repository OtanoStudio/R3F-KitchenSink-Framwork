uniform float uTime;
uniform sampler2D uNoiseTexture;

in vec2 vUv;
in vec3 worldPosition;
in vec3 worldNormal;
in vec3 viewDirection;
in vec3 normals;

#include '../lib/util/sparkles.glsl'
void main()
{

    vec2 uv = vUv;
    vec2 uvWorld = worldPosition.xy;
    // uvWorld *= 0.5 + 0.5;
    float time = uTime;

    float sparkle = sparkles( uNoiseTexture, viewDirection, worldNormal, uv * 10.0, 5.0 );

    vec3 colorBase = vec3(0.396, 0.302, 0.510);
    vec3 colorSparkles = vec3(0.863, 0.776, 0.969);

    vec3 colorFinal = colorSparkles * sparkle;

    gl_FragColor = vec4( colorBase * colorFinal, 1.0 );
    
    #include <tonemapping_fragment>
    #include <colorspace_fragment>
    
}