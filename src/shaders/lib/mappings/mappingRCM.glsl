vec2 rayMarchRelaxedConeStep(
    in vec2      vTexCoords,
    in vec3      vViewDir,
    in sampler2D coneMap,
    in float     depthScale,
    in int       maxIterations,
    in int       bSteps
) 
{

    vec3 rayDir = normalize( vec3( -vViewDir.xy * depthScale, -vViewDir.z ) );

    float horizontalLen = length( rayDir.xy );
    float verticalLen   = abs( rayDir.z );

    vec3 rayPos = vec3( vTexCoords, 1.0 );
    vec3 lastPosAbove = rayPos;

    for ( int i = 0; i < maxIterations; ++i ) 
    {

        vec4 texSample = texture( coneMap, rayPos.xy );
        float currentHeight = texSample.r;
        float coneRatio     = texSample.g;

        if (rayPos.z <= currentHeight) 
        {

            break;

        }

        lastPosAbove = rayPos;

        float denominator = verticalLen + ( horizontalLen / max( coneRatio, 0.0001 ) );
        float deltaRay    = ( rayPos.z - currentHeight ) / denominator;

        deltaRay = max( deltaRay, 0.001 );

        rayPos += rayDir * deltaRay;

    }

    if ( rayPos.z <= texture( coneMap, rayPos.xy ).r ) 
    {

        vec3 minPos = rayPos;       
        vec3 maxPos = lastPosAbove; 

        for (int j = 0; j < bSteps; ++j) 
        {

            vec3 midPos = mix( minPos, maxPos, 0.5 );
            float h = texture( coneMap, midPos.xy ).r;

            if ( midPos.z < h ) 
            {

                minPos = midPos;

            } 
            else 
            {

                maxPos = midPos; 

            }
        }

        return mix( minPos.xy, maxPos.xy, 0.5 );

    }

    return rayPos.xy;

}