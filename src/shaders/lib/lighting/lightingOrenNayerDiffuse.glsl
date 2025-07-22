vec3 lightingOrenNayarDiffuse(
    vec3 n,
    vec3 l,
    vec3 v,
    float roughness
)
{

    float ndotl = max(dot(n, l), 0.0);
    float ndotv = max(dot(n, v), 0.0);
    float ldotv = dot(l, v);

    float s = ldotv - ndotl * ndotv;
    float t = s <= 0.0 ? 1.0 : max( ndotl, ndotv );

    float sigma2 = roughness * roughness;
    float A = 1.0 - 0.5 * sigma2 / ( sigma2 + 0.33 );
    float B = 0.45 * sigma2 / ( sigma2 + 0.09 );

    return vec3( ndotl * ( A + B * ( s / t ) ) );

}