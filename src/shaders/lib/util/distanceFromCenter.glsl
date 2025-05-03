// this method returns the distance from the center in world space use in vertex only
float distanceFromCenter( mat4 mMat, vec3 localPosition, int axis)
{
    float rtn = 0.0;

    switch( axis )
    {
        case 0:
            abs( ( mMat * vec4( localPosition, 1.0 ) ).x );
        break;

        case 1:
            abs( ( mMat * vec4( localPosition, 1.0 ) ).y );
        break;

        case 2:
            abs( ( mMat * vec4( localPosition, 1.0 ) ).z );
        break;

        default:
            abs( ( mMat * vec4( localPosition, 1.0 ) ).x );
        break;
    }

    return rtn;

}