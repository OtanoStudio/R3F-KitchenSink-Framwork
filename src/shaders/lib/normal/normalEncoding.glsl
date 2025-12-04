// sources https://twitter.com/Stubbesaurus/status/937994790553227264
// https://knarkowicz.wordpress.com/2014/04/16/octahedron-normal-vector-encoding/

#include '../util/constants.glsl'
#include '../util/sincos.glsl'

vec2 octaWrap( 
    vec2 normals
)
{

    return ( 1.0 - abs( normals.yx ) ) * ( normals.xy >= 0.0 ? 1.0 : -1.0  );

}

vec2 normalOctaEncode(
    vec3 normals
)
{

    normals /= ( abs( normals.x ) + abs( normals.y ) + abs( normals.z ) );
    normals.xy = normals.z >= 0.0 ? normals.xy : octaWrap( normals.xy );
    normals.xy * 0.5 + 0.5;

    return normals.xy;

}

vec3 normalOctaDecode( vec2 normals )
{

    normals *= 2.0 - 1.0;

    vec3 normal = vec3( normals.x, normals.y, 1.0 - abs( normals.x ) - abs( normals.y ) );
    float t = clamp( -normal.z, 0.0, 1.0 );
    normal.xy += normal.xy >= 0.0 ? -t : t;

    return normalize( normal );

}

vec2 normalSphereEncode( vec3 normals )
{

    vec2 normal;

    normal.x = atan( normals.x, normals.y ) * PI_INV;
    normal.y = normals.z;

    normal *= 0.5 + 0.5;

    return normal;

}

vec3 normalSphereDecode( vec2 normals )
{

    vec2 ang = normals * 2.0 - 1.0;

    vec2 scth = sincos( ang.x * PI );
    vec2 scphi = vec2( sqrt( 1.0 - ang.y * ang.y ), ang.y );

    vec3 normal = vec3(
        scth.y * scphi.x,
        scth.x * scphi.x,
        scphi.y
    );

    return normal;

}

vec3 normalEncode( vec3 normals )
{

    return normals * 0.5 + 0.5;

}

vec3 normalDecode( vec3 normals )
{

    return normals * 2.0 - 1.0;
    
}