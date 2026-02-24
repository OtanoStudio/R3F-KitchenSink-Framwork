#include '../noise/noiseHash11.glsl'

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
    vec2 uv,
    int index,
    ivec2 size
)
{

    int count = size.x * size.y;
    int i = index % count;

    float x = float( i % size.x );
    float y = float( i / size.y );

    vec2 atlasSize = 1.0 / vec2( float( size.x ), float( size.y ) );

    return uv * atlasSize + ( vec2( x, y ) * atlasSize );

}


