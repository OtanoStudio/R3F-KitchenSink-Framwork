vec2 uvPolar(vec2 uv) 
{
    float pi = 3.1415926;
    float pi2 = 6.2831853;

    vec2 uvCentered = uv - 0.5;
    float radius = length(uvCentered);
    float angle = ( atan(uvCentered.y, uvCentered.x) + pi ) / pi2;

    vec2 polarUV = vec2( radius, angle );

    return polarUV;

}


vec2 uvPolar( vec2 uv, float scale, float offset ) 
{
    float pi = 3.1415926;
    float pi2 = 6.2831853;

    vec2 uvCentered = uv - 0.5;
    float radius = length(uvCentered);
    float angle = ( atan(uvCentered.y, uvCentered.x) + pi ) / pi2;

    vec2 polarUV = vec2( radius, angle );
    polarUV.y *= scale;
    polarUV.x += offset;

    return polarUV;

}

vec2 uvPolar( vec2 uv, float scale, vec2 offset ) 
{
    float pi = 3.1415926;
    float pi2 = 6.2831853;

    vec2 uvCentered = uv - 0.5;
    float radius = length(uvCentered);
    float angle = ( atan(uvCentered.y, uvCentered.x) + pi ) / pi2;

    vec2 polarUV = vec2( radius, angle );
    polarUV.y *= scale;
    polarUV += offset;

    return polarUV;

}

vec2 uvPolar( vec2 uv, vec2 scale, vec2 offset ) 
{
    float pi = 3.1415926;
    float pi2 = 6.2831853;

    vec2 uvCentered = uv - 0.5;
    float radius = length(uvCentered);
    float angle = ( atan(uvCentered.y, uvCentered.x) + pi ) / pi2;

    vec2 polarUV = vec2( radius, angle );
    polarUV *= scale;
    polarUV += offset;

    return polarUV;

}

vec2 uvPolar( vec2 uv, vec2 multiplier, float scale, float offset ) 
{
    float pi = 3.1415926;
    float pi2 = 6.2831853;

    vec2 uvCentered = uv - 0.5;
    float radius = length(uvCentered);
    float angle = ( atan(uvCentered.y, uvCentered.x) + pi ) / pi2;

    vec2 polarUV = vec2( radius, angle );
    polarUV *= multiplier;
    polarUV.y *= scale;
    polarUV.x += offset;

    return polarUV;

}



// unity node
vec2 uvPolarUnity(
vec2 UV,
vec2 Center, 
float RadialScale, 
float LengthScale
)
{

    float pi2 = 6.283185307;
    vec2 delta = UV - Center;
    float radius = length( delta ) * 2.0 * RadialScale;
    float angle = atan( delta.x, delta.y ) * 1.0 /  pi2 * LengthScale;

    return vec2(radius, angle);

}

vec2 uvPolarGodot(
    vec2 uv, 
    vec2 center, 
    float zoom, 
    float repeat
)
{
    float pi2 = 6.283185307;
	vec2 dir = uv - center;
	float radius = length(dir) * 2.0;
	float angle = atan(dir.y, dir.x) / pi2;
    
	return vec2(radius * zoom, angle * repeat);

}