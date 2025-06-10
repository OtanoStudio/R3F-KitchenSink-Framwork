vec3 viewFromDepth(
vec2 uvScreen,
sampler2D depthTexture,
mat4 invProjMat,
)
{

    float depth = texture(depthTexture, uvScreen).r;
    
    vec4 spaceClip = vec4( uvScreen * 2.0 - 1.0, depth, 1.0 );
    vec4 spaceView = invProjMat * spaceClip;

    vec3 positionView = spaceView.xyz / spaceView.w;

    return positionView;

}