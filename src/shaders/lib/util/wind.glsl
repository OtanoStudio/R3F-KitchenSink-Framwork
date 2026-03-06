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
    
    
    float windNoise2 = texture( noiseTexture, windUV2 - scroll2 ).g * 2.0 - 1.0;

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

//     float windAffect = pow( uv.y, windOffset.y );

//     vec2 windDirection = normalize( windVelocity );

//     vec3 rtn = vec3(
//         windFinal * windDirection.x,
//         windFinal * positionOffset.z * 0.2,
//         windFinal * windDirection.y
//     ) * windOffset.x;

//     rtn *= windAffect * windStrength;

//     return rtn;

// }

// vec3 wind(
//     sampler2D noiseTexture,
//     vec2 windUV,
//     vec3 positionOffset,
//     float speed,
//     vec2 windVelocity,
//     float windStrength,
//     vec2 uv,
//     vec2 windOffset,
//     vec2 phase,
//     vec3 gustOffset
// )
// {

//     vec2 scroll = windVelocity * speed;

//     vec2 windUV1 = windUV * positionOffset.xy;

//     vec4 noise = texture(noiseTexture, windUV1 - scroll + phase);

//     float windNoise  = noise.r * 2.0 - 1.0;
//     float windNoise2 = noise.g * 2.0 - 1.0;

//     float windFinal = mix(windNoise, windNoise2, gustOffset.z);

//     float windAffect = smoothstep(0.0, 1.0, uv.y);
//     windAffect = pow(windAffect, windOffset.y);

//     float anchor = smoothstep(0.1, 1.0, uv.y);

//     vec2 windDirection = normalize(windVelocity);

//     vec3 rtn = vec3(
//         windFinal * windDirection.x,
//         windFinal * positionOffset.z * 0.3,
//         windFinal * windDirection.y
//     ) * windOffset.x;

//     float tip = pow(uv.y, 2.0);
//     rtn.xz *= mix(1.0, 1.6, tip);

//     rtn *= anchor * windAffect * windStrength;

//     return rtn;

// }

// vec3 wind(
//     sampler2D noiseTexture,   // noise texture for gusts/turbulence
//     vec2 windUV,               // world-space XZ for noise sampling
//     vec3 positionOffset,       // offsets, Z = vertical lift
//     float speed,               // time factor to scroll noise
//     vec2 windVelocity,         // wind direction and speed
//     float windStrength,        // overall multiplier
//     vec2 uv,                   // vertex UV (0 = base, 1 = tip)
//     vec2 windOffset,           // X = lateral influence, Y = tip stiffness
//     vec2 phase,                // per-instance phase offset
//     vec3 gustOffset            // X/Y = per-instance scaling, Z = gust blend
// )
// {
//     // --- Noise sampling ---
//     vec2 scroll = windVelocity * speed;
//     vec2 windUV1 = windUV * positionOffset.xy;

//     vec4 noise = texture(noiseTexture, windUV1 - scroll + phase);
//     float windNoise  = noise.r * 2.0 - 1.0;
//     float windNoise2 = noise.g * 2.0 - 1.0;

//     // Base constant breeze
//     float baseWind = windNoise * 0.35;

//     // Gust turbulence
//     float gustWind = windNoise2;

//     // Gust mask from terrain-scale noise
//     float gustMask = smoothstep(0.55, 0.8, gustOffset.z);

//     // Amplify gusts
//     gustWind *= gustMask * 2.2;

//     // Combine
//     float windFinal = baseWind + gustWind;

//     // --- Tip stiffness and base anchoring ---
//     float windAffect = smoothstep(0.0, 1.0, uv.y);
//     windAffect = pow(windAffect, windOffset.y);

//     float anchor = smoothstep(0.1, 1.0, uv.y);

//     // --- Base wind shear (directional lean) ---
//     vec2 windDir = normalize(windVelocity);
//     float bend = uv.y * uv.y;
//     bend *= 1.2 - uv.y; // tip is more flexible

//     vec3 shear = vec3(
//         windDir.x,
//         0.0,
//         windDir.y
//     ) * bend * windStrength * 0.4;

//     // --- Assemble final offset ---
//     vec3 rtn = vec3(
//         windFinal * windDir.x,
//         windFinal * positionOffset.z * 0.3, // clamp vertical lift
//         windFinal * windDir.y
//     ) * windOffset.x;

//     // Apply tip exaggeration
//     float tip = pow(uv.y, 2.0);
//     rtn.xz *= mix(1.0, 1.6, tip);

//     // Apply anchor and tip weighting
//     rtn *= anchor * windAffect * windStrength;

//     // Add directional shear
//     rtn += shear;

//     return rtn;
// }

vec3 wind(
    sampler2D noiseTexture,
    vec2 windUV,
    vec3 positionOffset,
    float speed,
    vec2 windVelocity,
    float windStrength,
    vec2 uv,
    vec2 windOffset,
    vec2 phase,
    vec2 gustOffset
) {
    vec2 windDir = normalize(windVelocity);
    vec2 scroll  = windDir * speed;

    // --- Base wind layer (unchanged) ---
    vec2 windUV1 = windUV * positionOffset.xy;
    float windNoise = texture(noiseTexture, windUV1 - scroll + phase).r * 2.0 - 1.0;

    // --- Gust layer: travels in wind direction ---
    // gustOffset.x controls spatial scale of gusts
    vec2 windUV2 = windUV * positionOffset.xy * gustOffset.x;

    // Scroll gust UV along wind direction at a faster rate
    // so gusts visibly sweep across the field
    vec2 gustScroll = windDir * speed * 1.8;
    float windNoise2 = texture(noiseTexture, windUV2 - gustScroll + phase).g * 2.0 - 1.0;

    // --- Periodic gust envelope ---
    // Projects world position onto wind direction axis
    // so the gust "wave" sweeps spatially, not just temporally
    float windAxisPos = dot(windUV, windDir);

    // Low-frequency periodic wave travelling along wind direction
    // Adjust 0.4 to control gust wavelength (lower = wider gusts)
    float gustWave = sin(windAxisPos * 0.4 - speed * 2.5);

    // Second wave at different frequency for irregular spacing
    float gustWave2 = sin(windAxisPos * 0.17 - speed * 1.7 + 2.1);

    // Combine waves so gusts aren't evenly spaced
    float gustPeriodic = gustWave * 0.6 + gustWave2 * 0.4;

    // Sharpen into distinct gust fronts (raise 0.3 to tighten gusts)
    float gustFront = smoothstep(0.3, 1.0, gustPeriodic);

    // --- Varying gust strength ---
    // Modulate each gust front by the noise field so each
    // arriving gust has a different peak strength
    float gustStrengthVar = texture(noiseTexture, windUV2 * 0.3 - scroll * 0.5).b;
    gustStrengthVar = 0.4 + gustStrengthVar * 0.6; // remap to [0.4, 1.0]

    // Combine: gust front shape × noise texture mask × per-gust strength
    float gustMask = gustFront
                   * smoothstep(0.45, 0.85, windNoise2 * 0.5 + 0.5)
                   * gustStrengthVar
                   * gustOffset.y;

    // --- Final wind value ---
    // Base wind + gust boost (gust amplifies base, not replaces it)
    float windFinal = windNoise + abs(windNoise) * gustMask * 1.5;

    // Height falloff along blade
    float windAffect = pow(uv.y, windOffset.y);

    vec3 rtn = vec3(
        windFinal * windDir.x,
        windFinal * positionOffset.z * 0.2,
        windFinal * windDir.y
    ) * windOffset.x;

    rtn *= windAffect * windStrength;

    return rtn;
}

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
    sampler2D windNoise, // base noise for wind movement
    sampler2D turbulenceNoise // noise for turbulence
    
)
{

    vec2 windDir = normalize( windDirection );
    vec2 windSpeed = windDir * velocity.x * time;
    vec2 windTurbulenceSpeed = windDir * velocity.y * time;

    vec2 windUV = uvWind;
    windUV *= positionOffset.xy;

    mat2 rot = mat2(
    0.8, -0.6,
    0.6,  0.8
    );

    vec2 turbulenceUV = windUV;
    turbulenceUV *=  turbulenceOffset;
    turbulenceUV = rot * turbulenceUV;

    vec2 warp = texture( turbulenceNoise, turbulenceUV - windTurbulenceSpeed + phase ).rg;
    warp = warp * 2.0 - 1.0;
    windUV += warp * domainOffset;

    float windBase = texture( windNoise, windUV - windSpeed + phase ).r * 2.0 - 1.0;
    float windTurbulence = warp.g;

    float windSway = windBase * swayMultiplier.x + windTurbulence * swayMultiplier.y * windBase;
    float bend = pow(  uv.y, bendStiffness );
    float lift = windSway * positionOffset.z * liftOffset;

    vec3 windPosition = vec3(
        windSway * windDir.x,
        lift,
        windSway * windDir.y
    ) * windOffset;

    windPosition *= bend * windMultiplier;

    return windPosition;

}

// additional gust parameter
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
    vec2 gustTurbulence,
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

    mat2 rot = mat2(
    0.8, -0.6,
    0.6,  0.8
    );

    vec2 turbulenceUV = windUV;
    turbulenceUV *=  turbulenceOffset;
    turbulenceUV = rot * turbulenceUV;

    vec2 warp = texture( turbulenceNoise, turbulenceUV - windTurbulenceSpeed + phase ).rg;
    warp = warp * 2.0 - 1.0;
    windUV += warp * domainOffset;

    float windBase = texture( windNoise, windUV - windSpeed + phase ).r * 2.0 - 1.0;
    float windTurbulence = warp.g;

    float gusts = sin( dot( uvWind, windDir ) * gustModifiers.x - time * gustModifiers.y );

    gusts = gusts * 0.5 + 0.5;
    gusts = pow( gusts, gustModifiers.z );
    gusts *= gustTurbulence.x + abs( windTurbulence ) * gustTurbulence.y;

    float windSway = windBase * swayMultiplier.x + windTurbulence * swayMultiplier.y * windBase;
    windSway *= mix( gustBlend.x, gustBlend.y, gusts );

    float bend = pow(  uv.y, bendStiffness );
    float lift = windSway * positionOffset.z * liftOffset;


    vec3 windPosition = vec3(
        windSway * windDir.x,
        lift,
        windSway * windDir.y
    ) * windOffset;

    windPosition *= bend * windMultiplier;

    return windPosition;

}

// gusts with turbulence added to gusts
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

    mat2 rot = mat2(
    0.8, -0.6,
    0.6,  0.8
    );

    vec2 turbulenceUV = windUV;
    turbulenceUV *=  turbulenceOffset;
    turbulenceUV = rot * turbulenceUV;

    vec2 warp = texture( turbulenceNoise, turbulenceUV - windTurbulenceSpeed + phase ).rg;
    warp = warp * 2.0 - 1.0;
    windUV += warp * domainOffset;

    float windBase = texture( windNoise, windUV - windSpeed + phase ).r * 2.0 - 1.0;
    float windTurbulence = warp.g;

    float gusts = sin( dot( uvWind, windDir ) * gustModifiers.x - time * gustModifiers.y );

    gusts = gusts * 0.5 + 0.5;
    gusts = pow( gusts, gustModifiers.z );
    gusts *= gustTurbulence.x + abs( windTurbulence ) * gustTurbulence.y;

    float windSway = windBase * swayMultiplier.x + windTurbulence * swayMultiplier.y * windBase;
    float terrainSway = sin((uvWind.x + uvWind.y) * terrainWave.x - time * terrainWave.y);
    windSway *= 1.0 + terrainSway * terrainWave.z;
    windSway *= mix( gustBlend.x, gustBlend.y, gusts );

    float bend = pow(  uv.y, bendStiffness );
    float lift = windSway * positionOffset.z * liftOffset;


    vec3 windPosition = vec3(
        windSway * windDir.x,
        lift,
        windSway * windDir.y
    ) * windOffset;

    windPosition *= bend * windMultiplier;

    return windPosition;

}
