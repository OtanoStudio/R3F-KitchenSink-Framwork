
uniform float uTime;
uniform float uTimeOffset;
uniform sampler3D uVolume;
uniform float uDarkness;
uniform float uTransmittance;
uniform float uAbsorption;
uniform vec3 uLightDir;
uniform vec3 uColorBase;
uniform vec3 uColorShadow;

in vec2 vUv;
in vec3 vRayOrigin;
in vec3 vRayDir;
in vec3 vOffset;

#include ../lib/raymarch/raymarchVolumes.glsl

void main()
{

    vec2 uv = vUv;
    float time = uTime * uTimeOffset;

    vec4 colorFinal = raymarchVolumes(
        uVolume,
        uColorBase,
        uColorShadow,
        vRayOrigin,
        vRayDir,
        vOffset,
        uLightDir,
        uDarkness,
        uAbsorption
    );

    gl_FragColor = colorFinal;

}