vec2 uvParallax( 
    vec2 uv, // uv
    vec3 viewDir, // tangent space view direction
    float height, // height of the parallax
    float offset // offset for the depth
)
{
    return uv + ( viewDir.xy * ( height * offset ) );
}

vec2 uvParallax( 
    vec2 uv, // uv
    vec3 viewDir, // tangent space view direction
    float height, // height of the parallax
    float offset, // offset for the depth
    int type // sub or add
)
{
    return type <= 1 ? uv + ( viewDir.xy * ( height * offset ) ) : uv - ( viewDir.xy * ( height * offset ) );
}

vec2 uvParallax( 
    vec2 uv, // uv
    sampler2D height, // texture for depth
    float offset // offset for the depth
)
{
    float depth = texture( height, uv ).r;
    return uv + ( depth * offset );
}

vec2 uvParallax( 
    vec2 uv, // uv
    sampler2D height, // texture for depth
    float depthOffset, // depth offset
    float offset // offset 
)
{

    float depth = texture( height, uv ).r;
    vec2 rtn = uv - 0.5;
    rtn *= ( depth * depthOffset );

    return rtn + offset;

}

vec2 uvParallax( 
    vec2 uv, // uv
    float height, // generated height
    float offset // offset for the depth
)
{
    return uv + ( height * offset );
}

vec2 uvParallax( 
    vec2 uv, // uv
    float height, // texture for depth
    float depthOffset, // depth offset
    float offset // offset 
)
{
    
    vec2 rtn = uv - 0.5;
    rtn *= ( height * depthOffset );

    return rtn + offset;

}

// these scroll the depth texture
vec2 uvParallax( 
    vec2 uv, // uv
    sampler2D height, // texture for depth
    float depthOffset, // depth offset
    float offset, // offset
    vec2 time // fixed time with scroll speed included

)
{
    vec2 scroll = uv + time;

    float depth = texture( height, scroll ).r;
    vec2 rtn = uv - 0.5;
    rtn *= ( depth * depthOffset );

    return rtn + offset;

}

vec2 uvParallax(
sampler2D depthTexture,
vec2 uv,
vec3 viewTangent,
float depth

)
{
    float parallaxOffset = texture( depthTexture, uv ).r;

    vec2 parallaxUV = parallaxOffset * viewTangent.xy;

    parallaxUV *= -1.0 * depth;

    return uv + parallaxUV;

}

// ray marched version
vec2 uvParallaxRM(
    vec2 uv,
    vec3 viewDir,
    sampler2D depthMap,
    float heightScale
){
    float minLayers = 8.0;
    float maxLayers = 32.0;

    float numLayers = mix(maxLayers, minLayers, abs(viewDir.z));

    float layerDepth = 1.0 / numLayers;
    float currentLayerDepth = 0.0;

    vec2 P = viewDir.xy / viewDir.z * heightScale;
    vec2 deltaUV = P / numLayers;

    vec2 currentUV = uv;

    float currentDepth = texture(depthMap, currentUV).r;

    while(currentLayerDepth < currentDepth)
    {
        currentUV -= deltaUV;
        currentDepth = texture(depthMap, currentUV).r;
        currentLayerDepth += layerDepth;
    }

    return currentUV;
}

vec2 parallax(
    float depth, 
    vec3 n, 
    vec3 t, 
    vec3 v
) 
{
	vec3 normal = normalize(n);
	vec3 tangent = normalize(t);
	vec3 bitangent = cross(normal, tangent);
	vec3 view = normalize(v);
	vec3 view_tangent = vec3(dot(view, tangent), dot(view, bitangent), dot(view, normal));
	vec2 offset = (view_tangent.xy / max(view_tangent.z, 0.001)) * depth;
	offset = vec2(-offset.x, offset.y);
	
	return offset;

}
// unity parllax offset
vec2 uvParallax(
    float offset,
    float height,
    vec3 viewDir // must be in tangent space multiply viewDir my TBN matrix first
)
{
    
    float h = offset * height - height / 2.0;
    vec3 v = normalize( viewDir );
    v.z += 0.42;

    return h * ( v.xy / v.z );

}