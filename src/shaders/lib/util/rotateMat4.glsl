// mat4 rotation

mat4 rotationMatrix(
    vec3 axis, 
    float angle
) 
{

    axis = normalize(axis);
    float s  = sin(angle);
    float c  = cos(angle);
    float oc = 1.0 - c;

    return mat4(
        oc*axis.x*axis.x + c,          oc*axis.x*axis.y + s*axis.z,  oc*axis.z*axis.x - s*axis.y,  0.0,
        oc*axis.x*axis.y - s*axis.z,   oc*axis.y*axis.y + c,         oc*axis.y*axis.z + s*axis.x,  0.0,
        oc*axis.z*axis.x + s*axis.y,   oc*axis.y*axis.z - s*axis.x,  oc*axis.z*axis.z + c,         0.0,
        0.0, 0.0, 0.0, 1.0
    );

}