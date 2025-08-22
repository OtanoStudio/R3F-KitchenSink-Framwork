// used for the motion vector functions

vec2 uvSubD(
    vec2 sizes,
    vec2 uv,
    float index
)
{
    index = index * ( 1.0 / sizes.x );

    uv /= sizes;
    uv.y += ( 1.0 / sizes.y ) * ( sizes.y - 1.0 );
    uv.x += floor( fract( index ) * sizes.x ) / sizes.x;
    uv.y -= floor( fract( index / sizes.y ) * sizes.y ) / sizes.y;

    return uv;

}