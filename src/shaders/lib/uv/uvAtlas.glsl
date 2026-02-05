//generic atlas uv function to select a tile

vec2 uvAtlas(
vec2 uv,
vec2 tileIndex,
vec2 atlasSize
)
{

    vec2 tile = 1.0 / atlasSize;

    return uv * tile + tileIndex * tile;

}

// returns the image as a vec4

vec4 uvAtlas(
vec2 uv,
vec2 tileIndex,
vec2 atlasSize,
sampler2D atlas
)
{

    vec2 tile = 1.0 / atlasSize;

    vec2 atlasUV = uv * tile + tileIndex * tile;

    return texture( atlas,atlasUV );

}