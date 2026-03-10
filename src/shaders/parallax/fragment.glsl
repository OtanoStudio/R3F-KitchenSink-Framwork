
uniform float uTime;
uniform sampler2D uBaseImg;
uniform sampler2D uDepthImg;
uniform float uDepthOffset;

in vec3 vViewDir;
in vec2 vUv;
in vec3 vNormals;
in vec3 vNormalWS;

#include '../lib/uv/uvParallax.glsl'

void main()
{

    vec2 uv = vUv;
    float depth = texture( uDepthImg, uv ).r;

    vec2 parallaxUV = uvParallax(
        uv,
        vViewDir,
        depth,
        uDepthOffset,
        2
    );

    vec4 colorFinal = texture( uBaseImg, parallaxUV );

    gl_FragColor = colorFinal;

}