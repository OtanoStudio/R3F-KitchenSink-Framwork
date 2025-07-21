uniform float uTime;
uniform sampler2D uDepthTexture;

in vec2 vUv;
in vec3 worldPosition;
in vec3 worldNormal;
in vec3 viewDirection;
in vec3 normals;

void main()
{

    vec2 uv = vUv;
    vec2 uvWorld = worldPosition.xy;
    // uvWorld *= 0.5 + 0.5;
    float time = uTime;
    vec4 depth = texture( uDepthTexture, uv );

    gl_FragColor = depth;
    
    #include <tonemapping_fragment>
    #include <colorspace_fragment>
    
}