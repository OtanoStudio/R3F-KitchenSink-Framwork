// Original Gemini

// import React, { useMemo, useRef, useEffect, useLayoutEffect } from 'react';
// import { useFrame } from '@react-three/fiber';
// import { useTexture } from '@react-three/drei';
// import * as THREE from 'three';

// // --- VERTEX SHADER ---
// const vertexShader = /*glsl*/`
// uniform float time;
// uniform sampler2D windNoiseMap;
// uniform sampler2D turbulenceMap;
// uniform vec3 windDirection;
// uniform float maxWindStrength;
// uniform float timeScale;
// uniform float turbStrength;
// uniform float turbFrequency;

// varying vec3 vNormal;
// varying vec2 vUv;
// varying vec3 vWorldPos;
// varying vec3 vViewDir;

// // --- Extracted Bézier Functions ---
// vec3 getCubicBezierPosition(vec3 p0, vec3 p1, vec3 p2, vec3 p3, float t) {
//     vec3 q0 = mix(p0, p1, t);
//     vec3 q1 = mix(p1, p2, t);
//     vec3 q2 = mix(p2, p3, t);
//     vec3 r0 = mix(q0, q1, t);
//     vec3 r1 = mix(q1, q2, t);
//     return mix(r0, r1, t);
// }

// vec3 getCubicBezierTangent(vec3 p0, vec3 p1, vec3 p2, vec3 p3, float t) {
//     vec3 q0 = mix(p0, p1, t);
//     vec3 q1 = mix(p1, p2, t);
//     vec3 q2 = mix(p2, p3, t);
//     vec3 r0 = mix(q0, q1, t);
//     vec3 r1 = mix(q1, q2, t);
//     return normalize(r1 - r0);
// }

// void main() {
//     vUv = uv;
//     // uv.y goes from 0 at the root to 1 at the tip
//     float t = uv.y; 

//     // 1. Extract world position of the blade's root from the instance matrix
//     mat4 instanceMat = instanceMatrix;
//     vec3 rootWorldPos = (modelMatrix * instanceMat * vec4(0.0, 0.0, 0.0, 1.0)).xyz;

//     // 2. Extract local rotation and scale
//     float scaleX = length(instanceMat[0].xyz);
//     float scaleY = length(instanceMat[1].xyz);
    
//     // Blade's facing direction
//     vec3 rightDir = normalize(instanceMat[0].xyz); 
    
//     // 3. Macro Wind (Broad Gusts)
//     vec2 macroUV = (rootWorldPos.xz * 0.05) - (windDirection.xz * time * timeScale);
//     float macroGust = texture2D(windNoiseMap, macroUV).r;
//     vec3 macroDisplacement = windDirection * macroGust * maxWindStrength;

//     // 4. Micro Wind (Erratic Turbulence)
//     vec2 turbUV = (rootWorldPos.xz * turbFrequency) - (windDirection.xz * time * timeScale * 2.5);
//     vec3 turbulenceDir = texture2D(turbulenceMap, turbUV).rgb * 2.0 - 1.0;
//     vec3 turbDisplacement = turbulenceDir * turbStrength * macroGust;

//     vec3 finalWindForce = macroDisplacement + turbDisplacement;

//     // 5. Define Bézier Control Points (in an un-rotated space aligned with World Up)
//     float bladeHeight = scaleY;
//     vec3 p0 = vec3(0.0, 0.0, 0.0);
//     vec3 p1 = vec3(0.0, bladeHeight * 0.333, 0.0);
//     vec3 p2 = vec3(finalWindForce.x * 0.5, bladeHeight * 0.666, finalWindForce.z * 0.5);
//     vec3 p3 = vec3(finalWindForce.x, bladeHeight, finalWindForce.z);

//     // Length Preservation
//     float currentLengthP3 = length(p3 - p0);
//     p3 = p0 + (p3 - p0) * (bladeHeight / currentLengthP3);
//     float currentLengthP2 = length(p2 - p0);
//     p2 = p0 + (p2 - p0) * ((bladeHeight * 0.666) / currentLengthP2);

//     // Evaluate curve
//     vec3 bezierPos = getCubicBezierPosition(p0, p1, p2, p3, t);
//     vec3 tangent   = getCubicBezierTangent(p0, p1, p2, p3, t);

//     // 6. Apply blade width offset (side-to-side)
//     vec3 widthOffset = rightDir * (position.x * scaleX);

//     // Final World Position
//     vec3 finalWorldPos = rootWorldPos + bezierPos + widthOffset;

//     // 7. Normal Reconstruction
//     vec3 up = vec3(0.0, 1.0, 0.0);

//     vec3 widthDir = normalize(cross(up, tangent));
//     vec3 newNormal = normalize(cross(tangent, widthDir));

//     vNormal = newNormal;
//     vWorldPos = finalWorldPos;
//     vViewDir = normalize( cameraPosition - finalWorldPos );

//     gl_Position = projectionMatrix * viewMatrix * vec4(finalWorldPos, 1.0);
// }
// `;

// // --- FRAGMENT SHADER ---
// const fragmentShader = /*glsl*/`
// uniform vec3 diffuseColor;
// uniform vec3 skyColor;
// uniform vec3 groundColor;
// uniform vec3 sunPosition;
// uniform vec3 tipColor;

// varying vec3 vNormal;
// varying vec2 vUv;
// varying vec3 vWorldPos;
// varying vec3 vViewDir;

// void main() {
//     vec3 normal = normalize(vNormal);

//     // 1. Hemisphere Lighting
//     float hemiMix = normal.y * 0.5 + 0.5;
//     vec3 hemiLight = mix( diffuseColor, tipColor, normal );

//     float colorDiffuseFactor = max( dot(normal, vec3( 0.0, 1.0, 0.0 ) ), 0.0 );
//     vec3 colorDiffuse = vec3( 1.0 ) * colorDiffuseFactor;
//     vec3 colorGrassBase = mix( diffuseColor, tipColor, smoothstep( 0.1, 1.0, vUv.y ) );


//     // Combine lighting with base color
//     vec3 finalColor = colorGrassBase * colorDiffuse;

//     gl_FragColor = vec4( finalColor, 1.0);
// }
// `;

// // --- MAIN COMPONENT ---
// export default function TerrainGrass({
//   bladeCount = 50000,
//   areaSize = 50,
//   grassTipColor = '#b8e100',
//   grassBaseColor = '#1b8188',
//   skyLightColor = '#ffffff',
//   groundLightColor = '#1d2a17',
//   sunPosition = [10, 20, 10],
//   macroNoisePath = './textures/noise/noisePerlinWind.webp',   // Pass your grayscale cloud noise here
//   turbulencePath = './textures/noise/noiseWindVelocity.webp',   // Pass your RGB cellular noise here
// }) {
//   const meshRef = useRef(null);
//   const materialRef = useRef(null);

//   // Load the textures using Drei's useTexture hook
//   const [windNoiseMap, turbulenceMap] = useTexture([macroNoisePath, turbulencePath]);

//   // Ensure textures wrap seamlessly for the scrolling UV math
//   useLayoutEffect(() => {
//     if (windNoiseMap) {
//       windNoiseMap.wrapS = windNoiseMap.wrapT = THREE.RepeatWrapping;
//       windNoiseMap.needsUpdate = true;
//     }
//     if (turbulenceMap) {
//       turbulenceMap.wrapS = turbulenceMap.wrapT = THREE.RepeatWrapping;
//       turbulenceMap.needsUpdate = true;
//     }
//   }, [windNoiseMap, turbulenceMap]);

//   // Initialize uniforms
//   const uniforms = useMemo(() => {
//     return {
//       time: { value: 0.0 },
//       windNoiseMap: { value: windNoiseMap },
//       turbulenceMap: { value: turbulenceMap },
//       windDirection: { value: new THREE.Vector3(1.0, 0.0, 1.0).normalize() },
//       maxWindStrength: { value: 0.6 },
//       timeScale: { value: 1.5 },
//       turbStrength: { value: 0.15 },
//       turbFrequency: { value: 1.2 },
//       tipColor: { value: new THREE.Color(grassTipColor)},
//       diffuseColor: { value: new THREE.Color(grassBaseColor) },
//       skyColor: { value: new THREE.Color(skyLightColor) },
//       groundColor: { value: new THREE.Color(groundLightColor) },
//       sunPosition: { value: new THREE.Vector3(...sunPosition) },
//     };
//   }, [windNoiseMap, turbulenceMap, grassBaseColor, skyLightColor, groundLightColor, sunPosition]);

//   // Generate Geometry (1x1 unit plane, segmented on Y axis for bending)
//   const geometry = useMemo(() => {
//     const geo = new THREE.PlaneGeometry(0.1, 1.0, 1, 4);
//     geo.translate(0, 0.5, 0); 
//     return geo;
//   }, []);

//   // Populate InstancedMesh
//   useEffect(() => {
//     if (!meshRef.current) return;
    
//     const dummy = new THREE.Object3D();

//     for (let i = 0; i < bladeCount; i++) {
//       const x = (Math.random() - 0.5) * areaSize;
//       const z = (Math.random() - 0.5) * areaSize;
//       dummy.position.set(x, 0, z);

//       dummy.rotation.y = Math.random() * Math.PI * 2;

//       const height = 0.5 + Math.random() * 0.8;
//       const width = 0.8 + Math.random() * 0.4;
//       dummy.scale.set(width, height, 1);

//       dummy.updateMatrix();
//       meshRef.current.setMatrixAt(i, dummy.matrix);
//     }
//     meshRef.current.instanceMatrix.needsUpdate = true;
//   }, [bladeCount, areaSize]);

//   // Animation Loop
//   useFrame((state) => {
//     if (materialRef.current) {
//       materialRef.current.uniforms.time.value = state.clock.elapsedTime;
//     }
//   });

//   return (
//     <instancedMesh
//       ref={meshRef}
//       args={[geometry, null, bladeCount]}
//       frustumCulled={false}
//     >
//       <shaderMaterial
//         ref={materialRef}
//         attach="material"
//         name="TerrainGrassMaterial"
//         vertexShader={vertexShader}
//         fragmentShader={fragmentShader}
//         uniforms={uniforms}
//         side={THREE.DoubleSide}
//       />
//     </instancedMesh>
//   );
// }

// Chatgpt improvements



//Gemini fix latest 05/27/2026

import React, { useMemo, useRef, useEffect, useLayoutEffect } from 'react';
import { useFrame } from '@react-three/fiber';
import { useTexture } from '@react-three/drei';
import * as THREE from 'three';

// --- VERTEX SHADER ---
const vertexShader = /*glsl*/`
uniform float time;
uniform sampler2D windNoiseMap;
uniform sampler2D turbulenceMap;
uniform vec3 windDirection;
uniform float maxWindStrength;
uniform float timeScale;
uniform float turbStrength;
uniform float turbFrequency;

varying vec3 vNormal;
varying vec2 vUv;
varying vec3 vWorldPos;
varying vec3 vViewDir;
flat varying int vInstance;

vec3 getCubicBezierPosition(vec3 p0, vec3 p1, vec3 p2, vec3 p3, float t) {
    vec3 q0 = mix(p0, p1, t);
    vec3 q1 = mix(p1, p2, t);
    vec3 q2 = mix(p2, p3, t);
    vec3 r0 = mix(q0, q1, t);
    vec3 r1 = mix(q1, q2, t);
    return mix(r0, r1, t);
}

vec3 getCubicBezierTangent(vec3 p0, vec3 p1, vec3 p2, vec3 p3, float t) {
    vec3 q0 = mix(p0, p1, t);
    vec3 q1 = mix(p1, p2, t);
    vec3 q2 = mix(p2, p3, t);
    vec3 r0 = mix(q0, q1, t);
    vec3 r1 = mix(q1, q2, t);
    return normalize(r1 - r0);
}

void main() {
    vUv = uv;
    float t = uv.y; 

    // 1. Calculate full world matrix for this specific instance
    mat4 worldMat = modelMatrix * instanceMatrix;
    
    // 2. Extract accurate world position and rotated axes
    vec3 rootWorldPos = (worldMat * vec4(0.0, 0.0, 0.0, 1.0)).xyz;
    vec3 rightDir = normalize(worldMat[0].xyz); 
    vec3 upDir = normalize(worldMat[1].xyz); 
    
    float scaleX = length(worldMat[0].xyz);
    float scaleY = length(worldMat[1].xyz);
    
    // 3. Macro Wind (Broad Gusts)
    vec2 macroUV = (rootWorldPos.xz * 0.05) - (windDirection.xz * time * timeScale);
    float macroGust = texture2D(windNoiseMap, macroUV).r;
    vec3 macroDisplacement = windDirection * macroGust * maxWindStrength;

    // 4. Micro Wind (Erratic Turbulence)
    vec2 turbUV = (rootWorldPos.xz * turbFrequency) - (windDirection.xz * time * timeScale * 2.5);
    vec3 turbulenceDir = texture2D(turbulenceMap, turbUV).rgb * 2.0 - 1.0;
    vec3 turbDisplacement = turbulenceDir * turbStrength * macroGust;

    vec3 finalWindForce = macroDisplacement + turbDisplacement;

    // 5. Define Bézier Control Points along the local rotated UP vector
    float bladeHeight = scaleY;
    vec3 p0 = vec3(0.0, 0.0, 0.0);
    vec3 p1 = upDir * (bladeHeight * 0.333);
    vec3 p2 = (upDir * (bladeHeight * 0.666)) + (finalWindForce * 0.5);
    vec3 p3 = (upDir * bladeHeight) + finalWindForce;

    // Length Preservation
    float currentLengthP3 = length(p3 - p0);
    p3 = p0 + (p3 - p0) * (bladeHeight / currentLengthP3);
    
    float currentLengthP2 = length(p2 - p0);
    p2 = p0 + (p2 - p0) * ((bladeHeight * 0.666) / currentLengthP2);

    // Evaluate curve
    vec3 bezierPos = getCubicBezierPosition(p0, p1, p2, p3, t);
    vec3 tangent   = getCubicBezierTangent(p0, p1, p2, p3, t);

    // 6. Apply blade width offset (side-to-side)
    vec3 widthOffset = rightDir * (position.x * scaleX);

    // Final World Position
    vec3 finalWorldPos = rootWorldPos + bezierPos + widthOffset;

    // 7. Normal Reconstruction
    // Cross product of the local right direction and the bent curve tangent
    vec3 newNormal = normalize(cross(rightDir, tangent));

    vNormal = newNormal;
    vWorldPos = finalWorldPos;
    vViewDir = cameraPosition - finalWorldPos;
    vInstance = gl_InstanceID;

    gl_Position = projectionMatrix * viewMatrix * vec4(finalWorldPos, 1.0);
}
`;

// --- FRAGMENT SHADER ---
const fragmentShader = /*glsl*/`
uniform vec3 diffuseColor;
uniform vec3 skyColor;
uniform vec3 groundColor;
uniform vec3 sunPosition;
uniform sampler2D grassColorTexture;
uniform sampler2D grassShapeAtlas;
uniform float translucenyStrength;
uniform float translucenyDistortion;
uniform vec3 translucentColor;

varying vec3 vNormal;
varying vec2 vUv;
varying vec3 vWorldPos;
varying vec3 vViewDir;
flat varying int vInstance;

vec2 uvGetRandomSprite(
    vec2 uv,
    int index,
    ivec2 size
)
{

    int count = size.x * size.y;
    int i = index % count;

    float x = float( i % size.x );
    float y = float( i / size.y );

    vec2 atlasSize = 1.0 / vec2( float( size.x ), float( size.y ) );

    return uv * atlasSize + ( vec2( x, y ) * atlasSize );

}

float translucency( 
    vec3 lightDir, 
    vec3 viewDir, 
    vec3 normal, 
    float distortion, 
    float power )
{

    lightDir = normalize(lightDir);
    viewDir = normalize(viewDir);
    normal = normalize(normal);

    vec3 distortedLight = normalize(lightDir + normal * distortion);

    float transDot = max(dot(viewDir, -distortedLight), 0.0);

    return pow(transDot, power);

}


void main() 
{
    vec2 uv = vUv;
    vec3 normal = normalize(vNormal);
    vec2 uv2 = uv;
    uv2.y = clamp( uv.y, 0.005, 0.995 );
    float translucent = translucency( sunPosition, vViewDir, normal, translucenyDistortion, translucenyStrength );
    vec2 spriteUV = uvGetRandomSprite( uv2, vInstance, ivec2( 2, 2 ) );
    float grassAtlas = texture( grassShapeAtlas, spriteUV ).r;

    // FIX: Properly invert normals for the backside of the plane so it shades correctly
    if (!gl_FrontFacing) {
        normal = -normal;
    }

    // 1. Hemisphere Lighting
    float hemiMix = normal.y * 0.5 + 0.5;
    vec3 hemiLight = mix(groundColor, skyColor * 1.2, hemiMix);
    float thicknessMask = smoothstep(0.2, 0.8, uv.y); 
    vec3 colorSubSurface = translucentColor * translucent * thicknessMask;

    // 2. Lambert Diffuse Lighting
    vec3 sunDir = normalize(sunPosition);
    float nDotL = max(dot(normal, sunDir) * 0.8 + 0.2, 0.0); 
    vec3 sunColor = vec3(1.0, 0.95, 0.9);
    vec3 lambertLight = sunColor * nDotL;
    vec3 colorBase = texture( grassColorTexture, vec2( smoothstep( 0.1, 0.8, uv.y ) ) ).rgb;

    // 3. Ambient Occlusion
    float ao = smoothstep(0.0, 0.3, uv.y); 

    vec3 finalColor = colorBase * (hemiLight + lambertLight) * ao;

    if( grassAtlas < 0.5 ) discard;

    gl_FragColor = vec4( finalColor + colorSubSurface, grassAtlas);
}
`;

// --- MAIN COMPONENT ---
export default function TerrainGrass({
  bladeCount = 20000,
  areaSize = 12,
  grassBaseColor = '#1b8188',
  skyLightColor = '#ffffff',
  groundLightColor = '#414141',
  translucenyColor = '#faff6b',
  sunPosition = [10, 20, 10],
  translucenyDist = 0.45,
  translucenyPow = 4.0,
  macroNoisePath = './textures/noise/noisePerlinWind.webp',
  turbulencePath = './textures/noise/noiseWindVelocity.webp',
  grassTiles = './textures/tiles/grass/grassSingleStrands.webp',
  grassGradient = './textures/gradientmaps/grassocean.webp'
}) {
  const meshRef = useRef(null);
  const materialRef = useRef(null);

  const [windNoiseMap, turbulenceMap, grassAtlas, grassColorGradient] = useTexture([macroNoisePath, turbulencePath, grassTiles, grassGradient]);

    windNoiseMap.wrapS = windNoiseMap.wrapT = THREE.RepeatWrapping;

    turbulenceMap.wrapS = turbulenceMap.wrapT = THREE.RepeatWrapping;
    

    grassAtlas.wrapS = grassAtlas.wrapT = THREE.ClampToEdgeWrapping;
  

     grassColorGradient.colorSpace = THREE.SRGBColorSpace;
 

  const uniforms = useMemo(() => {
    return {
      time: { value: 0.0 },
      windNoiseMap: { value: windNoiseMap },
      turbulenceMap: { value: turbulenceMap },
      grassShapeAtlas: { value: grassAtlas },
      windDirection: { value: new THREE.Vector3(1.0, 0.0, 1.0).normalize() },
      maxWindStrength: { value: 0.8 },
      timeScale: { value: 0.32 },
      turbStrength: { value: 0.07 },
      turbFrequency: { value: 1.3 },
      translucenyDistortion: { value: translucenyDist},
      translucenyStrength: { value: translucenyPow },
      translucentColor: { value: new THREE.Color( translucenyColor )},
      grassColorTexture : { value: grassColorGradient },
      diffuseColor: { value: new THREE.Color(grassBaseColor) },
      skyColor: { value: new THREE.Color(skyLightColor) },
      groundColor: { value: new THREE.Color(groundLightColor) },
      sunPosition: { value: new THREE.Vector3(...sunPosition) },
    };
  }, [windNoiseMap, turbulenceMap, grassBaseColor, skyLightColor, groundLightColor, sunPosition]);

  const geometry = useMemo(() => {
    const geo = new THREE.PlaneGeometry(0.1, 1.0, 1, 4);
    geo.translate(0, 0.5, 0); 
    return geo;
  }, []);

  useEffect(() => {
    if (!meshRef.current) return;
    
    const dummy = new THREE.Object3D();

    for (let i = 0; i < bladeCount; i++) {
      const x = (Math.random() - 0.5) * areaSize;
      const z = (Math.random() - 0.5) * areaSize;
      dummy.position.set(x, 0, z);
      dummy.rotation.y = Math.random() * Math.PI * 2;

      const height = 0.5 + Math.random() * 0.8;
      const width = 0.8 + Math.random() * 0.4;
      dummy.scale.set(width, height, 1);

      dummy.updateMatrix();
      meshRef.current.setMatrixAt(i, dummy.matrix);
    }
    meshRef.current.instanceMatrix.needsUpdate = true;
  }, [bladeCount, areaSize]);

  useFrame((state) => {
    if (materialRef.current) {
      materialRef.current.uniforms.time.value = state.clock.elapsedTime;
    }
  });

  return (
    <instancedMesh
      ref={meshRef}
      args={[geometry, null, bladeCount]}
      frustumCulled={false}
    >
      <shaderMaterial
        ref={materialRef}
        attach="material"
        name="TerrainGrassMaterial"
        vertexShader={vertexShader}
        fragmentShader={fragmentShader}
        uniforms={uniforms}
        side={THREE.DoubleSide}
        transparent={ true }
      />
    </instancedMesh>
  );
}