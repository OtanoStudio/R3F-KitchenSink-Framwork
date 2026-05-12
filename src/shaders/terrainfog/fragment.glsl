// uniform float uTime;
// uniform sampler2D uFogNoise;
// uniform sampler2D uDepthTexture; // Required for Depth Fade
// uniform float uOpacityMultiplier;
// uniform float uFogSpeed;
// uniform vec2 uResolution;
// uniform sampler2D uPositionMask;
// uniform float uNear;
// uniform float uFar;

// in vec2 vUv;
// in vec3 vWorldPosition;
// in vec3 vWorldNormal;
// in vec2 vUVScroll;
// in vec3 vViewDirTangent;
// in vec2 vUVParallax;
// in vec2 vUVFog;
// in vec4 vClipSpacer;

// #include <packing>

// void main() {
    
//     vec2 uv = vUv;

//     vec2 uvScreen = gl_FragCoord.xy / uResolution;
//     float fresnel = dot( vWorldNormal, vViewDirTangent );
//     float angleAlpha = smoothstep(0.0, 0.3, abs(fresnel));

//     float depth = texture( uDepthTexture, uvScreen ).r;
//     float sceneViewZ = perspectiveDepthToViewZ( depth, uNear, uFar );
//     float planeViewZ = perspectiveDepthToViewZ(gl_FragCoord.z, uNear, uFar);
//     float depthFade = clamp((abs(sceneViewZ) - abs(planeViewZ)) / 0.2, 0.0, 1.0);

//     float fog = texture( uFogNoise, vUVParallax + vUVScroll ).r;
//     fog = pow( fog, 0.834 );

//     float ring = texture( uPositionMask, uv ).r;

//     gl_FragColor = vec4( vec3( fog ), 1.0 * fog * depthFade * angleAlpha * ring * 0.53 );
    
//     #include <tonemapping_fragment>
//     #include <colorspace_fragment>
// }

uniform sampler2D uFogNoise;
uniform sampler2D uDepthTexture;
uniform sampler2D uPositionMask;
uniform sampler2D uSceneColor;

uniform float uOpacityMultiplier;
uniform vec2 uResolution;
uniform float uNear;
uniform float uFar;
uniform float uDepthFadeDistance;

in vec2 vUv;
in vec2 vUVScroll;
in vec2 vUVParallax;

in vec3 vWorldNormal;
in vec3 vViewDirWorld;

#include <packing>

void main()
{
    vec2 screenUV =
        gl_FragCoord.xy / uResolution;

    float sceneDepth =
        texture(uDepthTexture, screenUV).r;

    float sceneViewZ =
        perspectiveDepthToViewZ(
            sceneDepth,
            uNear,
            uFar
        );

    float fogViewZ =
        perspectiveDepthToViewZ(
            gl_FragCoord.z,
            uNear,
            uFar
        );

    float depthFade =
        clamp(
            (abs(sceneViewZ) - abs(fogViewZ))
            / uDepthFadeDistance,
            0.0,
            1.0
        );

    float fresnel =
        1.0 -
        abs(
            dot(
                normalize(vWorldNormal),
                normalize(vViewDirWorld)
            )
        );

    float angleFade =
        smoothstep(0.0, 0.8, fresnel);

    float fog =
        texture(
            uFogNoise,
            vUVParallax + vUVScroll
        ).r;

    fog = pow(fog, 0.834);

    float ring =
        texture(uPositionMask, vUv).r;

    float alpha =
        fog *
        depthFade *
        angleFade *
        ring *
        uOpacityMultiplier;

    vec3 colorScene = texture( uSceneColor, screenUV ).rgb;

    gl_FragColor =
        vec4(vec3(fog), alpha);

    #include <tonemapping_fragment>
    #include <colorspace_fragment>
}