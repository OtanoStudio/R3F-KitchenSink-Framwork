// manually convert the inverse of the projection matrix
mat4 inverseProjection( mat4 projMat, int type )
{
    // perspective
    if( type == 0 )
    {
        return mat4(
        1.0 / projMat[0][0], 0.0, 0.0, 0.0,
        0.0, 1.0 / projMat[1][1], 0.0, 0.0,
        0.0, 0.0, 0.0, 1.0 / projMat[3][2],
        0.0, 0.0, 1.0 / projMat[2][3], -projMat[2][2] / ( projMat[2][3] * projMat[3][2] )
        );
    }
    else // orthographic
    {

        return mat4(
        1.0 / projMat[0][0], 0.0, 0.0, -projMat[3][0] / projMat[0][0],
        0.0, 1.0 / projMat[1][1], 0.0, -projMat[3][1] /projMat[1][1],
        0.0, 0.0, 1.0 / projMat[2][2], -projMat[3][2] / projMat[2][2],
        0.0, 0.0, 0.0, 1.0
        );
        
    }
    

}