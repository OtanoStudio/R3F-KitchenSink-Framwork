// import { useRef, useMemo } from 'react';
// import { useFrame } from '@react-three/fiber';
// import * as THREE from 'three';

// export default function DigitalTrianglePortal() {
//   const meshRef = useRef();
//   const materialRef = useRef();

//   const uniforms = useMemo(() => ({
//     uTime: { value: 0 },
//     uSpeed: { value: 0.4 },
//     uParticleCount: { value: 80 },
//     uParticleSize: { value: 0.05 }
//   }), []);

//   useFrame((state, delta) => {
//     if (materialRef.current) {
//       materialRef.current.uniforms.uTime.value += delta;
//     }
//   });

//   const vertexShader = `
//     varying vec2 vUv;
//     void main() {
//       vUv = uv;
//       gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
//     }
//   `;

//   const fragmentShader = `
//     uniform float uTime;
//     uniform float uSpeed;
//     uniform float uParticleCount;
//     uniform float uParticleSize;
    
//     varying vec2 vUv;
    
//     // Hash function for randomness
//     float hash(vec2 p) {
//       return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
//     }
    
//     // SDF for square
//     float sdSquare(vec2 p, float size) {
//       vec2 d = abs(p) - size;
//       return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
//     }
    
//     void main() {
//       vec2 uv = vUv;
//       vec2 center = vec2(0.5);
      
//       float finalShape = 0.0;
//       vec3 finalColor = vec3(0.0);
      
//       int count = int(uParticleCount);
      
//       // Loop through all particles
//       for (int i = 0; i < 200; i++) {
//         if (i >= count) break;
        
//         float seed = float(i);
        
//         // Generate random starting position for this particle
//         vec2 randomPos = vec2(
//           hash(vec2(seed, 0.0)),
//           hash(vec2(seed, 1.0))
//         );
        
//         // Direction and distance from particle start to center
//         vec2 toCenter = center - randomPos;
//         float distToCenter = length(toCenter);
//         vec2 dirToCenter = normalize(toCenter);
        
//         // Staggered animation based on distance
//         float delay = distToCenter * 2.0;
//         float t = clamp((uTime * uSpeed - delay), 0.0, 1.0);
//         t = smoothstep(0.0, 1.0, t);
        
//         // Current position (moving toward center)
//         vec2 currentPos = randomPos + dirToCenter * distToCenter * t;
        
//         // Vector from pixel to particle
//         vec2 toParticle = uv - currentPos;
        
//         // Scale shrinks as it moves
//         float scale = mix(1.0, 0.01, t);
//         vec2 p = toParticle / scale;
        
//         // Draw square
//         float d = sdSquare(p, uParticleSize);
//         float square = smoothstep(0.001, -0.001, d);
        
//         // Fade out near the end
//         float fadeOut = 1.0 - smoothstep(0.85, 1.0, t);
//         square *= fadeOut;
        
//         // Random color variation per particle
//         float colorVar = hash(vec2(seed, 2.0));
//         vec3 color = mix(
//           vec3(0.2, 0.8, 1.0),
//           vec3(0.4, 0.9, 1.0),
//           colorVar
//         );
        
//         // Accumulate
//         finalColor += color * square;
//         finalShape = max(finalShape, square);
//       }
      
//       gl_FragColor = vec4(finalColor, finalShape);
//     }
//   `;

//   return (
//     <mesh ref={meshRef}>
//       <planeGeometry args={[4, 4]} />
//       <shaderMaterial
//         ref={materialRef}
//         uniforms={uniforms}
//         vertexShader={vertexShader}
//         fragmentShader={fragmentShader}
//         transparent={true}
//         depthWrite={false}
//       />
//     </mesh>
//   );
// }

// import { useRef, useMemo } from 'react';
// import { useFrame } from '@react-three/fiber';
// import * as THREE from 'three';

// export default function DigitalTrianglePortal() {
//   const meshRef = useRef();
//   const materialRef = useRef();

//   const uniforms = useMemo(() => ({
//     uTime: { value: 0 },
//     // Layer 1 - small squares
//     uGridSize1: { value: 25 },
//     uDensity1: { value: 0.5 },
//     uSpeed1: { value: 0.3 },
//     uSize1: { value: 0.3 },
//     uPullStrength1: { value: 0.4 },
//     // Layer 2 - medium squares
//     uGridSize2: { value: 15 },
//     uDensity2: { value: 0.3 },
//     uSpeed2: { value: 0.5 },
//     uSize2: { value: 0.4 },
//     uPullStrength2: { value: 0.5 },
//     // Layer 3 - large squares
//     uGridSize3: { value: 10 },
//     uDensity3: { value: 0.4 },
//     uSpeed3: { value: 0.2 },
//     uSize3: { value: 0.35 },
//     uPullStrength3: { value: 0.3 },
//     // Layer 4 - extra small squares
//     uGridSize4: { value: 30 },
//     uDensity4: { value: 0.35 },
//     uSpeed4: { value: 0.4 },
//     uSize4: { value: 0.25 },
//     uPullStrength4: { value: 0.45 }
//   }), []);

//   useFrame((state, delta) => {
//     if (materialRef.current) {
//       materialRef.current.uniforms.uTime.value += delta;
//     }
//   });

//   const vertexShader = `
//     varying vec2 vUv;
//     void main() {
//       vUv = uv;
//       gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
//     }
//   `;

//   const fragmentShader = `
//     uniform float uTime;
//     uniform float uGridSize1;
//     uniform float uDensity1;
//     uniform float uSpeed1;
//     uniform float uSize1;
//     uniform float uPullStrength1;
//     uniform float uGridSize2;
//     uniform float uDensity2;
//     uniform float uSpeed2;
//     uniform float uSize2;
//     uniform float uPullStrength2;
//     uniform float uGridSize3;
//     uniform float uDensity3;
//     uniform float uSpeed3;
//     uniform float uSize3;
//     uniform float uPullStrength3;
//     uniform float uGridSize4;
//     uniform float uDensity4;
//     uniform float uSpeed4;
//     uniform float uSize4;
//     uniform float uPullStrength4;
    
//     varying vec2 vUv;
    
//     // Hash function for randomness
//     float hash(vec2 p) {
//       return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
//     }
    
//     // Hash with seed offset
//     float hash(vec2 p, float seed) {
//       return fract(sin(dot(p, vec2(127.1, 311.7)) + seed) * 43758.5453);
//     }
    
//     // SDF for square
//     float sdSquare(vec2 p, float size) {
//       vec2 d = abs(p) - size;
//       return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
//     }
    
//     // Function to draw a layer by pulling UV space first
//     float drawLayer(vec2 uv, float gridSize, float speed, float density, float size, float pullStrength, float seed) {
//       vec2 center = vec2(0.5);
      
//       // Calculate distance and direction to center
//       vec2 toCenter = center - uv;
//       float distToCenter = length(toCenter);
//       vec2 dirToCenter = normalize(toCenter);
      
//       // Animation based on distance from edge (wave starts from edges)
//       float edgeDist = min(min(uv.x, 1.0 - uv.x), min(uv.y, 1.0 - uv.y));
//       float t = clamp((uTime * speed - (1.0 - edgeDist)), 0.0, 1.0);
//       t = smoothstep(0.0, 1.0, t);
      
//       // Pull UV space toward center BEFORE creating grid
//       vec2 pulledUV = uv + dirToCenter * distToCenter * t * pullStrength;
      
//       // NOW create the grid on pulled UV space
//       vec2 gridUV = pulledUV * gridSize;
//       vec2 cellID = floor(gridUV);
//       vec2 cellUV = fract(gridUV);
      
//       // Transform to centered coordinates
//       vec2 p = cellUV - 0.5;
      
//       // Scale down as it moves
//       float scale = mix(1.0, 0.01, t);
//       p /= scale;
      
//       // Draw square
//       float d = sdSquare(p, size);
//       float square = smoothstep(0.02, -0.02, d);
      
//       // Random density with unique seed per layer
//       float random = hash(cellID, seed);
//       float shouldShow = step(random, density);
//       square *= shouldShow;
      
//       // Fade out at the end
//       float fadeOut = 1.0 - smoothstep(0.85, 1.0, t);
//       square *= fadeOut;
      
//       return square;
//     }
    
//     void main() {
//       vec2 uv = vUv;
      
//       // Draw all 4 layers with independent parameters
//       float layer1 = drawLayer(uv, uGridSize1, uSpeed1, uDensity1, uSize1, uPullStrength1, 0.0);
//       float layer2 = drawLayer(uv, uGridSize2, uSpeed2, uDensity2, uSize2, uPullStrength2, 100.0);
//       float layer3 = drawLayer(uv, uGridSize3, uSpeed3, uDensity3, uSize3, uPullStrength3, 200.0);
//       float layer4 = drawLayer(uv, uGridSize4, uSpeed4, uDensity4, uSize4, uPullStrength4, 300.0);
      
//       // Combine layers
//       float combined = max(max(max(layer1, layer2), layer3), layer4);
      
//       // Different colors per layer for visual variety
//       vec3 color1 = vec3(0.2, 0.8, 1.0);
//       vec3 color2 = vec3(0.4, 0.6, 1.0);
//       vec3 color3 = vec3(0.1, 0.9, 0.9);
//       vec3 color4 = vec3(0.3, 0.7, 1.0);
      
//       vec3 finalColor = color1 * layer1 + color2 * layer2 + color3 * layer3 + color4 * layer4;
      
//       gl_FragColor = vec4(finalColor, combined);
//     }
//   `;

//   return (
//     <mesh ref={meshRef}>
//       <planeGeometry args={[4, 4]} />
//       <shaderMaterial
//         ref={materialRef}
//         uniforms={uniforms}
//         vertexShader={vertexShader}
//         fragmentShader={fragmentShader}
//         transparent={true}
//         depthWrite={false}
//       />
//     </mesh>
//   );
// }

import { useTexture } from "@react-three/drei";
import { useFrame } from "@react-three/fiber";
import { useRef } from "react"
import { AdditiveBlending, MirroredRepeatWrapping, RepeatWrapping, Vector3 } from "three";

export default function DigitalTrianglePortal({
  texture = './textures/logo/squares.webp',
  outlines = './textures/logo/squarelines.webp',
  nnoise = './textures/noise/noiseWavey.png',
  nnnoise = './textures/noise/noiseValue.png',
  layerSpeed = new Vector3( 0.2, 0.2, 0.1 ),
  layerDelay = new Vector3( 0, 0.3, 0.8 ),
  ...props
})
{

  const self = useRef();

  const squares = useTexture( texture );
  squares.wrapS = MirroredRepeatWrapping;
  squares.wrapT = MirroredRepeatWrapping;

  const sqrOutlines = useTexture( outlines );
  sqrOutlines.wrapS = MirroredRepeatWrapping;
  sqrOutlines.wrapT = MirroredRepeatWrapping;

  const noiset = useTexture( nnoise );
  noiset.wrapS = RepeatWrapping;
  noiset.wrapT = RepeatWrapping;

  const n = useTexture( nnnoise );
  n.wrapS = RepeatWrapping;
  n.wrapT = RepeatWrapping;

  const spd = ( layerSpeed  instanceof Vector3 ) ? layerSpeed : new Vector3( 0.4, 0.3, 0.2 );
  const delay = ( layerDelay instanceof Vector3 ) ? layerDelay : new Vector3( 0, 0.2, 0.4 );

  const uniforms = useRef({
    uTime: { value:  0 },
    uTexture: { value: squares },
    uOutlines: { value: sqrOutlines },
    uNoise: { value: noiset },
    uSpeed: { value: spd },
    uDelay: { value: delay },
    uNoise2: { value: n },
  })

  const vertex = /*glsl*/`
  varying vec2 vUv;

  void main()
  {
    gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
    vUv = uv;
  }
  `;

  const fragment = /*glsl*/`
  uniform sampler2D uTexture;
  uniform sampler2D uOutlines;
  uniform float uTime;
  uniform vec3 uSpeed;
  uniform vec3 uDelay;
  uniform sampler2D uNoise;
  uniform sampler2D uNoise2;

  varying vec2 vUv;

  vec2 uvScaled( vec2 uv, float time )
  {
    float scale = exp(mix(log(0.5), log(1.0), time));
    vec2 uvScale = fract((uv - 0.5) * scale + 0.5);
    return uvScale;
  }
  

  float normalizedDuration( 
    float time, 
    float delay,
    float duration 
)
{

    return mod( time + delay, duration ) / duration;

}

  vec2 uvPolar(vec2 uv) 
{
    float pi = 3.1415926;
    float pi2 = 6.2831853;

    vec2 uvCentered = uv - 0.5;
    float radius = length(uvCentered);
    float angle = ( atan(uvCentered.y, uvCentered.x) + pi ) / pi2;

    vec2 polarUV = vec2( radius, angle );

    return polarUV;

}

  void main() 
  {
    vec2 uv = vUv;
    float time = uTime;

    vec2 uvPolarCoords = uvPolar( uv );

    float noiseUv = texture( uNoise2, uvPolarCoords + time * 0.1 ).r;

    float noise = texture( uNoise, uvPolarCoords + noiseUv ).r;

    float planeCenter = distance( uv, vec2( 0.5 ) );
    float centerMask = smoothstep(0.34, 1.0, planeCenter );
    float midMask = smoothstep( 0.1, 0.4, planeCenter );

    noise *= midMask;

    float t1 = fract( time * uSpeed.r + uDelay.r );
    float t2 = fract( time * uSpeed.g + uDelay.g );
    float t3 = fract( time * uSpeed.b + uDelay.b );

    // --- sample texture and outlines ---
    float squares1 = texture(uTexture, uvScaled(uv, t1)).r;
    float outlines1 = texture(uOutlines, uvScaled(uv, t1)).r;

    float squares2 = texture(uTexture, uvScaled(uv, t2)).r;
    float outlines2 = texture(uOutlines, uvScaled(uv, t2)).r;

    float squares3 = texture(uTexture, uvScaled(uv, t3)).r;
    float outlines3 = texture(uOutlines, uvScaled(uv, t3)).r;

    // --- layer colors (Option B: cyberpunk purple/pink) ---
    vec3 sqrColor1 = vec3(1.0, 0.4, 1.0);  // #ff66ff
    vec3 sqrColor2 = vec3(1.0, 0.6, 1.0);  // #ff99ff
    vec3 sqrColor3 = vec3(1.0, 0.2, 1.0);  // #ff33ff

    vec3 outlineColor1 = vec3(0.8, 0.0, 1.0); // #cc00ff
    vec3 outlineColor2 = vec3(0.6, 0.0, 0.8); // #9900cc
    vec3 outlineColor3 = vec3(0.4, 0.0, 0.6); // #660099
    vec3 portalColor = mix( sqrColor3, outlineColor3, 0.5 ) * pow(noise, 2.3);
    portalColor *= 2.2;

    // --- combine layers ---
    vec3 colorSquares = squares1 * sqrColor1 + squares2 * sqrColor2 + squares3 * sqrColor3;
    vec3 colorOutlines = outlines1 * outlineColor1 + outlines2 * outlineColor2 + outlines3 * outlineColor3;

    // --- final color mixing ---
    vec3 colorSq = mix(colorSquares, colorOutlines, outlines1 + outlines2 + outlines3);
    vec3 colorFinal = portalColor;

    

    // --- alpha ---
    float alpha = squares1 + squares2 + squares3;

    
    alpha *= centerMask;

    colorFinal = mix( colorFinal, colorSq, alpha );

    gl_FragColor = vec4(colorFinal, 1.0);
    //gl_FragColor = vec4( vec3( midMask ), 1.0 );

    #include <tonemapping_fragment>
    #include <colorspace_fragment>

  }
  `;

  useFrame( ( state, delta ) =>
  {
    uniforms.current.uTime.value += delta;
  })

  return(
    <mesh ref={ self } {...props}>
      <planeGeometry args={[ 4, 4 ]}/>
      <shaderMaterial
        uniforms={ uniforms.current }
        vertexShader={ vertex }
        fragmentShader={ fragment }
        transparent={ true }
        blending={ AdditiveBlending }
        toneMapped={ false }
      />
    </mesh>
  )

}