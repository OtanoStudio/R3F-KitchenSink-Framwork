// utility function for creating wind using a noise texture and animation


vec3 wind(
    sampler2D noiseTexture, // noise texture image
    vec3 position, // world space position
    vec2 positionOffset, // position offset of the wind as a vec2
    vec2 speed, // vec2( time ) * timingOffset
    vec2 windVelocity, // speed of the wind as a vec2
    vec2 uv, // texture coordinates
    float windOffset, // offset of the wind effect

)
{

    float windNoise = texture( noiseTexture, ( position.xz * positionOffset ) - ( speed * windVelocity ) ).r;
    float windAffect = pow( 1.0 - uv.y, 2.0 );

    vec3 rtn = vec3(
        windNoise * windVelocity.x,
        0.0,
        windNoise * windVelocity.y
    ) * windOffset;

    rtn *= windAffect;

    return rtn;

}