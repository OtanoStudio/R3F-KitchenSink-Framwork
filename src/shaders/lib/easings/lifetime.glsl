float lifetime(
    float time,
    float spawnTime,
    float lifeDuration
)
{

    return clamp(
        ( time - spawnTime ) / lifeDuration,
        0.0,
        1.0
    );


}