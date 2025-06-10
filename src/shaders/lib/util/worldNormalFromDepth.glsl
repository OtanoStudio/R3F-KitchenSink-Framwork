#include 'reconstructWorldPos.glsl'

vec3 worldNormalFromDepth(
vec2 uvScreen,
vec2 screenResolution,
sampler2D depthTexture,
mat4 invProjMat,
mat4 invViewMat,
)
{

    vec2 uvCenter = uvScreen;
    vec2 uvRight = uvScreen + vec2( 1.0, 0.0 ) / screenResolution;
    vec2 uvTop = uvScreen + vec2( 0.0, 1.0 ) / screenResolution;

    float depthCenter = texture(depthTexture, uvCenter).r;
    float depthRight = texture(depthTexture, uvRight).r;
    float depthTop = texture(depthTexture, uvTop).r;

    vec3 center = reconstructWorldPos(uvCenter, depthCenter, invProjMat, invViewMat, 0);
    vec3 right = reconstructWorldPos(uvRight, depthRight, invProjMat, invViewMat, 0);
    vec3 top = reconstructWorldPos(uvTop, depthTop, invProjMat, invViewMat, 0);

    vec3 normals = normalize( cross( top - center, right - center ) );

    return normals;
    
}