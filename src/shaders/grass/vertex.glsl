
uniform sampler2D uNoiseTexture;
uniform float uTime;
uniform sampler2D uVelocityTexture;
uniform mat4 uCamInverseMatrix;

varying vec2 vUv;
flat varying int vInstance;
varying vec3 vNormals;
varying vec3 vView;
varying vec3 vPosWlrd;

#include '../lib/util/wind.glsl'
#include '../lib/util/randomFloat.glsl'
#include '../lib/uv/uvStretch.glsl'
#include '../lib/uv/uvRotate.glsl'

void main()
{

    

    vec4 positionWorldSpace = modelMatrix * vec4( position, 1.0 );
    vec4 positionWorld = modelMatrix * instanceMatrix * vec4( position, 1.0 );
    float time = uTime * 0.35;

    vec2 phase = vec2(
        float( gl_InstanceID ) * 0.317,
        float( gl_InstanceID ) * 0.491 );
    
    vec3 windPosition = windDeform(

    positionWorldSpace.xz,   // uvWind (world space wind field)
    uv,                      // blade UV

    vec3(
        0.4,                // terrain wind scale X
        0.8,                // terrain wind scale Z
        0.35                 // vertical lift influence
    ),

    vec2(
        1.0,                 // wind direction X
        0.35                 // wind direction Z
    ),

    vec2(
        0.025,               // base wind speed
        0.08                 // turbulence speed
    ),

    phase,                   // per-instance variation

    vec2(
        1.25,                // base sway strength
        2.1                  // turbulence sway influence
    ),

    vec3(
        0.35,                // gust spatial size
        0.28,                // gust speed
        2.0                  // gust sharpness
    ),

    vec2(
        0.7,                 // calm wind multiplier
        1.38                  // strong gust multiplier
    ),

    vec2(
        0.3,                 // base gust influence
        0.5                  // turbulence influence
    ),

    vec3(
        0.05,                // terrain wave size
        0.12,                // terrain wave speed
        0.55                 // terrain wave strength
    ),

    1.6,                    // bend stiffness

    0.8,                    // turbulence UV scale

    time,                   // time

    0.8,                    // final wind multiplier

    0.085,                  // wind offset

    0.015,                  // lift offset

    0.15,                   // domain warp strength

    uNoiseTexture,     // base wind noise

    uVelocityTexture    // turbulence noise

);


    // Get the instance world position (translation only, ignore rotation)
vec3 instanceWorldPos = vec3(instanceMatrix[3]);

// Build billboard axes
vec3 toCamera = normalize(cameraPosition - instanceWorldPos);
vec3 up = vec3(0.0, 1.0, 0.0);
vec3 right = normalize(cross(up, toCamera));
// Recalculate up to be orthogonal
up = normalize(cross(toCamera, right));

// Build billboard rotation matrix
mat3 billboardMatrix = mat3(right, up, toCamera);

// Apply billboard rotation to the vertex position + wind
vec3 positionFinal = position + windPosition;
vec3 billboardPos = billboardMatrix * positionFinal;

// Combine with instance translation only
vec4 worldPosition = vec4(instanceWorldPos + billboardPos, 1.0);

gl_Position = projectionMatrix * viewMatrix * worldPosition;

vUv = uv;
vInstance = gl_InstanceID;
vNormals = normalize(normalMatrix * (billboardMatrix * normal));
vView = normalize(cameraPosition - worldPosition.xyz);
vPosWlrd = ( modelMatrix * instanceMatrix * vec4( 0.0, 0.0, 0.0, 1.0 ) ).xyz;

}

