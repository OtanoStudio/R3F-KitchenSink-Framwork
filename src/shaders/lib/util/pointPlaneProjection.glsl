vec3 pointPlaneProjection( 
    vec3 point, // vec3 3D point to project
    vec3 planeNormal, // vec3 plane's normal vector normalized
    vec3 planePosition, // vec3 plane position vector
)
{
    planeNormal = normalize( planeNormal ); // Ensure the normal is normalized

    float d = dot( planeNormal, point - planePosition );
    return point - d * planeNormal;
    
}

vec3 pointPlaneProjection( 
    vec3 p, // vec3 3D point to project
    vec3 n, // vec3 plane's normal vector normalized
    float h, // dot of normal and position
    bool c, // clip bounds
)
{

    float rtn = dot( p, normalize( n ) ) - h;

    if( c == true )
    {
        rtn = min( abs( rtn ), 1.0 );
    }

    return vec3( rtn );
    
}