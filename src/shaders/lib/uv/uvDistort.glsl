vec2 uvDistort( vec2 uv, sampler2D noise, vec2 pan, float time, float intensity )
{
    vec2 uv1 = uv;
    vec2 timed = pan * time;
    vec2 uvPanned = uv + timed;

    float uvNoise = texture( noise, uvPanned ).r;
    uvNoise = ( uvNoise - 0.5 ) * intensity;

    return uv1 + uvNoise;

}