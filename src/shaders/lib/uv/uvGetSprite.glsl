include ./noise/noiseHash11.glsl

// select sprite based on index x supply just the atlas size x

vec2 uvGetSprite(
float index,
float atlasSize
)
{

    return vec2(
        mod( index, atlasSize ),
        floor( index / atlasSize )
    );

}
// selects a random sprite, returns the uv for selection
vec2 uvGetRandomSprite(
    float seed,
    vec2 atlasSize
)
{

    float count = atlasSize.x * atlasSize.y;

    float index = floor( noiseHash11( seed ) * count );

    return uvGetSprite( index, atlasSize );

}
