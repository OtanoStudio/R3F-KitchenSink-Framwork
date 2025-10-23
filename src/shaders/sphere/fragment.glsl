uniform float uTime;
uniform sampler2D uNoiseTexture;
uniform sampler2D uOffsetTexture;
uniform sampler2D uColorRamp;

in vec2 vUv;
in vec3 worldPosition;
in vec3 worldNormal;
in vec3 viewDirection;
in vec3 normals;

#include "../lib/uv/uvDistort.glsl"

void main()
{

    vec2 uv = vUv;
    vec2 uvWorld = worldPosition.xy;
    // uvWorld *= 0.5 + 0.5;
    float time = uTime;

    vec2 distortedUV = uvDistort( uv, uOffsetTexture, vec2( 0.1, 0.2), time, 0.3 );

    vec4 depth = texture( uNoiseTexture, distortedUV );

    vec3 colorRamp = texture( uColorRamp, vec2( depth.r ) ).rgb;

    float alpha = step( 0.1, 1.0 - depth.r );

    gl_FragColor = vec4( colorRamp, 1.0 * alpha );

    gl_FragColor = vec4( uv, 0.8, 1.0 );
    
    #include <tonemapping_fragment>
    #include <colorspace_fragment>
    
}