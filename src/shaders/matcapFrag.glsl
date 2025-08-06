uniform float uTime;
uniform sampler2D uMatcap;
uniform bool uV2;

in vec2 vUv;
in vec3 worldPosition;
in vec3 worldNormal;
in vec3 viewDirection;
in vec3 normals;
in vec3 normalNormals;
in vec2 matcapUV;
in vec2 matcapUV2;

void main()
{

    vec2 uv = vUv;
    vec2 uvWorld = worldPosition.xy;
    // uvWorld *= 0.5 + 0.5;
    float time = uTime;

    vec3 textureMatcap = texture( uMatcap, matcapUV ).xyz;
    vec3 textureMatcap2 = texture( uMatcap, matcapUV2 ).xyz;

    vec4 colorFinal = vec4( 1.0);
    colorFinal.rgb = uV2 ? textureMatcap : textureMatcap2;

    gl_FragColor = colorFinal;
    //gl_FragColor = vec4( uv, 0.8, 1.0 );
    
    #include <tonemapping_fragment>
    #include <colorspace_fragment>
    
}