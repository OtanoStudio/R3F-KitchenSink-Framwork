uniform sampler2D uGrassTexture;
uniform sampler2D uColorMap;
uniform sampler2D uGrassAtlas;

varying vec2 vUv;
flat varying int vInstance;
varying vec3 vNormals;
varying vec3 vView;

#include '../lib/uv/uvGetSprite.glsl'
#include '../lib/lighting/lightLambert.glsl'

void main()
{

    vec2 uv = vUv;

    float maskGrass = texture( uGrassTexture, uv ).r;
    vec3 colorMap = texture( uColorMap, vec2( smoothstep( 0.0, 0.99, uv.y ) ) ).rgb;
;
    vec2 spriteUV = uvGetRandomSprite( uv, vInstance, ivec2( 2, 2 ) );

    float maskGrassAtlas = texture( uGrassAtlas, spriteUV ).r;
    float lightingDiffuse = lightLambert( vNormals, vView );
    colorMap *= lightingDiffuse;

    if( maskGrass < 0.01 ) discard;

    vec4 colorFinal = vec4( colorMap * maskGrassAtlas, 1.0 * maskGrassAtlas );

    gl_FragColor = colorFinal;

    #include <tonemapping_fragment>
    #include <colorspace_fragment>

}