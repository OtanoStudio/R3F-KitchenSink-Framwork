float wireframe(
    vec3 baryCoords,
    float lineWidth
)
{

    vec3 b = fwidth( baryCoords );
    vec3 edge = smoothstep( vec3( 0.0 ), b * lineWidth, baryCoords );

    return min( min( edge.x, edge.y ), edge.z );

}