vec3 pointPlaneProjection( 
    vec3 point, // vec3 3D point to project
    vec3 planeNormal, // vec3 plane's normal vector normalized
    vec3 planePosition // vec3 plane position vector
)
{
    planeNormal = normalize( planeNormal ); // Ensure the normal is normalized

    float d = dot( planeNormal, point - planePosition );
    return point - d * planeNormal;
    
}