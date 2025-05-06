vec2 uvScale(vec2 uv, vec2 scaleFactor )
{

	mat2 scale = mat2( vec2(  scaleFactor.x,  0.0 ), vec2( 0.0,  scaleFactor.y ) );
	
	uv -= 0.5;
	uv = uv * scale;
	uv += 0.5;

	return uv;

}

vec2 uvScale( 
vec2 uv, // uv coordniates
float scaleFactor // scale amount
)
{

	vec2 uvCentered = uv - 0.5;

	return ( scaleFactor == 0.0 ) ? uv : ( uvCentered * scaleFactor ) + 0.5;

}

vec2 uvScale( 
vec2 uv, // uv coordniates
vec2 pos, // scale position from
float scaleFactor // scale amount
)
{

	vec2 uvCentered = uv - pos;

	return ( scaleFactor == 0.0 ) ? uv : ( uvCentered * scaleFactor ) + pos;

}