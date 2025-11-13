float sparkles(
     sampler2D noise,
     vec3 view,
     vec3 normal,
     vec2 uv,
     float offset
)
{

    vec3 rng = texture( noise, uv ).rgb - 0.5;
    rng = normalize( rng ); 

    return pow( dot( -view, normalize( rng ) ), offset );

}

float sparkles(
     sampler2D noise,
     vec3 view,
     vec3 normal,
     vec3 light,
     vec2 uv,
     float threshold
)
{

    vec3 rng = texture( noise, uv ).rgb * 2.0 - 1.0;
    rng = normalize( rng );

    vec3 R = reflect( light, rng );

    float sparkleFactor = max( 0.0, dot( R, view ) );

    if( sparkleFactor > threshold ) return 0.0;

    return 1.0 - sparkleFactor;

}