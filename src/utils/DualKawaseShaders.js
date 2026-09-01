export const DualKawaseGLSL = /* glsl */ `

vec4 dualKawaseDown(sampler2D tex, vec2 uv, vec2 texelSize) {
    vec4 sum = texture2D(tex, uv) * 4.0;
    sum += texture2D(tex, uv + vec2(-1.0, -1.0) * texelSize);
    sum += texture2D(tex, uv + vec2( 1.0, -1.0) * texelSize);
    sum += texture2D(tex, uv + vec2(-1.0,  1.0) * texelSize);
    sum += texture2D(tex, uv + vec2( 1.0,  1.0) * texelSize);
    return sum * 0.125;
}

vec4 dualKawaseUp(sampler2D tex, vec2 uv, vec2 texelSize, float radius) {
    vec2 d = texelSize * radius;
    vec4 sum = vec4(0.0);
    
    sum += texture2D(tex, uv + vec2(-d.x * 2.0, 0.0));
    sum += texture2D(tex, uv + vec2(-d.x, d.y)) * 2.0;
    sum += texture2D(tex, uv + vec2(0.0, d.y * 2.0));
    sum += texture2D(tex, uv + vec2(d.x, d.y)) * 2.0;
    sum += texture2D(tex, uv + vec2(d.x * 2.0, 0.0));
    sum += texture2D(tex, uv + vec2(d.x, -d.y)) * 2.0;
    sum += texture2D(tex, uv + vec2(0.0, -d.y * 2.0));
    sum += texture2D(tex, uv + vec2(-d.x, -d.y)) * 2.0;
    
    return sum * 0.08333333333;
}
`;