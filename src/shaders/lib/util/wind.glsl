// utility function for creating wind using a noise texture and animation

vec3 wind(
    sampler2D noiseTexture, // noise texture image
    vec2 windUV, // world space position
    vec3 positionOffset, // position offset of the wind as a vec2
    vec2 speed, // vec2( time ) * timingOffset
    vec3 windVelocity, // speed of the wind as a vec2
    vec2 uv, // texture coordinates
    vec2 windOffset, // offset of the wind effect x overall multiplier y stiffness power


)
{

    vec2 scroll = speed * windVelocity;
    windUV *= positionOffset.xy;
    float windNoise = texture( noiseTexture, windUV  - scroll ).r * 2.0 - 1.0;
    float windAffect = 1.0 - uv.y;
    windAffect *= windOffset.y;

    vec2 windDirection = normalize( windVelocity.xy );
    vec3 rtn = vec3(
        windNoise * windDirection.x,
        windNoise * positionOffset.z,
        windNoise * windDirection.y
    ) * windOffset.x;

    rtn *= windAffect * windVelocity.z;

    return rtn;

}

vec3 wind(
    sampler2D noiseTexture, // noise texture image
    vec2 windUV, // world space position
    vec3 positionOffset, // position offset of the wind as a vec2
    vec2 speed, // vec2( time ) * timingOffset
    vec3 windVelocity, // speed of the wind as a vec2
    vec2 uv, // texture coordinates
    vec2 windOffset, // offset of the wind effect
    float phase, // phase offset to break up uniformity

)
{

    vec2 scroll = speed * windVelocity.xy;
    windUV *= positionOffset.xy;
    float windNoise = texture( noiseTexture, windUV  - scroll + phase ).r * 2.0 - 1.0;
    float windAffect = 1.0 - uv.y;
    windAffect *= windOffset.y;

    vec2 windDirection = normalize( windVelocity.xy );
    vec3 rtn = vec3(
        windNoise * windDirection.x,
        windNoise * positionOffset.z,
        windNoise * windDirection.y
    ) * windOffset.x;

    rtn *= windAffect * windVelocity.z;

    return rtn;

}

vec3 wind(
    sampler2D noiseTexture, // noise texture image
    vec2 windUV, // world space position
    vec3 positionOffset, // position offset of the wind as a vec2
    vec2 speed, // vec2( time ) * timingOffset
    vec3 windVelocity, // speed of the wind as a vec2
    vec2 uv, // texture coordinates
    vec2 windOffset, // offset of the wind effect
    vec3 gustOffset, // gust offset for texture sampling x and  with z being the blend factor

)
{

    vec2 scroll = speed * windVelocity.xy;
    windUV *= positionOffset.xy;
    float windNoise = texture( noiseTexture, windUV  - scroll ).r * 2.0 - 1.0;

    scroll *= gustOffset.y;
    windUV *= gustOffset.x;

    float windNoise2 = texture( noiseTexture, windUV - scroll ).g;
    float windFinal = mix( windNoise, windNoise2, gustOffset.z );

    float windAffect = 1.0 - uv.y;
    windAffect *= windOffset.y;

    vec2 windDirection = normalize( windVelocity.xy );
    vec3 rtn = vec3(
        windFinal * windDirection.x,
        windFinal * positionOffset.z,
        windFinal * windDirection.y
    ) * windOffset.x;

    rtn *= windAffect * windVelocity.z;

    return rtn;

}

// wind with phase and turbulence/gusts
vec3 wind(
    sampler2D noiseTexture, // noise texture image
    vec2 windUV, // world space position xz
    vec3 positionOffset, // position offset of the wind as a vec3, z is the vertical lift
    vec2 speed, // vec2( time ) * timingOffset
    vec3 windVelocity, // speed of the wind as a vec3 z is the strength modifier
    vec2 uv, // texture coordinates
    vec2 windOffset, // offset of the wind effect
    float phase, // phase offset to break up uniformity
    vec3 gustOffset, // gust offset for texture sampling x and  with z being the blend factor

)
{

    vec2 scroll = speed * windVelocity.xy;
    windUV *= positionOffset.xy;
    float windNoise = texture( noiseTexture, windUV  - scroll + phase ).r * 2.0 - 1.0;
    
    scroll *= gustOffset.y;
    windUV *= gustOffset.x;
    float windNoise2 = texture( noiseTexture, windUV - scroll ).g;

    float windFinal = mix( windNoise, windNoise2, gustOffset.z );

    float windAffect = 1.0 - uv.y;
    windAffect *= windOffset.y;

    vec2 windDirection = normalize( windVelocity.xy );
    vec3 rtn = vec3(
        windFinal * windDirection.x,
        windFinal * positionOffset.z,
        windFinal * windDirection.y
    ) * windOffset.x;

    rtn *= windAffect * windVelocity.z;

    return rtn;

}