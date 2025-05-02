// return a pixelized uv or breaks uv into rows and columns that the image can map too

vec2 uvPixelate( 
vec2 uv, // base uv
float pixelSize // size of the grid cells
)
{
    vec2 pixelatedUV = floor( uv * pixelSize ) / pixelSize;
}