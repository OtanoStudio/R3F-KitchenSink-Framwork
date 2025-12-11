//https://iquilezles.org/articles/biplanar/

vec4 mappingBox(
    sampler2D txtSample,
    vec3 position,
    vec3 normals,
    float blendFactor
)
{

    vec4 x = texture( txtSample, position.yz );
    vec4 y = texture( txtSample, position.zx );
    vec4 z = texture( txtSample, position.xy );
    
    vec3 w = pow( abs( normals ), vec3( blendFactor ) );
 
    return ( x * w.x + y * w.y + z * w.z ) / ( w.x + w.y + w.z );

}