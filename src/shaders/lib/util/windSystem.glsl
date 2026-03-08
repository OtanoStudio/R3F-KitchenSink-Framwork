// chatgpt generated in response to my version, supposed to be similar to game engines

float windGlobal(vec2 worldXZ, vec2 windDir, float freq, float speed, float time)
{
    float phase = dot(worldXZ, windDir) * freq - time * speed;

    float waveA = sin(phase);
    float waveB = sin(phase * 0.6 + 1.2);

    return waveA + waveB * 0.5;
}

float windGust(vec2 worldXZ, vec2 windDir, float time)
{
    float axis = dot(worldXZ, windDir);

    float gust =
        sin(axis * 0.05 - time * 0.8) *
        sin(axis * 0.015 - time * 0.35);

    gust = gust * 0.5 + 0.5;

    return gust * gust;
}

float windTurbulence(vec2 worldXZ, sampler2D noiseTex)
{
    float n = texture(noiseTex, worldXZ * 0.03).r;

    return (n * 2.0 - 1.0) * 0.15;
}

vec3 grassWind(
    vec3 worldPos,
    vec2 uv,
    vec2 windDirection,
    float time,
    sampler2D noiseTex
)
{
    vec2 windDir = normalize(windDirection);
    vec2 worldXZ = worldPos.xz;

    float global = windGlobal(worldXZ, windDir, 0.07, 1.2, time);
    float gust   = windGust(worldXZ, windDir, time);
    float turb   = windTurbulence(worldXZ, noiseTex);

    float wind = global * (0.6 + gust * 0.8) + turb;

    float bend = smoothstep(0.0, 1.0, pow(uv.y, 1.8));

    float lift = wind * 0.35;

    vec3 offset = vec3(
        wind * windDir.x,
        lift,
        wind * windDir.y
    );

    return offset * bend;
}