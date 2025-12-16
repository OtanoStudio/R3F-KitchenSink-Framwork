uniform float uTime;

uniform vec3 uColor1;
uniform vec3 uColor2;
uniform vec3 uColor3;

uniform vec3 uSizes;
uniform vec3 uDensity;
uniform vec3 uLifetime;

varying vec2 vUv;

#include '../lib/util/constants.glsl'
#include '../lib/easings/easings.glsl'

// Simple 2D hash
float hash21(vec2 p){
    p = fract(p*vec2(123.34,456.21));
    p += dot(p,p+45.32);
    return fract(p.x*p.y);
}

// Simple 2D noise
float noise(vec2 p){
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash21(i);
    float b = hash21(i+vec2(1.0,0.0));
    float c = hash21(i+vec2(0.0,1.0));
    float d = hash21(i+vec2(1.0,1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a,b,u.x) + (c-a)*u.y*(1.0-u.x) + (d-b)*u.x*u.y;
}


float square(vec2 uv, float width)
{
	uv = uv - 0.5;
	
	vec2 abs_uv = abs(uv.xy);
	float shape = step( max(abs_uv.x, abs_uv.y), width );
	return shape;
}

float squareStroke( vec2 uv, float width, float stroke_width )
{
	uv = uv - 0.5;
	
	vec2 abs_uv = abs(uv.xy);
	float dist = max(abs_uv.x, abs_uv.y);
	float stroke = 1.0 - step(dist, width ) - step( dist, width + stroke_width );
	return clamp( stroke, 0.0, 1.0 );
}

float squareOutline(vec2 uv, float size, float thickness)
{
    uv -= 0.5;
    vec2 d = abs(uv);
    float dist = max(d.x, d.y);

    float outer = step(dist, size);
    float inner = step(dist, size - thickness);

    return outer - inner;
}

float squareLayer(
    vec2 uv,
    float grid,
    float life,
    float speed,
    bool outline,
    float baseSize,
    float density,
    int easingFamily,
    int easeType
){
    vec2 id = floor(uv * grid);

    // Grid-local UV centered per cell
    vec2 gv = fract(uv * grid) - 0.5;

    float rnd = hash21(id);

    // Normalized life (1 → 0)
    float tt = clamp(1.0 - (uTime * speed) / life, 0.0, 1.0);
    float t = easing(tt, easingFamily, easeType);

    // Density decay
    if (rnd > density * t) return 0.0;

    // Square size
    float squareSize = baseSize * t * (0.8 + 0.4 * hash21(id + 0.3));

    // Stable outline thickness (fixes missing border at start)
    float outlineThickness = clamp(
        squareSize * 0.35,
        baseSize * 0.05,
        baseSize * 0.2
    );

    float dist = max(abs(gv.x), abs(gv.y));
    float innerSize = max(squareSize - outlineThickness, 0.0);

    float mask = outline
        ? step(dist, squareSize) - step(dist, innerSize)
        : step(dist, squareSize);

    // Noise dissolve (kept)
    float n = noise(id * 0.5 + vec2(uTime * 0.5));
    float dissolve = smoothstep(t - 0.2, t, n);

    return mask * dissolve * t;
}

void main()
{

    vec2 uv = vUv;

    float m1 = squareLayer(uv,12.0,uLifetime.r,1.0,false,uSizes.r,uDensity.r, 7, 3 );
    float m2 = squareLayer(uv,18.0,uLifetime.g,1.2,true,uSizes.g,uDensity.g, 11, 3 );
    float m3 = squareLayer(uv,24.0,uLifetime.b,1.5,false,uSizes.b,uDensity.b, 9, 3);

    vec3 col = uColor1*m1 + uColor2*m2 + uColor3*m3;
    float alpha = m1 + m2 + m3;

    gl_FragColor = vec4(col,alpha);

    #include <tonemapping_fragment>
    #include <colorspace_fragment>

}