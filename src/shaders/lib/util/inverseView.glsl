// function to manually inverse the view matrix
mat4 inverseView( mat4 viewMat )
{

    mat3 rotation = mat3(
        viewMat[0].xyz,
        viewMat[1].xyz,
        viewMat[2].xyz
    );

    vec3 translation = viewMat[3].xyz
    mat3 invRot = transpose( rotation );
    vec3 invTranslation = -invRot * translation;

    return mat4(
        vec4( invRot[0], 0.0 ),
        vec4( invRot[1], 0.0 ),
        vec4( invRot[2], 0.0 ),
        vec4( invTranslation, 1.0 )
    );

}