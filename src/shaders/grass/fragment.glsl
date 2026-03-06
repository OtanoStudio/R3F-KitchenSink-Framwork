uniform sampler2D uColorMap;
uniform sampler2D uGrassAtlas;
uniform float uTime;

varying vec2 vUv;
flat varying int vInstance;
varying vec3 vNormals;
varying vec3 vView;
varying vec3 vPosWlrd;

#include '../lib/uv/uvGetSprite.glsl'
#include '../lib/lighting/lightLambert.glsl'

void main()
{

    vec2 uv = vUv;

    uv.y = clamp(uv.y, 0.001, 0.999);
;
    vec2 spriteUV = uvGetRandomSprite( uv, vInstance, ivec2( 2, 2 ) );

    float maskGrassAtlas = texture( uGrassAtlas, spriteUV ).r;
    maskGrassAtlas = smoothstep( 0.3, 0.8, maskGrassAtlas );

    vec3 colorMap = texture( uColorMap, vec2( smoothstep( 0.1, 0.7, uv.y ) ) ).rgb;

    float lightingDiffuse = max( dot(normalize( vec3(0.0, 1.0, 0.5) ), vNormals ), 0.0 );
    vec3 colorDiffuseLighting = vec3(1.0) * lightingDiffuse;
 
    colorMap *= colorDiffuseLighting * 1.3;

    if( maskGrassAtlas < 0.5 ) discard;

    vec4 colorFinal = vec4( colorMap, maskGrassAtlas );

    gl_FragColor = colorFinal;
    //gl_FragColor = vec4( vec3(uv, 1.0 ), 1.0 );

    #include <tonemapping_fragment>
    #include <colorspace_fragment>

}