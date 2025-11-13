uniform vec3 uAlbedo;
uniform vec3 uDiffuse;
uniform vec3 uTranslucent;
uniform float uTime;

in vec2 vUv;
in vec3 worldPosition;
in vec3 worldNormal;
in vec3 viewDirection;
in vec3 normals;

#include '../lib/BRDF/translucent.glsl'
#include '../lib/lighting/lightLambert.glsl'

void main()
{

    vec2 uv = vUv;
    vec2 uvWorld = worldPosition.xy;

    vec3 lightDir = normalize( vec3( 0.0, 0.0, 1.0 ) );

    // diffuse lighting
    float lightingDiffuse = lightLambert( viewDirection, worldNormal );
    vec3 colorDiffuse = uDiffuse * lightingDiffuse;

    // albedo color, base color
    vec3 colorAlbedo = uAlbedo;

    // translucent factor
    vec3 lightingTranslucent = translucent( lightDir, worldNormal, viewDirection, 0.5, 4.0, 0.3, 0.2, 0.8 );
    vec3 colorTranslucent = uTranslucent * lightingTranslucent;

    vec3 colorFinal = colorAlbedo;

    colorFinal *= ( colorDiffuse + lightingTranslucent * uTranslucent );

    vec4 color = vec4( colorFinal, 1.0 );

    // uvWorld *= 0.5 + 0.5;
    float time = uTime;

    gl_FragColor = color;
    
    #include <tonemapping_fragment>
    #include <colorspace_fragment>
    
}