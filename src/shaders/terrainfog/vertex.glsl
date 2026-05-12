// attribute vec4 tangent;

// uniform sampler2D uTerrainMap;
// uniform float uDisplacementFactor;
// uniform bool uUseTerrainMap;
// uniform float uFogSpeed;
// uniform float uTime;
// uniform float ufogParallaxAmt;
// uniform sampler2D uPositionMask;

// out vec2 vUv;
// out vec3 vWorldPosition;
// out vec3 vWorldNormal;
// out vec2 vUVScroll;
// out vec3 vViewDirTangent;
// out vec2 vUVParallax;
// out vec2 vUVFog;
// out vec4 vClipSpacer;

// #include '../lib/util/safeNormalize.glsl'

// void main() 
// {

//     vUv = uv;
//     vec2 uvScroll = vec2( uTime * uFogSpeed, 0.0 );
//     vec4 worldPos = modelMatrix * vec4(position, 1.0);
//     vec2 uvFog = worldPos.xz * uDisplacementFactor;

//     vec3 worldNormal = safeNormalize( normalMatrix * normal );
//     vec3 worldTangent = safeNormalize( ( modelMatrix * tangent ).xyz );
//     vec3 worldBitangent = safeNormalize( cross( vWorldNormal, worldTangent ) * tangent.w );

//     vec3 viewDirection = safeNormalize( cameraPosition - worldPos.xyz );
//     vec3 viewDirTangent = vec3(
//         dot( viewDirection, worldTangent ),
//         dot( viewDirection, worldBitangent ),
//         dot( viewDirection, worldNormal )
//     );
//     float heightMap = texture( uTerrainMap, uvFog ).r;
//     vec2 uvParallax = uvFog + safeNormalize( -viewDirection.xy ) * heightMap * ufogParallaxAmt;
//     float ring = texture( uPositionMask, uv ).r;
//     float positionOffset = textureLod( uTerrainMap, uvFog + uvScroll , 0.0 ).r;
//     vec3 nN = normal;
//     nN *= positionOffset * 0.6 * ring;
//     vec3 yPOffset = vec3( 0.0, 0.03, 0.0 );

//     yPOffset += nN;
//     vec3 nPos = position;
//     nPos += yPOffset;

    


//     gl_Position = projectionMatrix * modelViewMatrix * vec4( nPos, 1.0 );

//     vClipSpacer = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
//     vUVScroll = uvScroll;
//     vWorldNormal = worldNormal;
//     vViewDirTangent = viewDirection;
//     vUVFog = uvFog;
//     vUVParallax = uvParallax;

// }

uniform sampler2D uTerrainMap;
uniform sampler2D uPositionMask;

uniform float uDisplacementFactor;
uniform float uFogSpeed;
uniform float uTime;
uniform float uFogParallaxAmt;

out vec2 vUv;
out vec2 vUVScroll;
out vec2 vUVParallax;
out vec3 vWorldPosition;
out vec3 vWorldNormal;
out vec3 vViewDirWorld;

#include '../lib/util/safeNormalize.glsl'

void main()
{
    vUv = uv;

    vec2 uvScroll = vec2(uTime * uFogSpeed, 0.0);

    vec3 displacedPos = position;

    vec4 worldPos = modelMatrix * vec4(position, 1.0);

    vec2 uvFog = worldPos.xz * uDisplacementFactor;

    float heightMap = texture(uTerrainMap, uvFog).r;

    vec3 viewDirWorld =
        safeNormalize(cameraPosition - worldPos.xyz);

    vec2 uvParallax =
        uvFog +
        safeNormalize(-viewDirWorld.xz)
        * heightMap
        * uFogParallaxAmt;

    float ring = texture(uPositionMask, uv).r;

    float positionOffset =
        textureLod(
            uTerrainMap,
            uvFog + uvScroll,
            0.0
        ).r;

    displacedPos +=
        vec3(0.0, 0.03, 0.0) +
        normal * positionOffset * 0.6 * ring;

    vec4 displacedWorldPos =
        modelMatrix * vec4(displacedPos, 1.0);

    gl_Position =
        projectionMatrix *
        viewMatrix *
        displacedWorldPos;

    vUVScroll = uvScroll;
    vUVParallax = uvParallax;

    vWorldPosition = displacedWorldPos.xyz;

    vWorldNormal =
        safeNormalize(mat3(modelMatrix) * normal);

    vViewDirWorld = viewDirWorld;
}