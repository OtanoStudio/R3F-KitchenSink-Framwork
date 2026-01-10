import * as THREE from "three";
import { useRef } from "react";
import { extend, useFrame } from "@react-three/fiber";
import { shaderMaterial } from "@react-three/drei";

/* =========================
   SHADERS
========================= */

const vertexShader = `
varying vec2 vUv;

void main() {
  vUv = uv;
  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}
`;

const fragmentShader = `
uniform float uTime;
uniform float uDuration;
uniform float uDurationJitter;
uniform float uIntensity;
uniform float uColumns;
uniform float uGap;
uniform vec3 uColor;

varying vec2 vUv;

float TAU = 6.28318530718;

float columnRand(float i) {
  return fract(sin(i * 12.9898) * 43758.5453);
}

float pulse(float t, float phase) {
  return 0.5 + 0.5 * sin(TAU * (t + phase));
}

void main() {
  vec2 uv = vUv;

  /* base normalized time */
  float baseT = uTime / uDuration;

  /* grid */
  vec2 gridUV = uv * vec2(uColumns, 1.0);
  vec2 cellUV = fract(gridUV);
  float colIndex = floor(gridUV.x);

  /* hard column edges */
  float colMask =
    step(uGap, cellUV.x) *
    step(cellUV.x, 1.0 - uGap);

  /* per-column randomness */
  float phase = columnRand(colIndex);

  /* per-column duration offset */
  float speed = mix(
    1.0 - uDurationJitter,
    1.0 + uDurationJitter,
    phase
  );

  float t = fract(baseT * speed);

  /* height animation */
  float baseHeight = 0.6;
  float heightAmp  = 0.4;
  float height = baseHeight + pulse(t, phase) * heightAmp;

  /* variable but guaranteed gradient */
  float gradSeed   = 0.35 + 0.65 * phase;
  float gradHeight = mix(0.12, 0.3, gradSeed);

  /* vertical mask */
  float heightMask =
    smoothstep(0.0, height, uv.y) *
    smoothstep(height, height - gradHeight, uv.y);

  float mask = colMask * heightMask;

  float fade = smoothstep(0.0, 1.0, uv.y);
  vec3 color = uColor * mask * fade * uIntensity;

  gl_FragColor = vec4(color, mask);
}
`;

/* =========================
   MATERIAL
========================= */

const GridColumnsMaterial = shaderMaterial(
  {
    uTime: 0,
    uDuration: 4.0,
    uDurationJitter: 0.25,
    uIntensity: 3.0,
    uColumns: 6.0,
    uGap: 0.25,
    uColor: new THREE.Color("#00eaff"),
  },
  vertexShader,
  fragmentShader
);

extend({ GridColumnsMaterial });

/* =========================
   COMPONENT
========================= */

export default function GridLightColumns({
  columns = 6,
  gap = 0.25,
  duration = 4,
  intensity = 3,
  color = "#00eaff",
  scale = 1,
  size = [3,5]
}) {
  const mat = useRef();

  size = ( Array.isArray( size ) ) ? size : [3, 5 ];

  useFrame((_, delta) => {
    mat.current.uTime += delta;
  });

  return (
    <mesh scale={scale}>
      <planeGeometry args={size} />
      <gridColumnsMaterial
        ref={mat}
        uColumns={columns}
        uGap={gap}
        uDuration={duration}
        uIntensity={intensity}
        uColor={new THREE.Color(color)}
        transparent
        blending={THREE.AdditiveBlending}
        depthWrite={false}
      />
    </mesh>
  );
}
