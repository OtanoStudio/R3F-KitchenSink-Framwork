#include .median.glsl

float msdf(
    sampler2D tex, 
    vec2 uv, 
    float pxRange, 
    float threshold
)
{

    vec3 sample = texture2D(tex, uv).rgb;
    float sd = median(sample.r, sample.g, sample.b);
    float screenPxDistance = pxRange * (sd - threshold);

    return smoothstep(-0.5, 0.5, screenPxDistance);

}

float msdfAdv(
    sampler2D msdfTexture, 
    vec2 uv, 
    float pxRange
)
{

    vec2 msdfUnit = pxRange / vec2(textureSize(msdfTexture, 0));
    vec3 msdf = texture(msdfTexture, uv).rgb;
    float sigDist = median(msdf.r, msdf.g, msdf.b) - 0.5;
    sigDist *= dot(msdfUnit, 0.5 / fwidth(uv));

    return sigDist;

}

float msdfAlpha(
    sampler2D tex, 
    vec2 uv, 
    float smoothing
)
{

    vec3 msdf = texture(tex, uv).rgb;
    float sigDist = median(msdf.r, msdf.g, msdf.b) - 0.5;
    float width = fwidth(sigDist) * smoothing;

    return smoothstep(-width, width, sigDist);

}