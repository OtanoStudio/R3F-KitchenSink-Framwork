// handles Quaternion rotations in shader land

vec4 quaternionIdentity()
{
    return vec4( vec3( 0.0 ), 1.0 );
}

vec4 quaternionMul( vec4 q1, vec4 q2 )
{
    return vec4(
        q1.w * q2.xyz + q2.w * q1.xyz + cross(q1.xyz, q2.xyz),
        q1.w * q2.w - dot(q1.xyz, q2.xyz)
    );
}

vec4 quaternionInverseUnit( vec4 q )
{
    return vec4( -q.xyz, q.w );
}

vec4 quaternionRotate( vec4 q, vec3 v )
{
    vec3 t = 2.0 * cross( q.xyz, v );
    return v + q.w * t + cross( q.xyz, t );
}

vec4 quaternionFromAxisAngle( vec3 axis, float angle ) 
{
    float half = angle * 0.5;
    return vec4(normalize(axis) * sin(half), cos(half));
}

vec4 quaternionNlerp( vec4 q1, vec4 q2, float t ) 
{
    float flip = sign(dot(q1, q2));
    return normalize(mix(q1, flip * q2, t));
}

vec4 quaternionSlerp( vec4 q1, vec4 q2, float t ) 
{
    float cosTheta = dot(q1, q2);
    
    vec4 q2_ = sign(cosTheta) * q2;
    cosTheta = abs(cosTheta);

    if (cosTheta > 0.9995) 
    {
        return normalize(mix(q1, q2_, t)); 
    }

    float theta = acos(cosTheta);
    float sinTheta = sin(theta);
    return (sin((1.0 - t) * theta) * q1 + sin(t * theta) * q2_) / sinTheta;
}

vec3 quaternionRotatePitch( vec3 v, float a )
{
    float s = sin(a), c = cos(a);
    return vec3(v.x, c * v.y - s * v.z, s * v.y + c * v.z);
}

vec3 quaternionRotateYaw( vec3 v, float a )
{
    float s = sin(a), c = cos(a);
    return vec3(c * v.x + s * v.z, v.y, -s * v.x + c * v.z);
}

vec3 quaternionRotateRoll( vec3 v, float a )
{
    float s = sin(a), c = cos(a);
    return vec3(c * v.x - s * v.y, s * v.x + c * v.y, v.z);
}
