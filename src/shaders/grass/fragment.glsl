uniform sampler2D uGrassTexture;
uniform sampler2D uColorMap;

varying vec2 vUv;

void main()
{

    vec2 uv = vUv;

    float maskGrass = texture( uGrassTexture, uv ).r;
    vec3 colorMap = texture( uColorMap, vec2( smoothstep( 0.0, 0.99, uv.y ) ) ).rgb;

    if( maskGrass < 0.01 ) discard;

    vec4 colorFinal = vec4( colorMap * maskGrass, 1.0 * maskGrass );

    gl_FragColor = colorFinal;

    #include <tonemapping_fragment>
    #include <colorspace_fragment>

}