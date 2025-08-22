// returns a vec2 of a uv grid, floor and fract

vec2 uvGrid( vec2 uv, float size )
{

    float c = fract( uv * size ) / size;
    float i = floor( uv * size );

    return vec2( i, c );

}