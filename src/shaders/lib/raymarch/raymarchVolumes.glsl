#include ./intersectAABB.glsl

// vec4 raymarchVolumes(
//     sampler3D volumeData,
//     vec3 colorMain,
//     vec3 colorShadow,
//     vec3 rayOrigin,
//     vec3 rayDir,
//     vec3 Offset,
//     vec3 lightDir,
//     float darkness,
//     float lightAbsorption
// )
// {
//     // --------------------------------------------------
//     // Marching constants
//     // --------------------------------------------------

//     const int NUM_STEPS = 128;
//     const float STEP_SIZE = 0.01;

//     const int LIGHT_STEPS = 6;
//     const float LIGHT_SIZE = 0.03;

//     // --------------------------------------------------
//     // Volume bounds
//     // --------------------------------------------------

//     vec3 bMin = vec3(0.0);
//     vec3 bMax = vec3(1.0);

//     float tNear;
//     float tFar;

//     // --------------------------------------------------
//     // Ray / volume intersection
//     // --------------------------------------------------

//     if (!intersectAABB(
//         rayOrigin,
//         rayDir,
//         bMin,
//         bMax,
//         tNear,
//         tFar
//     ))
//     {
//         return vec4(0.0);
//     }

//     // Camera can be inside the volume
//     tNear = max(tNear, 0.0);

//     float rayLength = tFar - tNear;

//     if (rayLength <= 0.0)
//         return vec4(0.0);

//     // --------------------------------------------------
//     // Number of primary ray samples
//     // --------------------------------------------------

//     int marchSteps = min(
//         int(ceil(rayLength / STEP_SIZE)),
//         NUM_STEPS
//     );

//     // --------------------------------------------------
//     // Start at the volume entry point
//     // --------------------------------------------------

//     vec3 rayCurrent =
//         rayOrigin +
//         rayDir * (tNear + STEP_SIZE * 0.5);

//     // --------------------------------------------------
//     // Accumulation
//     // --------------------------------------------------

//     float transmittance = 1.0;
//     float opticalDepth = 0.0;
//     float lightFinal = 0.0;

//     // --------------------------------------------------
//     // Primary raymarch
//     // --------------------------------------------------

//     for (int i = 0; i < marchSteps; i++)
//     {
//         vec3 sampledPosition =
//             rayCurrent + Offset;

//         float sampleDensity =
//             texture(volumeData, sampledPosition).r;

//         if (sampleDensity > 0.001)
//         {
//             // ------------------------------------------
//             // Secondary light ray
//             // ------------------------------------------

//             vec3 lightOrigin = sampledPosition;

//             float lightOpticalDepth = 0.0;

//             for (int j = 0; j < LIGHT_STEPS; j++)
//             {
//                 lightOrigin +=
//                     lightDir * LIGHT_SIZE;

//                 float lightDensity =
//                     texture(volumeData, lightOrigin).r;

//                 lightOpticalDepth +=
//                     lightDensity * LIGHT_SIZE;
//             }

//             // ------------------------------------------
//             // Light transmission
//             // ------------------------------------------

//             float lightTransmittance =
//                 exp(
//                     -lightOpticalDepth *
//                     lightAbsorption
//                 );

//             float shadow =
//                 mix(
//                     darkness,
//                     1.0,
//                     lightTransmittance
//                 );

//             // ------------------------------------------
//             // Camera extinction
//             // ------------------------------------------

//             float extinction =
//                 sampleDensity *
//                 lightAbsorption;

//             float stepTransmittance =
//                 exp(
//                     -extinction *
//                     STEP_SIZE
//                 );

//             // ------------------------------------------
//             // Accumulate lighting
//             // ------------------------------------------

//             lightFinal +=
//                 sampleDensity *
//                 transmittance *
//                 shadow;

//             // ------------------------------------------
//             // Update camera transmittance
//             // ------------------------------------------

//             transmittance *=
//                 stepTransmittance;

//             opticalDepth +=
//                 sampleDensity *
//                 STEP_SIZE;

//             // ------------------------------------------
//             // Early termination
//             // ------------------------------------------

//             if (transmittance < 0.01)
//                 break;
//         }

//         // ----------------------------------------------
//         // Advance primary ray
//         // ----------------------------------------------

//         rayCurrent +=
//             rayDir * STEP_SIZE;
//     }

//     // --------------------------------------------------
//     // Final transmission
//     // --------------------------------------------------

//     float transmission =
//         exp(
//             -opticalDepth *
//             lightAbsorption
//         );

//     // --------------------------------------------------
//     // Color
//     // --------------------------------------------------

//     float gradient =
//         clamp(lightFinal, 0.0, 1.0);

//     vec3 albedo =
//         mix(
//             colorShadow,
//             colorMain,
//             gradient
//         );

//     return vec4(
//         albedo,
//         1.0 - transmission
//     );
// }

vec4 raymarchVolumes(
    sampler3D volumeData,
    vec3 colorMain,
    vec3 colorShadow,
    vec3 rayOrigin,
    vec3 rayDir,
    vec3 Offset,
    vec3 lightDir,
    float darkness,
    float lightAbsorption
)
{
    const int NUM_STEPS = 128;
    const int LIGHT_STEPS = 6;

    const float LIGHT_SIZE = 0.03;

    vec3 bMin = vec3(0.0);
    vec3 bMax = vec3(1.0);

    float tNear;
    float tFar;

    if (!intersectAABB(
        rayOrigin,
        rayDir,
        bMin,
        bMax,
        tNear,
        tFar
    ))
    {
        return vec4(0.0);
    }

    tNear = max(tNear, 0.0);

    float rayLength = tFar - tNear;

    if (rayLength <= 0.0)
        return vec4(0.0);

    // Distribute samples across the entire intersection.
    float stepSize =
        rayLength / float(NUM_STEPS);

    // Start at the volume entrance.
    vec3 rayCurrent =
        rayOrigin +
        rayDir * tNear;

    float transmittance = 1.0;
    float opticalDepth = 0.0;
    float lightFinal = 0.0;

    for (int i = 0; i < NUM_STEPS; i++)
    {
        // Sample current position.
        vec3 sampledPosition =
            rayCurrent + Offset;

        float sampleDensity =
            texture(
                volumeData,
                sampledPosition
            ).r;

        if (sampleDensity > 0.001)
        {
            // ------------------------------------------
            // Light march
            // ------------------------------------------

            vec3 lightOrigin =
                sampledPosition;

            float lightOpticalDepth = 0.0;

            for (int j = 0; j < LIGHT_STEPS; j++)
            {
                lightOrigin +=
                    lightDir * LIGHT_SIZE;

                float lightDensity =
                    texture(
                        volumeData,
                        lightOrigin
                    ).r;

                lightOpticalDepth +=
                    lightDensity *
                    LIGHT_SIZE;
            }

            float lightTransmittance =
                exp(
                    -lightOpticalDepth *
                    lightAbsorption
                );

            float shadow =
                mix(
                    darkness,
                    1.0,
                    lightTransmittance
                );

            // ------------------------------------------
            // Camera extinction
            // ------------------------------------------

            float extinction =
                sampleDensity *
                lightAbsorption;

            float stepTransmittance =
                exp(
                    -extinction *
                    stepSize
                );

            // ------------------------------------------
            // Lighting
            // ------------------------------------------

            lightFinal +=
                sampleDensity *
                transmittance *
                shadow;

            // ------------------------------------------
            // Camera transmittance
            // ------------------------------------------

            transmittance *=
                stepTransmittance;

            opticalDepth +=
                sampleDensity *
                stepSize;

            if (transmittance < 0.01)
                break;
        }

        // Always advance.
        rayCurrent +=
            rayDir * stepSize;
    }

    float transmission =
        exp(
            -opticalDepth *
            lightAbsorption
        );

    float gradient =
        clamp(
            lightFinal,
            0.0,
            1.0
        );

    vec3 albedo =
        mix(
            colorShadow,
            colorMain,
            gradient
        );

    return vec4(
        albedo,
        1.0 - transmission
    );
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
    const float LIGHT_SIZE = 0.03;

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

vec4 raymarchVolumes(
    sampler3D volumeData,
    vec3 colorMain,
    vec3 colorShadow,
    vec3 rayOrigin,
    vec3 rayDir,
    vec3 offset,
    vec3 lightDir,
    float darkness,
    float lightAbsorption,
    int   numSteps,  
    float stepSize,
    int   lightSteps,
    float lightStepSize
)
{
    float density      = 0.0;
    float transmittance = 1.0; 
    float lightFinal    = 0.0;

    for ( int i = 0; i < numSteps; i++ )
    {
        rayOrigin += rayDir * stepSize;
        vec3 samplePos = rayOrigin + offset;

       
        if ( any( lessThan( samplePos, vec3( 0.0 ) ) ) ||
             any( greaterThan( samplePos, vec3( 1.0 ) ) ) )
            continue;

        float sampleDensity = textureLod( volumeData, samplePos, 0.0 ).r;
        if ( sampleDensity <= 0.0 ) continue; 

        density += sampleDensity * stepSize;

        vec3  lightPos    = samplePos;
        float lightAccum  = 0.0;
        float lightStepLen = lightStepSize;

        for ( int j = 0; j < lightSteps; j++ )
        {
            lightPos += lightDir * lightStepLen;
            lightAccum += textureLod( volumeData, lightPos, 0.0 ).r * lightStepLen;
            lightStepLen *= 1.6;
        }

        float shadowTransmit = exp( -lightAccum * lightAbsorption );
        float shadow = darkness + shadowTransmit * ( 1.0 - darkness );

        lightFinal += sampleDensity * stepSize * transmittance * shadow;

        transmittance *= exp( -sampleDensity * stepSize * lightAbsorption );
        if ( transmittance < 0.01 ) break;
        
    }

    float gradient = clamp( lightFinal, 0.0, 1.0 );
    vec3  albedo   = mix( colorShadow, colorMain, gradient );

    return vec4( albedo, 1.0 - transmittance );

}

vec4 raymarchVolumes( 
    sampler3D volumeData, 
    vec3 colorMain,
    vec3 colorShadow,
    vec3 rayOrigin,
    vec3 rayDir,
    vec3 Offset,
    vec3 lightDir,
    float darkness,
    float lightAbsorption,
    bool beep
)
{

    // constants for marhcing loop
    const int NUM_STEPS = 128;
    const float STEP_SIZE = 0.01;
    const int LIGHT_STEPS = 4;
    const float LIGHT_SIZE = 0.03;

    // core variables for assignment
    float density = 0.0;
    float transmission = 0.0;
    float lightAccum = 0.0;
    float lightFinal = 0.0;
    float transmittance = 1.0;

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
            float lightDensity = texture( volumeData, lightOrigin ).r;
            lightAccum += lightDensity;

            float transmited = exp( -lightAccum );
            float shadow = darkness + transmited * ( 1.0 - darkness );
            lightFinal += density * transmittance * shadow;
            transmittance *= exp( -density * lightAbsorption );
        }

    }

    transmission = exp( -density * LIGHT_SIZE );

    vec3 volume = vec3( lightFinal, transmission, transmittance );
    float gradient = clamp( volume.x, 0.0, 1.0 );
    vec3 albedo = mix( colorShadow, colorMain, gradient );

    return vec4( albedo, (1.0 - volume.y ) );

}

