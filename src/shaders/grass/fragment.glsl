uniform sampler2D uNoiseTexture;
uniform sampler2D uGrassTexture;
uniform vec3 uTipColor;
uniform vec3 uBaseColor;

varying vec2 vUv;

void main()
{

    vec2 uv = vUv;

    float maskGrass = texture( uGrassTexture, uv ).r;
    float gradient = smoothstep( 0.14, 1.0, uv.y );
    vec3 colorGradient = mix( uBaseColor, uTipColor, gradient );

    vec4 colorFinal = vec4( colorGradient * maskGrass, 1.0 * maskGrass );

    gl_FragColor = colorFinal;

}