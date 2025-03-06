vec2 uvSpherize( vec2 UV, vec2 Center, float Strength, vec2 Offset )
{

    vec2 delta = UV - Center;
    float delta2 = dot(delta.xy, delta.xy);
    float delta4 = delta2 * delta2;
    vec2 delta_offset = delta4 * Strength;
    return UV + delta * delta_offset + Offset;

}