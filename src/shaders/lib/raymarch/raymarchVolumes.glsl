vec4 raymarchVolumes( 
    sampler3D volumeData, 
    vec3 colorMain,
    vec3 colorShadow,
    vec3 rayOrigin,
    vec3 rayDir,
    vec3 Offset,
    vec3 lightDir,
    float darkness,
    float transmittance,
    float lightAbsorption
)
{

    // constants for marhcing loop
    const int NUM_STEPS = 128;
    const float STEP_SIZE = 0.01;
    const int LIGHT_STEPS = 6;
    const float LIGHT_SIZE = 0.05;

    // core variables for assignment
    float density = 0.0;
    float transmission = 0.0;
    float lightAccum = 0.0;
    float lightFinal = 0.0;

    for( int i = 0; i < NUM_STEPS; i++ )
    {

        rayOrigin += ( rayDir * STEP_SIZE );

        vec3 sampledPosition = rayOrigin + Offset;

        float sampleDensity = texture( volumeData, sampledPosition ).r;

        density += sampleDensity;

        vec3 lightOrigin = sampledPosition;

        // lighting step for the volume

        lightAccum = 0.0; // reset accumilation every loop for better lighting

        for( int j = 0; j < LIGHT_STEPS; j++ )
        {

            lightOrigin += ( lightDir * LIGHT_SIZE );
            float density = texture( volumeData, lightOrigin ).r;
            lightAccum += density;

            float transmited = exp( -lightAccum );
            float shadow = darkness + transmited * ( 1.0 - darkness );
            lightFinal += density * transmittance * shadow;
            transmittance *= exp( -density * lightAbsorption );
        }

    }

    transmission = exp( -density * LIGHT_SIZE );

    vec3 volume = vec3( lightFinal, transmission, transmittance );
    float gradient = clamp( volume.x, 0.0, 1.0 );
    vec3 albedo = mix( colorMain, colorShadow, gradient );

    return vec4( albedo, (1.0 - volume.y ) );

}

vec3 raymarchVolumes( 
    sampler3D volumeData, 
    vec3 rayOrigin,
    vec3 rayDir,
    vec3 Offset,
    vec3 lightDir,
    float darkness,
    float transmittance,
    float lightAbsorption
)
{

    // constants for marhcing loop
    const int NUM_STEPS = 128;
    const float STEP_SIZE = 0.01;
    const int LIGHT_STEPS = 6;
    const float LIGHT_SIZE = 0.05;

    // core variables for assignment
    float density = 0.0;
    float transmission = 0.0;
    float lightAccum = 0.0;
    float lightFinal = 0.0;

    for( int i = 0; i < NUM_STEPS; i++ )
    {

        rayOrigin += ( rayDir * STEP_SIZE );

        vec3 sampledPosition = rayOrigin + Offset;

        float sampleDensity = texture( volumeData, sampledPosition ).r;

        density += sampleDensity;

        vec3 lightOrigin = sampledPosition;

        // lighting step for the volume

        lightAccum = 0.0; // reset accumilation every loop for better lighting

        for( int j = 0; j < LIGHT_STEPS; j++ )
        {

            lightOrigin += ( lightDir * LIGHT_SIZE );
            float density = texture( volumeData, lightOrigin ).r;
            lightAccum += density;

            float transmited = exp( -lightAccum );
            float shadow = darkness + transmited * ( 1.0 - darkness );
            lightFinal += density * transmittance * shadow;
            transmittance *= exp( -density * lightAbsorption );
        }

    }

    transmission = exp( -density * LIGHT_SIZE );

    return vec3( lightFinal, transmission, transmittance );

}