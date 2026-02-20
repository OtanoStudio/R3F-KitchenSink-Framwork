//utility function for creating wind using a noise texture and animation

vec3 wind(
    sampler2D noiseTexture, // noise texture image
    vec2 windUV, // world space position
    vec3 positionOffset, // position offset of the wind as a vec2
    float speed, // vec2( time ) * timingOffset
    vec2 windVelocity, // speed of the wind as a vec2
    float windStrength, // final multiplier
    vec2 uv, // texture coordinates
    vec2 windOffset // offset of the wind effect x overall multiplier y stiffness power
)
{

    vec2 scroll = windVelocity * speed;
    windUV *= positionOffset.xy;
    float windNoise = texture( noiseTexture, windUV  - scroll ).r * 2.0 - 1.0;
    float windAffect = pow( uv.y, windOffset.y );

    vec2 windDirection = normalize( windVelocity );
    vec3 rtn = vec3(
        windNoise * windDirection.x,
        windNoise * positionOffset.z,
        windNoise * windDirection.y
    ) * windOffset.x;

    rtn *= windAffect * windStrength;

    return rtn;

}

vec3 wind(
    sampler2D noiseTexture, // noise texture image
    vec2 windUV, // world space position
    vec3 positionOffset, // position offset of the wind as a vec2
    float speed, // vec2( time ) * timingOffset
    vec2 windVelocity, // speed of the wind as a vec2
    float windStrength, // final multiplier
    vec2 uv, // texture coordinates
    vec2 windOffset, // offset of the wind effect x overall multiplier y stiffness power
    vec2 phase // phase transition
)
{

    vec2 scroll = windVelocity * speed;
    windUV *= positionOffset.xy;
    float windNoise = texture( noiseTexture, windUV  - scroll + phase ).r * 2.0 - 1.0;
    float windAffect = pow( uv.y, windOffset.y );

    vec2 windDirection = normalize( windVelocity );
    vec3 rtn = vec3(
        windNoise * windDirection.x,
        windNoise * positionOffset.z,
        windNoise * windDirection.y
    ) * windOffset.x;

    rtn *= windAffect * windStrength;

    return rtn;

}

vec3 wind(
    sampler2D noiseTexture, // noise texture image
    vec2 windUV, // world space position xz
    vec3 positionOffset, // position offset of the wind as a vec3, z is the vertical lift
    float speed, // vec2( time ) * timingOffset
    vec2 windVelocity, // speed of the wind as a vec2 y is the strength modifier
    float windStrength, // overall strength
    vec2 uv, // texture coordinates
    vec2 windOffset, // offset of the wind effect
    vec3 gustOffset // gust offset for texture sampling x and  with z being the blend factor

)
{

    vec2 scroll = windVelocity * speed;
    vec2 scroll2 = scroll;
    scroll2 *= gustOffset.y;

    vec2 windUV1 = windUV;
    windUV1 *= positionOffset.xy;
    vec2 windUV2 = windUV1;
    windUV2 *= gustOffset.x;

    float windNoise = texture( noiseTexture, windUV1  - scroll ).r * 2.0 - 1.0;
    
    
    float windNoise2 = texture( noiseTexture, windUV2 - scroll ).g * 2.0 - 1.0;

    float windFinal = mix( windNoise, windNoise2, gustOffset.z );

    float windAffect = pow( uv.y, windOffset.y );

    float liftY = positionOffset.z > 0.0 ? windFinal * positionOffset.z :  0.0;

    vec2 windDirection = normalize( windVelocity );
    vec3 rtn = vec3(
        windFinal * windDirection.x,
        liftY,
        windFinal * windDirection.y
    ) * windOffset.x;

    rtn *= windAffect * windStrength;

    return rtn;

}

// wind with phase and turbulence/gusts
vec3 wind(
    sampler2D noiseTexture, // noise texture image
    vec2 windUV, // world space position xz
    vec3 positionOffset, // position offset of the wind as a vec3, z is the vertical lift
    float speed, // vec2( time ) * timingOffset
    vec2 windVelocity, // speed of the wind as a vec2 y is the strength modifier
    float windStrength, // overall strength
    vec2 uv, // texture coordinates
    vec2 windOffset, // offset of the wind effect
    vec2 phase, // phase offset to break up uniformity
    vec3 gustOffset // gust offset for texture sampling x and  with z being the blend factor

)
{

    vec2 scroll = windVelocity * speed;
    vec2 scroll2 = scroll;
    scroll2 *= gustOffset.y;

    vec2 windUV1 = windUV;
    windUV1 *= positionOffset.xy;
    vec2 windUV2 = windUV1;
    windUV2 *= gustOffset.x;

    float windNoise = texture( noiseTexture, windUV1  - scroll + phase ).r * 2.0 - 1.0;
    
    
    float windNoise2 = texture( noiseTexture, windUV2 - scroll ).g * 2.0 - 1.0;

    float windFinal = mix( windNoise, windNoise2, gustOffset.z );

    float windAffect = pow( uv.y, windOffset.y );

    vec2 windDirection = normalize( windVelocity );
    vec3 rtn = vec3(
        windFinal * windDirection.x,
        windFinal * positionOffset.z,
        windFinal * windDirection.y
    ) * windOffset.x;

    rtn *= windAffect * windStrength;

    return rtn;

}