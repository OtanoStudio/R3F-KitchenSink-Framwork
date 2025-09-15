float IGN(
    int pixelX, 
    int pixelY
) {

    return mod(
        52.9829189 * mod(0.06711056 * float(pixelX) + 0.00583715 * float(pixelY), 1.0),
        1.0
    );

}

float IGN(ivec2 pixel) 
{

    return mod(
        52.9829189 * mod(0.06711056 * float(pixel.x) + 0.00583715 * float(pixel.y), 1.0),
        1.0
    );

}

float IGN(vec2 pixel) 
{

    return mod(
        52.9829189 * mod(0.06711056 * pixel.x + 0.00583715 * pixel.y, 1.0),
        1.0
    );
    
}
