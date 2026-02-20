uniform sampler2D uNoiseTexture;
uniform sampler2D uGrassTexture;
uniform sampler2D uColorMap;
uniform vec3 uTipColor;
uniform vec3 uBaseColor;

varying vec2 vUv;

void main()
{

    vec2 uv = vUv;

    float maskGrass = texture( uGrassTexture, uv ).r;
    float gradient = smoothstep( 0.225, 1.0, uv.y );
    vec3 colorGradient = mix( uBaseColor, uTipColor, gradient );
    vec3 colorMap = texture( uColorMap, vec2( smoothstep( 0.0, 0.98, uv.y ) ) ).rgb;

    if( maskGrass < 0.1 ) discard;

    vec4 colorFinal = vec4( colorMap * maskGrass, 0.9 * maskGrass );

    gl_FragColor = colorFinal;

    #include <tonemapping_fragment>
    #include <colorspace_fragment>

}