// version for flat stylized surfaces
vec2 uvMatcap( 
vec3 normal, // normal in world space
mat4 viewMat // view matrix
)
{

    vec3 v = normalize( ( viewMat * vec4( normal, 0.0 ) ).xyz );

    return v.xy * 0.5 + 0.5;
    
}
// version for rounded surfaces
vec2 uvMatcap( 
vec3 normal, // normal in world space
vec3 viewDir // view direction
)
{

    vec3 r = reflect( viewDir, normal );
    r.z = 1.0 - r.z;

    float m = 2.0 * length( r );

    return r.xy / m + 0.5;
    
}