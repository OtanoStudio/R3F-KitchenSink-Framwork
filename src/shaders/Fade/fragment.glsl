uniform float uTime;
uniform sampler2D uTexture;
uniform sampler2D uTextureLine;
uniform sampler2D uTextureColor;
uniform float uProgress;
uniform float uRevealProgress;
uniform float uFadeProgress;
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
    float imgLine = texture( uTextureLine, uv ).r;

    float progress = uProgress; //easing( time * 0.225, 2, 2 );
    float noiseSquares = step( 0.7, noiseRandom( floor( uv * 40.0  ) * 0.5 ) );

    // cut line
    float edgeThickness = 0.09;
    float edgeDistance = max( progress - direction, 0.0 );

    float cut = 1.0 - smoothstep( 0.0, edgeThickness, edgeDistance );
    cut *= step( direction, progress );
    cut *= noiseSquares;

    // the reveal
    float revealAmt =  uRevealProgress;
    float grid = 25.0;
    float grid2 = 15.0; //mix( 10.0, 25.0, uFadeProgress );
    float noiseGrid = noiseRandom( floor( uv * grid ) );
    float noiseGrid2 = noiseRandom( floor( uv * grid2 ) );
    float gridReveal = revealAmt <= 0.0 ? 0.0 : step( noiseGrid, revealAmt );
    float gridFade = uFadeProgress <= 0.0 ? 0.0 : step( noiseGrid2, uFadeProgress );
    // float cut = step( direction , progress ) - step( direction + edgeThickness, progress );
    // cut *= noiseSquares;

    if( direction > progress ) discard;



    vec3 colorNoise = uColor * cut;
    vec3 colorFull = texture( uTextureColor, uv ).rgb * 1.5;
    vec3 colorFinal = uColor * imgLine;

    colorFinal = mix( colorFinal, colorNoise, cut );
    colorFinal = mix( colorFinal, colorFull, gridReveal );
    colorFinal = mix( colorFinal, vec3( 0.0, 0.0, 0.0 ), gridFade );

    float alpha = 1.0 * imgBlk;

    alpha = mix( alpha, 0.0, gridFade );

    gl_FragColor = vec4( colorFinal, alpha );
    //gl_FragColor = vec4( vec3( noiseSquares ), 1.0 );
    //gl_FragColor = vec4( vec3( gridReveal ), 1.0 );
    
    #include <tonemapping_fragment>
    #include <colorspace_fragment>
    
}