float IGN(
    int x,
    int y
) 
{

    return fract(52.9829189 * fract(0.06711056 * float(x) + 0.00583715 * float(y)));

}

float IGN(
    float x,
    float y
) 
{

    return fract(52.9829189 * fract(0.06711056 * x + 0.00583715 * y));

}

float IGN(vec2 pixel) 
{

    return fract(52.9829189 * fract(0.06711056 * pixel.x + 0.00583715 * pixel.y));

}

float IGN(ivec2 pixel) 
{

    return fract(52.9829189 * fract(0.06711056 * float(pixel.x) + 0.00583715 * float(pixel.y)));

}

float IGN(
    int pixelX, 
    int pixelY, 
    int frame
) 
{

    frame = frame % 64; 
    float x = float(pixelX) + 5.588238 * float(frame);
    float y = float(pixelY) + 5.588238 * float(frame);
    return fract(52.9829189 * fract(0.06711056 * x + 0.00583715 * y));

}


float IGN(
    ivec2 pixel, 
    int frame
) 
{

    frame = frame % 64;
    vec2 xy = vec2(pixel) + 5.588238 * float(frame);
    return fract(52.9829189 * fract(0.06711056 * xy.x + 0.00583715 * xy.y));

}


float IGN(vec3 coords) 
{

    int frame = int(coords.z) % 64;
    vec2 xy = coords.xy + 5.588238 * float(frame);
    return fract(52.9829189 * fract(0.06711056 * xy.x + 0.00583715 * xy.y));

}

int IGN(
    int x,
    int y
) 
{

  return (142 * x + 79 * y) & 255;

}
