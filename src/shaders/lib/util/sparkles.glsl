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

    return pow( dot( -view, normalize( rng + normal ) ), offset );

}