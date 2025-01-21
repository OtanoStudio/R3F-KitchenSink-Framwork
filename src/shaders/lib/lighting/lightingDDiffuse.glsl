// disney diffuse, normals in world space
// light & view are dot products
float lightingDDiffuse( float light, float view, float h, float roughness)
{

    float fd90 = 0.5 + 2.0 * h * h * roughness;

    float lightScatter = 1.0 + ( fd90 - 1.0 ) * pow( 1.0 - light, 5.0 );
    float viewScatter = 1.0 + ( fd90 - 1.0 ) * pow( 1.0 - view, 5.0 );

    return viewScatter * lightScatter / 3.14159265359;

}
// loaded version that does everything
float lightingDDiffuse( vec3 normals, vec3 lightDir, vec3 viewDir, float roughness)
{

    vec3 H = normalize( lightDir + viewDir );
    lightDir = normalize( lightDir );
    viewDir = normalize( viewDir );

    float light = max( dot( normals, lightDir ), 0.0 );
    float view = max( dot( normals, viewDir ), 0.0 );
    float h = max( dot( lightDir, H ), 0.0 );

    float fd90 = 0.5 + 2.0 * h * h * roughness;

    float lightScatter = 1.0 + ( fd90 - 1.0 ) * pow( 1.0 - light, 5.0 );
    float viewScatter = 1.0 + ( fd90 - 1.0 ) * pow( 1.0 - view, 5.0 );

    return viewScatter * lightScatter / 3.14159265359;

}