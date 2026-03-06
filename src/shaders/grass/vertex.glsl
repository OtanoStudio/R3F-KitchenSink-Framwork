
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
        positionWorldSpace.xz,      // uvWind (large terrain scale wind field)
        uv,                       // blade uv
        vec3(0.3, 0.6, 0.3),     // positionOffset
        vec2(1.0, 0.0 ),        // windDirection
        vec2( 0.03, 0.08 ),        // velocity
        phase,                   // per instance variation
        vec2(1.23, 3.2 ),         // swayMultiplier
        2.2,                     // bendStiffness
        1.8,                     // turbulenceOffset
        time,                    // time
        1.6,                     // windMultiplier
        0.08,                     // windOffset
        0.01,                    // liftOffset
        0.3,                    // domainOffset
        uNoiseTexture,
        uNoiseTexture
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

