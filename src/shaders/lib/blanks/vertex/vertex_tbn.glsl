attribute vec4 tangent; // compute tangent or supply an attribute in the model

out vec3 vTangent;
out vec3 vBitangent;
out vec3 vNormal;
out mat3 TBN;
out vec2 vUv;
out vec3 vPositionWorld;
out vec3 vView;


void main()
{

    gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );

    // varyings sent to the fragment shader to be used for tangent space work includes TBN matrix too
    vUv = uv;
    vPositionWorld = modeMatrix * vec4( position, 1.0 );
    vView = cameraPosition - vPositionWorld;

    vTangent = normalize( modelMatrix * tangent.xyz );
    vNormal = normalize( normalMatrix * normal );
    // re-orient for ortho
    vTangent = normalize( vTangent - dot( vTangent, vNormal ) * vNormal );
    vBitangent =  cross( vNormal, vTangent ) * tangent.w; // handedness
    
    // TBN matrix for usage in fragment effects
    TBN = mat3(
        vTangent,
        vBitangent,
        vNormal
    );

}