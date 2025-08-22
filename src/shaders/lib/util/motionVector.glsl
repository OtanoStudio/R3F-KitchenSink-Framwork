#include ./range.glsl

vec2 remap(
    vec2 _displacement, 
    float displacementStrength
) 
{

    vec2 displacement;
    displacement.rg = crange(_displacement.rg, vec2(0.0), vec2(1.0), vec2(-1.0), vec2(1.0));

    return displacement * displacementStrength;

}

vec4 getMap(
    sampler2D _tMap, float _blend, vec2 _subUv, vec2 _subUvNext, vec2 _displacement, vec2 _displacementNext
) 
{

    vec4 color = texture2D(_tMap, _subUv - _displacement * _blend);
    vec4 colorNext = texture2D(_tMap, _subUvNext + _displacementNext * (1.0 - _blend));

    return mix(color, colorNext, _blend);

}

vec2 getDisplacement(
    sampler2D _tMotion, vec2 _uv, float _displacement
) 
{

    vec2 displacement = texture2D(_tMotion, _uv).rg;

    return remap(displacement, _displacement);

}