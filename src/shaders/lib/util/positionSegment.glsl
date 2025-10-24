// creates a segment cut off from the position

positionSegment( 
    float direction, // position.y or x
    float segmentSize, // size of the segment
)
{

    float segmentTop = step( direction, segmentSize );
    float segmentBottom = 1.0 - step( direction, -1.0 * segmentSize );

    return segmentTop * segmentBottom;

}