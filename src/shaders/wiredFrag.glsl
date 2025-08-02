uniform float uLineWidth;
uniform vec3 uBaseColor;
uniform vec3 uBackColor;
uniform bool uGradient;
uniform vec3 uGradientTop;
uniform vec3 uGradientBottom;
uniform vec3 uGradientBackTop;
uniform vec3 uGradientBackBottom;
uniform bool uBackColored;

varying vec3 vBaryCoords;
varying float vGradient;

#include ./lib/util/wireframe.glsl
#include ./lib/util/clip.glsl
#include ./lib/color/colorFrontBack.glsl

void main()
{

    // wireframe edge
    float edge = 1.0 - wireframe( vBaryCoords, uLineWidth );

    
    clip( edge, 0.01, 0 ); // clip if edge is less than 0.01

    vec3 colorGradient = mix( uGradientTop, uGradientBottom, 1.0 - vGradient );
    vec3 colorBackGradient = mix( uGradientBackTop, uGradientBackBottom, 1.0 - vGradient );
    
    vec3 colorFront = uGradient ? colorGradient : uBaseColor;
    vec3 colorBack = uGradient ? colorBackGradient : uBackColor;

     vec3 colorLine = ( uBackColored ? colorFrontBack( colorFront, colorBack ) : colorFront ) * edge;
    vec4 colorFinal = vec4( colorLine ,edge );

    gl_FragColor = colorFinal;

}