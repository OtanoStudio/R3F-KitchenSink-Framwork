
// uniform sampler2D uNoiseTexture;
// uniform float uTime;
// uniform sampler2D uVelocityTexture;
// uniform mat4 uCamInverseMatrix;

// varying vec2 vUv;
// flat varying int vInstance;
// varying vec3 vNormals;
// varying vec3 vView;
// varying vec3 vPosWlrd;

// #include '../lib/util/wind.glsl'
// #include '../lib/util/randomFloat.glsl'
// #include '../lib/uv/uvStretch.glsl'
// #include '../lib/uv/uvRotate.glsl'

// void main()
// {

    

//     vec4 positionWorldSpace = modelMatrix * vec4( position, 1.0 );
//     vec4 positionWorld = modelMatrix * instanceMatrix * vec4( position, 1.0 );
//     float time = uTime * 0.6;

//     vec2 phase = vec2(
//         fract( float( gl_InstanceID ) * 0.37 ),
//         fract( float( gl_InstanceID ) * 0.73 ) );
    
//     vec3 windPosition = windDeform(
//     uvStretch( positionWorld.xz * 0.01, vec2( 1.0, 4.6 ) ),        // uvWind
//     uv,                      // blade uv

//     vec3(1.0, 1.8, 0.3 ),     // positionOffset

//     vec2(1.0, 0.35),         // windDirection

//     vec2(0.18, 0.08),        // velocity (wind, turbulence)

//     phase,                       // phase per blade

//     vec2(1.0, 0.35),         // swayMultiplier

//     vec3(0.35, 0.6, 2.0),    // gustModifiers
//     vec2(0.85, 1.25),        // gustBlend
//     vec3(0.15, 0.45, 0.4),   // terrainWave

//     3.0,                     // bendStiffness

//     0.12,                    // turbulenceOffset

//     time,

//     0.8,                     // windMultiplier
//     0.3,                     // windOffset
//     0.25,                    // liftOffset
//     0.45,                   // texture rotation angle
//     uNoiseTexture,     // base wind noise
//     uVelocityTexture    // turbulence noise
// );


//     // Get the instance world position (translation only, ignore rotation)
// vec3 instanceWorldPos = vec3(instanceMatrix[3]);

// // Build billboard axes
// vec3 toCamera = normalize(cameraPosition - instanceWorldPos);
// vec3 up = vec3(0.0, 1.0, 0.0);
// vec3 right = normalize(cross(up, toCamera));
// // Recalculate up to be orthogonal
// up = normalize(cross(toCamera, right));

// // Build billboard rotation matrix
// mat3 billboardMatrix = mat3(right, up, toCamera);

// // Apply billboard rotation to the vertex position + wind
// vec3 positionFinal = position + windPosition;
// vec3 billboardPos = billboardMatrix * positionFinal;

// // Combine with instance translation only
// vec4 worldPosition = vec4(instanceWorldPos + billboardPos, 1.0);

// gl_Position = projectionMatrix * viewMatrix * worldPosition;

// vUv = uv;
// vInstance = gl_InstanceID;
// vNormals = normalize(normalMatrix * (billboardMatrix * normal));
// vView = normalize(cameraPosition - worldPosition.xyz);
// vPosWlrd = ( modelMatrix * instanceMatrix * vec4( 0.0, 0.0, 0.0, 1.0 ) ).xyz;

// }

// gemini tests

// uniform sampler2D uNoiseTexture;
// uniform sampler2D uVelocityTexture;
// uniform float uTime;
// uniform mat4 uCamInverseMatrix;

// // Leva Uniform Configurations
// uniform vec2 uWindDirection;
// uniform vec2 uVelocity;
// uniform vec2 uSwayMultiplier;
// uniform vec3 uGustModifiers;
// uniform vec2 uGustBlend;
// uniform vec2 uGustTurbulence;
// uniform vec3 uTerrainWave;
// uniform float uBendStiffness;
// uniform float uTurbulenceOffset;
// uniform float uWindMultiplier;
// uniform float uWindOffset;
// uniform float uLiftOffset; // Note: Ensure your wind.glsl signature uses this or handle it via positionOffset.z
// uniform float uDomainOffset;
// uniform mat2 uPrecalculatedRot; 

// varying vec2 vUv;
// flat varying int vInstance;
// varying vec3 vNormals;
// varying vec3 vView;
// varying vec3 vPosWlrd;

// // Internal dependencies
// #include '../lib/util/wind.glsl'
// #include '../lib/util/randomFloat.glsl'
// #include '../lib/uv/uvStretch.glsl'
// #include '../lib/uv/uvRotate.glsl'

// void main()
// {
//     vec4 positionWorldSpace = modelMatrix * vec4( position, 1.0 );
//     vec4 positionWorld = modelMatrix * instanceMatrix * vec4( position, 1.0 );
//     float time = uTime * 0.6;

//     vec2 phase = vec2(
//         fract( float( gl_InstanceID ) * 0.37 ),
//         fract( float( gl_InstanceID ) * 0.73 )
//     );
    
//     // Auto-calculates structural constraints dynamically matching individual blade size instance transforms
//     float localHeight = 0.6 * instanceMatrix[1][1];
//     vec3 dynamicPositionOffset = vec3(1.0, localHeight, localHeight * 0.5);

//     // FIXED CALL: Arguments re-ordered to line up exactly with your provided windDeform parameters
//     vec3 windPosition = windDeform(
//         uvStretch( positionWorld.xz * 0.002, vec2( 1.0, 4.6 ) ), // 1. uvWind
//         uv,                                                    // 2. uv (blade)
//         dynamicPositionOffset,                                 // 3. positionOffset
//         uWindDirection,                                        // 4. windDirection
//         uVelocity,                                             // 5. velocity
//         phase,                                                 // 6. phase
//         uSwayMultiplier,                                       // 7. swayMultiplier
//         uGustModifiers,                                        // 8. gustModifiers
//         uGustBlend,                                            // 9. gustBlend
//         uGustTurbulence,                                       // 10. gustTurbulence
//         uTerrainWave,                                          // 11. terrainWave
//         uPrecalculatedRot,                                     // 12. precalculatedRot
//         uBendStiffness,                                        // 13. bendStiffness
//         uTurbulenceOffset,                                     // 14. turbulenceOffset
//         time,                                                  // 15. time
//         uWindMultiplier,                                       // 16. windMultiplier
//         uWindOffset,                                           // 17. windOffset
//         uDomainOffset,                                         // 18. domainOffset
//         uNoiseTexture,                                         // 19. windNoise
//         uVelocityTexture                                       // 20. turbulenceNoise
//     );

//     // Handle instance billboard positions
//     vec3 instanceWorldPos = vec3(instanceMatrix[3]);

//     // Build Spherical Billboard Matrix transformations
//     vec3 toCamera =
//     cameraPosition - instanceWorldPos;

// toCamera.y = 0.0;
// toCamera = normalize(toCamera);

// vec3 up = vec3(0.0, 1.0, 0.0);

// vec3 right =
//     normalize(cross(up, toCamera));

// vec3 forward =
//     normalize(cross(right, up));

// mat3 billboardMatrix =
//     mat3(right, up, forward);

//     // Apply billboard space mapping onto vertices after adding wind displacement
//     vec3 positionFinal = position + windPosition;
//     vec3 billboardPos = billboardMatrix * positionFinal;

//     vec4 worldPosition = vec4(instanceWorldPos + billboardPos, 1.0);

//     gl_Position = projectionMatrix * viewMatrix * worldPosition;

//     // Outputs mapped to match your fragment pipeline
//     vUv = uv;
//     vInstance = gl_InstanceID;
//     vNormals = normalize(normalMatrix * (billboardMatrix * normal));
//     vView = normalize(cameraPosition - worldPosition.xyz);
//     vPosWlrd = ( modelMatrix * instanceMatrix * vec4( 0.0, 0.0, 0.0, 1.0 ) ).xyz;
// }

uniform sampler2D uNoiseTexture;
uniform sampler2D uVelocityTexture;
uniform float uTime;

uniform vec2 uWindDirection;
uniform vec2 uVelocity;
uniform vec2 uSwayMultiplier;
uniform vec3 uGustModifiers;
uniform vec2 uGustBlend;
uniform vec2 uGustTurbulence;
uniform vec3 uTerrainWave;
uniform float uBendStiffness;
uniform float uTurbulenceOffset;
uniform float uWindMultiplier;
uniform float uWindOffset;
uniform float uLiftOffset;
uniform float uDomainOffset;
uniform mat2 uPrecalculatedRot;

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
    float time = uTime * 0.6;

    // -----------------------------
    // INSTANCE WORLD POSITION
    // -----------------------------
    vec3 instanceWorldPos = vec3(instanceMatrix[3]);

    // -----------------------------
    // CYLINDRICAL BILLBOARD (Y ONLY)
    // -----------------------------
    vec3 toCamera = cameraPosition - instanceWorldPos;
    toCamera.y = 0.0;
    toCamera = normalize(toCamera);

    vec3 up = vec3(0.0, 1.0, 0.0);
    vec3 right = normalize(cross(up, toCamera));
    vec3 forward = cross(right, up);

    mat3 billboardMatrix = mat3(right, up, forward);

    // -----------------------------
    // INSTANCE PHASE OFFSET
    // -----------------------------
    vec2 phase = vec2(
        fract(float(gl_InstanceID) * 0.37),
        fract(float(gl_InstanceID) * 0.73)
    );

    // -----------------------------
    // DYNAMIC BLADE HEIGHT
    // -----------------------------
    float localHeight = 0.6 * instanceMatrix[1][1];
    vec3 dynamicPositionOffset = vec3(1.0, localHeight, localHeight * 0.5);

    // -----------------------------
    // WORLD WIND SAMPLING UV
    // -----------------------------
    vec4 positionWorld = modelMatrix * instanceMatrix * vec4(position, 1.0);

    vec2 windUV = uvStretch(positionWorld.xz * 0.002, vec2(1.0, 4.6));

    // -----------------------------
    // WIND DEFORMATION (STAYS SAME)
    // -----------------------------
    vec3 windPosition = windDeform(
        windUV,
        uv,
        dynamicPositionOffset,
        uWindDirection,
        uVelocity,
        phase,
        uSwayMultiplier,
        uGustModifiers,
        uGustBlend,
        uGustTurbulence,
        uTerrainWave,
        uPrecalculatedRot,
        uBendStiffness,
        uTurbulenceOffset,
        time,
        uWindMultiplier,
        uWindOffset,
        uDomainOffset,
        uNoiseTexture,
        uVelocityTexture
    );

    // -----------------------------
    // LOCAL SPACE POSITION
    // -----------------------------
    vec3 localPos = position + windPosition;

    // -----------------------------
    // APPLY BILLBOARD FIRST
    // -----------------------------
    vec3 billboardPos = billboardMatrix * localPos;

    // -----------------------------
    // FINAL WORLD POSITION
    // -----------------------------
    vec3 worldPos = instanceWorldPos + billboardPos;

    gl_Position = projectionMatrix * viewMatrix * vec4(worldPos, 1.0);

    // -----------------------------
    // VARYINGS
    // -----------------------------
    vUv = uv;
    vInstance = gl_InstanceID;

    vNormals = normalize(normalMatrix * (billboardMatrix * normal));

    vView = normalize(cameraPosition - worldPos);

    vPosWlrd = worldPos;
}