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
    windUV += positionOffset.xy;
    float windNoise = textureLod( noiseTexture, windUV  - scroll, 0.0 ).r * 2.0 - 1.0;
    float windAffect = smoothstep( 0.0, 1.0,pow( uv.y, windOffset.y ) );
    float lift =  windNoise * positionOffset.z * 0.2;

    vec2 windDirection = normalize( windVelocity );
    vec3 rtn = vec3(
        windNoise * windDirection.x,
        lift,
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
    float windNoise = textureLod( noiseTexture, windUV  - scroll + phase, 0.0 ).r * 2.0 - 1.0;
    float windAffect = smoothstep( 0.0, 1.0, pow( uv.y, windOffset.y ) );
    float lift =  windNoise * positionOffset.z * 0.2;

    vec2 windDirection = normalize( windVelocity );
    vec3 rtn = vec3(
        windNoise * windDirection.x,
        lift,
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

    float windNoise = textureLod( noiseTexture, windUV1  - scroll, 0.0 ).r * 2.0 - 1.0;
    
    
    float windNoise2 = textureLod( noiseTexture, windUV2 - scroll2, 0.0 ).g * 2.0 - 1.0;

    float windFinal = mix( windNoise, windNoise2, gustOffset.z );

    float windAffect = smoothstep( -1.0, 1.0, pow( uv.y, windOffset.y ) );

    float lift = windFinal * positionOffset.z * 0.2;

    vec2 windDirection = normalize( windVelocity );
    vec3 rtn = vec3(
        windFinal * windDirection.x,
        lift,
        windFinal * windDirection.y
    ) * windOffset.x;

    rtn *= windAffect * windStrength;

    return rtn;

}

// wind with phase and turbulence/gusts
// vec3 wind(
//     sampler2D noiseTexture, // noise texture image
//     vec2 windUV, // world space position xz
//     vec3 positionOffset, // position offset of the wind as a vec3, z is the vertical lift
//     float speed, // time * 0.3 used to scroll texture
//     vec2 windVelocity, // speed of the wind as a vec2
//     float windStrength, // final modifier of effects power, use a animated uniform
//     vec2 uv, // texture coordinates
//     vec2 windOffset, // offsets as a vec2 for wind stiffness Y, and wind affect X
//     vec2 phase, // phase per instance to break uniformity
//     vec2 gustOffset // gust offset for texture sampling x and  with z being the blend factor

// )
// {

//     vec2 scroll = windVelocity * speed;

//     vec2 windUV1 = windUV;
//     windUV1 *= positionOffset.xy;
//     vec2 windUV2 = windUV1;
//     windUV2 *= gustOffset.x;

//     float windNoise = texture( noiseTexture, windUV1  - scroll + phase ).r * 2.0 - 1.0;
//     float windNoise2 = texture( noiseTexture, windUV2 + phase ).g * 2.0 - 1.0;

//     // gust mask
//     float gustMask = smoothstep(0.55, 0.9, windNoise2);

//     // gust strength control
//     gustMask *= gustOffset.y;

//     // combine base wind + gust boost
//     float windFinal = windNoise + windNoise * gustMask;

//     //float windFinal = mix( windNoise, windNoise2, gustOffset.y );

//     float windAffect = smoothstep( -1.0, 1.0, pow( uv.y, windOffset.y ) );

//     vec2 windDirection = normalize( windVelocity );  
//     float lift = windFinal * positionOffset.z * 0.2;

//     vec3 rtn = vec3(
//         windFinal * windDirection.x,
//          lift,
//         windFinal * windDirection.y
//     ) * windOffset.x;

//     rtn *= windAffect * windStrength;

//     return rtn;

// }


// new wind deform returns a vec3 used on the position
vec3 windDeform(
    vec2 uvWind, // world space position x & z
    vec2 uv, // texture uv for noise sampling
    vec3 positionOffset, // xy offset worldspace, z offsets the y movement direction
    vec2 windDirection, // direction of the wind
    vec2 velocity, // speed per uv axis, xy & zw
    vec2 phase, // per blade uniformity breaker
    vec2 swayMultiplier, // blend multipliers for sway of wind
    float bendStiffness, // multiplier for blade bend
    float turbulenceOffset, // additional offset for turbulence
    float time, // time for scrolling texture
    float windMultiplier, // final strength of the wind
    float windOffset, // additional wind offset
    float liftOffset, // vertical lift offset
    float domainOffset, // offset for wind domain warp
    float rotation, // texture rotation for noise
    sampler2D windNoise, // base noise for wind movement
    sampler2D turbulenceNoise // noise for turbulence
    
)
{

    vec2 windDir = normalize( windDirection );
    vec2 windSpeed = windDir * velocity.x * time;
    vec2 windTurbulenceSpeed = windDir * velocity.y * time;

    vec2 windUV = uvWind;
    windUV *= positionOffset.xy;

    float s = sin( rotation );
    float c = cos( rotation );

    mat2 rot = mat2(
    c, -s,
    s,  c
    );

    vec2 turbulenceUV = windUV;
    turbulenceUV *=  turbulenceOffset;
    turbulenceUV = rot * turbulenceUV;

    vec2 warp = textureLod( turbulenceNoise, turbulenceUV - windTurbulenceSpeed + phase, 0.0 ).rg;
    warp = warp * 2.0 - 1.0;
    windUV += warp * domainOffset;

    float windBase = textureLod( windNoise, windUV - windSpeed + phase, 0.0 ).r * 2.0 - 1.0;
    float windTurbulence = warp.g;

    float windSway = windBase * swayMultiplier.x + windTurbulence * swayMultiplier.y;
    float bend = smoothstep( -1.0, 1.0, pow(  uv.y, bendStiffness ) );
    float lift = windSway * positionOffset.z * liftOffset;

    vec3 windPosition = vec3(
        windSway * windDir.x,
        lift,
        windSway * windDir.y
    ) * windOffset;

    windPosition *= bend * windMultiplier;

    return windPosition;

}


vec3 windDeform(
    vec2 uvWind, // world space position x & z
    vec2 uv, // texture uv for noise sampling
    vec3 positionOffset, // xy offset worldspace, z offsets the y movement direction
    vec2 windDirection, // direction of the wind
    vec2 velocity, // speed per uv axis, xy & zw
    vec2 phase, // per blade uniformity breaker
    vec2 swayMultiplier, // blend multipliers for sway of wind
    vec3 gustModifiers, // gust values
    vec2 gustBlend, // gust mix values
    vec2 gustTurbulence, // gust turbulence factors
    vec3 terrainWave, // terrain wave
    float windRotation, // angle to rotate the wind texture
    float bendStiffness, // multiplier for blade bend
    float turbulenceOffset, // additional offset for turbulence
    float time, // time for scrolling texture
    float windMultiplier, // final strength of the wind
    float windOffset, // additional wind offset
    float liftOffset, // vertical lift offset
    float domainOffset, // offset for wind domain warp
    sampler2D windNoise, // base noise for wind movement
    sampler2D turbulenceNoise // noise for turbulence
    
)
{

    vec2 windDir = normalize( windDirection );
    vec2 windSpeed = windDir * velocity.x * time;
    vec2 windTurbulenceSpeed = windDir * velocity.y * time;

    vec2 windUV = uvWind;
    windUV *= positionOffset.xy;

    float s = sin( windRotation );
    float c = cos( windRotation );

    mat2 rot = mat2(
    c, -s,
    s,  c
    );

    vec2 turbulenceUV = windUV;
    turbulenceUV *=  turbulenceOffset;
    turbulenceUV = rot * turbulenceUV;

    //vec2 warp = textureLod( turbulenceNoise, turbulenceUV - windTurbulenceSpeed + phase, 0.0 ).rg;
    vec2 warp = textureLod( turbulenceNoise, turbulenceUV - windTurbulenceSpeed, 0.0 ).rg;
    warp = warp * 2.0 - 1.0;
    windUV += warp * domainOffset;

    float windBase = textureLod( windNoise, windUV - windSpeed + phase, 0.0 ).r * 2.0 - 1.0;
    float windTurbulence = warp.g * 0.5;
    float windAxis = dot( uvWind * 0.2, windDir );
    float gusts = sin(  windAxis * gustModifiers.x - time * gustModifiers.y );

    gusts = gusts * 0.5 + 0.5;
    gusts = pow( gusts, gustModifiers.z );
    gusts *= gustTurbulence.x + windTurbulence * gustTurbulence.y;

    float windSway = sin(windBase * 1.5) * swayMultiplier.x + windTurbulence * swayMultiplier.y;
    float terrainSway = sin( windAxis * terrainWave.x - time * terrainWave.y );
    windSway *= 1.0 + terrainSway * terrainWave.z;
    windSway *= mix( gustBlend.x, gustBlend.y, gusts );

    float bend = pow(  uv.y, bendStiffness );
    bend = smoothstep( -1.0, 1.0, bend );
    float lift = windSway * positionOffset.z * liftOffset;


    vec3 windPosition = vec3(
        windSway * windDir.x,
        lift,
        windSway * windDir.y
    ) * windOffset;

    windPosition *= bend * windMultiplier;

    return windPosition;

}

/*
#
# Wind Function without domain warp
#
*/

vec3 windDeform(
    vec2 uvWind,
    vec2 uv,
    vec3 positionOffset,
    vec2 windDirection,
    vec2 velocity,
    vec2 phase,
    vec2 swayMultiplier,
    vec3 gustModifiers,
    vec2 gustBlend,
    vec3 terrainWave,
    float bendStiffness,
    float turbulenceOffset,
    float time,
    float windMultiplier,
    float windOffset,
    float liftOffset,
    float rotation,
    sampler2D windNoise,
    sampler2D turbulenceNoise
)
{

    vec2 windDir = normalize(windDirection);

    vec2 windSpeed = windDir * velocity.x * time;
    vec2 windTurbulenceSpeed = windDir * velocity.y * time;

    vec2 windUV = uvWind * positionOffset.xy;

    float s = sin(rotation);
    float c = cos(rotation);

    mat2 rot = mat2(
        c, -s,
        s,  c
    );

    vec2 turbulenceUV = rot * (windUV * turbulenceOffset);

    vec2 turbulence = textureLod(
        turbulenceNoise,
        turbulenceUV - windTurbulenceSpeed + phase,
        0.0
    ).rg;

    turbulence = turbulence * 2.0 - 1.0;

    // smooth turbulence (removes flicker)
    float windTurbulence = sin(turbulence.g * 1.5) * 0.25;

    float windBase = textureLod(
        windNoise,
        windUV - windSpeed + phase,
        0.0
    ).r * 2.0 - 1.0;

    float windAxis = dot(uvWind * 0.2, windDir);

    float gusts = sin(
        windAxis * gustModifiers.x - time * gustModifiers.y
    );

    gusts = gusts * 0.5 + 0.5;
    gusts = pow(gusts, gustModifiers.z);

    float windSway =
        sin(windBase * 1.4) * swayMultiplier.x +
        windTurbulence * swayMultiplier.y;

    float terrainSway = sin(
        windAxis * terrainWave.x - time * terrainWave.y
    );

    windSway *= 1.0 + terrainSway * terrainWave.z;

    windSway *= mix(gustBlend.x, gustBlend.y, gusts);

    float bend = smoothstep(-1.0, 1.0, pow(uv.y, bendStiffness));

    float lift = windSway * positionOffset.z * liftOffset;

    vec3 windPosition = vec3(
        windSway * windDir.x,
        lift,
        windSway * windDir.y
    ) * windOffset;

    windPosition *= bend * windMultiplier;

    return windPosition;

}

/*
#
# Chatgpt so called AAA
#
*/

vec3 windDeformAAA(
    vec2 uvWind,
    vec2 uv,
    vec3 positionOffset,
    vec2 windDirection,
    vec2 phaseOffset,
    float frequency,
    float speed,
    float turbulenceStrength,
    float bendStiffness,
    float liftOffset,
    float windMultiplier,
    float time,
    sampler2D turbulenceNoise
)
{

    vec2 windDir = normalize(windDirection);

    // world wind phase
    float phase = dot(uvWind, windDir) * frequency - time * speed;

    // base wind wave
    float windWave = sin(phase);

    // secondary wave (adds natural variation)
    float windWave2 = sin(phase * 0.5 + phaseOffset.x);

    float wind = windWave + windWave2 * 0.5;

    // turbulence (small influence only)
    vec2 turbulenceUV = uvWind * 0.05 + phaseOffset;
    float turbulence = texture(turbulenceNoise, turbulenceUV).r;
    turbulence = turbulence * 2.0 - 1.0;

    wind += turbulence * turbulenceStrength;

    // blade bend profile
    float bend = pow(uv.y, bendStiffness);
    bend = smoothstep(0.0, 1.0, bend);

    // vertical lift
    float lift = wind * positionOffset.z * liftOffset;

    vec3 windOffset = vec3(
        wind * windDir.x,
        lift,
        wind * windDir.y
    );

    windOffset *= bend * windMultiplier;

    return windOffset;
}
