uniform float uLineWidth;
uniform vec3 uBaseColor;
uniform bool uGradient;
uniform vec3 uGradientTop;
uniform vec3 uGradientBottom;

varying vec3 vBaryCoords;
varying float vGradient;

#include ./lib/util/wireframe.glsl
#include ./lib/util/clip.glsl

void main()
{

    // wireframe edge
    float edge = 1.0 - wireframe( vBaryCoords, uLineWidth );

    clip( edge, 0.01, 0 ); // clip if edge is less than 0.01

    vec3 colorGradient = mix( uGradientTop, uGradientBottom, 1.0 - vGradient );
     vec3 colorLine = ( uGradient ? colorGradient : uBaseColor ) * edge;
    vec4 colorFinal = vec4( colorLine ,edge );

    gl_FragColor = colorFinal;

}