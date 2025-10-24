// creates a segment cut off from the position

float positionSegment( 
    float direction, // position.y or x
    float segmentSize // size of the segment
)
{

    float segmentTop = step( direction, segmentSize );
    float segmentBottom = 1.0 - step( direction, -1.0 * segmentSize );

    return segmentTop * segmentBottom;

}

float positionSegment( 
    float direction, // position.y or x
    float segmentSize, // size of the segment
    float moveSpeed
)
{

    direction += moveSpeed;

    float segmentTop = step( direction, segmentSize );
    float segmentBottom = 1.0 - step( direction, -1.0 * segmentSize );

    return segmentTop * segmentBottom;

}

float positionSegment( 
    float direction, // position.y or x
    float segmentSize, // size of the segment
    float moveSpeed, // speed of moving the segment
    float smoothFactor
)
{

    direction += moveSpeed;
    smoothFactor += direction;
    
    float segmentTop = smoothstep( direction, smoothFactor, segmentSize );
    float segmentBottom = 1.0 - smoothstep( direction, smoothFactor, -1.0 * segmentSize );

    return segmentTop * segmentBottom;

}