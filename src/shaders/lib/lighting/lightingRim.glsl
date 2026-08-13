float lightingRim( vec3 normals, vec3 direction, float density, bool clamped )
{

    float rimCalc = 1.0 - dot( normalize( normals ), normalize( direction ) );
    float rimRtn = ( clamped ) ? clamp( rimCalc, 0.0, 1.0 ) : rimCalc;

    return pow( rimRtn , density );

}

float lightingRim( vec3 normals, vec3 direction, float density, float scale )
{

    float rimCalc = 1.0 - dot( normalize( normals ), normalize( direction ) );


    return scale * pow( rimCalc , density );

}