/*
* Original author and code
* https://godotshaders.com/shader/seamless-texture-sampler-without-repeating-patterns-tiling/
* Author: hungryproton
* Profile: https://godotshaders.com/author/hungryproton/
*/

vec3 textureBlend(
    sampler2D tex, 
    sampler2D noise, 
    vec2 uv, 
    float v
) 
{
    float k = texture2D( noise, 0.005 * uv).x;
    
    vec2 duvdx = dFdx(uv);
    vec2 duvdy = dFdy(uv);
    
    float l = k * 8.0;
    float f = fract(l);
    
    float ia = floor(l);
    float ib = ia + 1.0;
    
    vec2 offa = sin(vec2(3.0, 7.0) * ia);
    vec2 offb = sin(vec2(3.0, 7.0) * ib);
    
    vec3 cola = texture2D(tex, uv + v * offa).xyz;
    vec3 colb = texture2D(tex, uv + v * offb).xyz;

    vec3 ab = cola - colb;
    float sum_ab = ab.x + ab.y + ab.z;
    
    return mix(cola, colb, smoothstep(0.2, 0.8, f - 0.1 * sum_ab));

}