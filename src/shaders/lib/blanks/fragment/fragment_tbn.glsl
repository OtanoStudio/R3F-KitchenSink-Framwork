uniform float uTime;
uniform float viewOffset;
uniform vec2 uResolution;

in vec3 vTangent;
in vec3 vBitangent;
in vec3 vNormal;
in mat3 TBN;
in vec2 vUv;
in vec3 vPositionWorld;
in vec3 vView;

#include ../util/viewDirTangent.glsl

void main()
{

    vec2 uv = vUv;
    vec2 uvWorld = vPositionWorld.xy;
    float time = uTime;

    vec3 viewTangentOffset = viewDirTangent( -vTangent, vBitangent, vNormal, vView );
    viewTangentOffset *= viewOffset;

    vec2 uvVT = uv + viewTangentOffset.xy; // used to sample textures

    gl_FragColor = vec4( uv, 0.8, 1.0 );

}