
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
        fract( float( gl_InstanceID ) * 0.37 ),
        fract( float( gl_InstanceID ) * 0.73 ) );
    
    vec3 windPosition = windDeform(
    uvStretch( positionWorld.xz * 0.01, vec2( 1.0, 4.6 ) ),        // uvWind
    uv,                      // blade uv

    vec3(1.0, 1.0, 0.3 ),     // positionOffset

    vec2(1.0, 0.35),         // windDirection

    vec2(0.12, 0.04),        // velocity (wind, turbulence)

    phase,                       // phase per blade

    vec2(1.0, 0.35),         // swayMultiplier

    vec3(0.35, 0.6, 2.0),    // gustModifiers
    vec2(0.85, 1.25),        // gustBlend
    vec3(0.15, 0.45, 0.4),   // terrainWave

    3.0,                     // bendStiffness

    0.12,                    // turbulenceOffset

    time,

    0.8,                     // windMultiplier
    0.3,                     // windOffset
    0.25,                    // liftOffset
    0.45,                   // texture rotation angle
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

