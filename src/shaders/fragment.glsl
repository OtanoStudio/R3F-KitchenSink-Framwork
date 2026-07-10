uniform float uTime;
uniform sampler2D uNoiseTexture;
uniform sampler2D uColorMap;
uniform sampler2D uOffsetNoise;

in vec2 vUv;
in vec3 worldPosition;
in vec3 worldNormal;
in vec3 viewDirection;
in vec3 normals;

#include ./lib/uv/uvPolar.glsl
#include ./lib/uv/uvDistort.glsl

void main()
{

    vec2 uv = vUv;
    vec2 uvWorld = worldPosition.xy;
    // uvWorld *= 0.5 + 0.5;
    float time = uTime;

    vec2 dx = dFdx( uv );
    vec2 dy = dFdy( uv );

    vec2 uvOffset = uvDistort( uv, uOffsetNoise, vec2( 0.02, 0.053 ), time, 0.07 );

    vec2 uvCir = uvPolar( uvOffset ) + ( time * vec2( 0.26, 0.4 ) );

    float cirMask = length( uv - 0.5 );

    float maskOutter = smoothstep( 0.5, 0.1, cirMask);
    float maskInner = smoothstep( 0.0, 0.213, cirMask);

    cirMask =  maskOutter * maskInner;
    
    float noise = textureGrad( uNoiseTexture, uvCir, dx, dy ).r;
    noise = pow( noise, 1. );
    float noise2 = pow( noise, 3.2 );
    noise *= cirMask * 1.7;
    noise2 *= cirMask * 2.2;



    vec3 colorMap = texture( uColorMap, vec2(  0.1, noise ) ).rgb;
    colorMap * noise;

    vec3 colorFinal = mix( colorMap, vec3(1.0 ), noise2 );

    gl_FragColor = vec4( colorFinal, 1.0 * noise );
    
    #include <tonemapping_fragment>
    #include <colorspace_fragment>
    
}