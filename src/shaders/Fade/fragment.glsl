uniform float uTime;
uniform sampler2D uTexture;
uniform float uProgress;
uniform vec3 uColor;

in vec2 vUv;
in vec3 worldPosition;
in vec3 worldNormal;
in vec3 viewDirection;
in vec3 normals;

#include '../lib/util/constants.glsl'
#include '../lib/easings/easings.glsl'
#include '../lib/noise/noiseRandom.glsl'

void main()
{

    vec2 uv = vUv;
    vec2 uvWorld = worldPosition.xy;
    // uvWorld *= 0.5 + 0.5;
    float time = uTime;
    float direction = uv.y;
    float imgBlk = texture( uTexture, uv ).r;

    float progress = easing( time * 0.3, 9, 2 );
    float noiseSquares = step( 0.7, noiseRandom( floor( ( uv + vec2( time * 0.06, 1.0 ) ) * 20.0  ) * 0.5 ) );

    // cut line
    float edgeThickness = 0.09;
    float edgeDistance = abs( direction - progress );

    float cut = 1.0 - smoothstep( 0.0, edgeThickness, edgeDistance );
    cut *= step( direction, progress );
    cut *= noiseSquares;

    // float cut = step( direction , progress ) - step( direction + edgeThickness, progress );
    // cut *= noiseSquares;

    if( direction > progress ) discard;

    vec3 colorNoise = vec3(0.0, 0.68, 1.0) * cut;
    vec3 colorFinal = vec3( imgBlk );

    colorFinal = mix( colorFinal, colorNoise, cut );

    float alpha = 1.0 * imgBlk;

    gl_FragColor = vec4( colorFinal, alpha );
    //gl_FragColor = vec4( vec3( noiseSquares ), 1.0 );
    
    #include <tonemapping_fragment>
    #include <colorspace_fragment>
    
}