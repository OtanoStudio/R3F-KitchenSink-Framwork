float colorLuminance( vec3 color )
{

    return dot( color, vec3( 0.3, 0.59, 0.11 ) );

}

vec3 colorLuminance( vec3 color, float luminanceFactor )
{

    float l = dot( color, vec3( 0.3, 0.59, 0.11 ) );
    float c = luminanceFactor - l;

    return color += c;


}

vec4 colorLuminance( vec4 color, float luminanceFactor )
{

    float l = dot( color.rgb, vec3( 0.3, 0.59, 0.11 ) );
    float c = luminanceFactor - l;

    color.rgb += c;

    return color;

}