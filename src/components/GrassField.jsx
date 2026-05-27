// import { useRef, useMemo, useEffect } from "react"
// import { Object3D, InstancedBufferAttribute, MathUtils } from "three"
// import GrassMaterial from "../materials/GrassMaterial.jsx"

// export default function GrassField({
//   count = 2000,
//   area = 12
// }) {
//   const meshRef = useRef()
//   const dummy = useMemo(() => new Object3D(), [])

//   useEffect(() => {
//     if (!meshRef.current) return

//     for (let i = 0; i < count; i++) {
//       const x = MathUtils.randFloatSpread(area)
//       const z = MathUtils.randFloatSpread(area)

//       dummy.position.set(x, 0, z)

//       // random scale variation
//       const scale = 1.0
//       dummy.scale.set(scale, scale, scale)

//       dummy.updateMatrix()
//       meshRef.current.setMatrixAt(i, dummy.matrix)
//     }

//     meshRef.current.instanceMatrix.needsUpdate = true


//   }, [count, area, dummy])

//   return (
//     <instancedMesh ref={meshRef} args={[undefined, undefined, count]}>
//       <planeGeometry args={[0.6, 0.6, 1, 5]} />
//       <GrassMaterial />
//     </instancedMesh>
//   )
// }


/// gemini tests

// import { useRef, useMemo, useEffect } from "react"
// import { Object3D, MathUtils, Vector2, Vector3, Matrix2 } from "three"
// import { useFrame } from "@react-three/fiber"
// import { useControls, folder } from "leva"
// import GrassMaterial from "../materials/GrassMaterial.jsx"

// export default function GrassField({
//   count = 3000,
//   area = 12
// }) {
//   const meshRef = useRef()
//   const materialRef = useRef()
//   const dummy = useMemo(() => new Object3D(), [])

//   // Leva controls configured for baseline vs periodic wind bursts
//   const config = useControls("Grass Wind Engine", {
//     Wind_Core: folder({
//   windDirection: { value: [1.0, 0.35], step: 0.05 },
//   velocity: { value: [0.25, 0.05], step: 0.01 },       // Raised: x moves the wave, keeping y low prevents micro-shaking
//   windMultiplier: { value: 1.5, min: 0, max: 5, step: 0.1 }, // Raised: Gives the overall movement more physical range
//   windOffset: { value: 0.5, min: 0, max: 3, step: 0.05 },
//   domainOffset: { value: 0.45, min: 0, max: 3, step: 0.05 },
//   windRotation: { value: 45, min: 0, max: 360, step: 1 }, 
// }),
// Sway_Settings: folder({
//   swayMultiplier: { value: [1.2, 0.4], step: 0.05 },    // Raised: Increases the mechanical leaning distance
//   bendStiffness: { value: 2.5, min: 1.0, max: 6.0, step: 0.1 }, // Lowered: Makes the blades more pliable/responsive
// }),
// Periodic_Gusts: folder({
//   gustModifiers: { value: [0.4, 0.5, 2.0], step: 0.05 },
//   gustBlend: { value: [0.3, 1.8], step: 0.05 },        // Adds a healthy mix of constant wave + occasional push
//   gustTurbulence: { value: [0.5, 0.2], step: 0.05 },
// }),
// Terrain_Waves: folder({
//   terrainWave: { value: [0.15, 0.3, 0.2], step: 0.01 },
// })
//   })

//   // Population loop for instanced positioning and variations
//   useEffect(() => {
//     if (!meshRef.current) return

//     for (let i = 0; i < count; i++) {
//       const x = MathUtils.randFloatSpread(area)
//       const z = MathUtils.randFloatSpread(area)

//       dummy.position.set(x, 0, z)

//       const scale = MathUtils.randFloat(0.6, 1.4)
//       dummy.scale.set(scale, scale, scale)
      
//       dummy.rotation.y = MathUtils.randFloat(0, Math.PI * 2)

//       dummy.updateMatrix()
//       meshRef.current.setMatrixAt(i, dummy.matrix)
//     }

//     meshRef.current.instanceMatrix.needsUpdate = true
//   }, [count, area, dummy])

//   // Uniform pipeline streaming calculations straight to the GPU program
//   useFrame((state) => {
//     if (!materialRef.current) return

//     const matUniforms = materialRef.current.uniforms

//     matUniforms.uTime.value = state.clock.getElapsedTime()

//     // PRECALCULATE ROTATION MATRIX: Drop per-vertex sin/cos logic
//     const rad = (config.windRotation * Math.PI) / 180
//     matUniforms.uPrecalculatedRot.value.set(
//       Math.cos(rad), -Math.sin(rad),
//       Math.sin(rad),  Math.cos(rad)
//     )

//     // Sync all parameters reactively
//     matUniforms.uWindDirection.value.fromArray(config.windDirection)
//     matUniforms.uVelocity.value.fromArray(config.velocity)
//     matUniforms.uWindMultiplier.value = config.windMultiplier
//     matUniforms.uWindOffset.value = config.windOffset
//     matUniforms.uLiftOffset.value = config.liftOffset
//     matUniforms.uDomainOffset.value = config.domainOffset
//     matUniforms.uSwayMultiplier.value.fromArray(config.swayMultiplier)
//     matUniforms.uBendStiffness.value = config.bendStiffness
//     matUniforms.uGustModifiers.value.fromArray(config.gustModifiers)
//     matUniforms.uGustBlend.value.fromArray(config.gustBlend)
//     matUniforms.uGustTurbulence.value.fromArray(config.gustTurbulence)
//     matUniforms.uTerrainWave.value.fromArray(config.terrainWave)
//   })

//   return (
//     <instancedMesh ref={meshRef} args={[null, null, count]}>
//       <planeGeometry args={[0.6, 0.6, 1, 6]} />
//       <GrassMaterial ref={materialRef} />
//     </instancedMesh>
//   )
// }

import * as THREE from 'three';
import React, { useMemo, useRef } from 'react';
import { extend, useFrame } from '@react-three/fiber';
import { shaderMaterial } from '@react-three/drei';
import { useControls } from 'leva';

const GrassFieldMaterial = shaderMaterial(
  {
    uTime: 0,
    uNoiseTexture: null,
    uTurbulenceTexture: null,

    uWindSettings: new THREE.Vector4(1.0, 0.08, 0.05, 2.0),
    uTurbulenceSettings: new THREE.Vector4(0.15, 0.1, 0.5, 0.25),
    uCurveSettings: new THREE.Vector4(1.0, 1.0, 1.0, 0.0),

    uWindDirection: new THREE.Vector2(1.0, 0.0),
  },

  /* glsl */ `
    attribute vec3 instanceOffset;
    attribute float instanceScale;
    attribute float instanceRotation;

    uniform float uTime;

    uniform sampler2D uNoiseTexture;
    uniform sampler2D uTurbulenceTexture;

    uniform vec4 uWindSettings;
    uniform vec4 uTurbulenceSettings;
    uniform vec4 uCurveSettings;

    uniform vec2 uWindDirection;

    varying vec2 vUv;

    vec3 bezierCubic(
      vec3 p0,
      vec3 p1,
      vec3 p2,
      vec3 p3,
      float t
    ) {
      vec3 a = mix(p0, p1, t);
      vec3 b = mix(p1, p2, t);
      vec3 c = mix(p2, p3, t);

      vec3 d = mix(a, b, t);
      vec3 e = mix(b, c, t);

      return mix(d, e, t);
    }

    vec3 windDeform(
      vec3 position,
      vec2 uv,
      vec3 worldPos,
      sampler2D noiseTexture,
      sampler2D turbulenceTexture,
      float time,
      vec4 windSettings,
      vec4 turbulenceSettings,
      vec4 curveSettings,
      vec2 windDirection
    ) {
      float windStrength = windSettings.x;
      float noiseScale = windSettings.y;
      float noiseSpeed = windSettings.z;
      float bendFalloff = windSettings.w;

      float turbulenceScale = turbulenceSettings.x;
      float turbulenceSpeed = turbulenceSettings.y;
      float turbulenceStrength = turbulenceSettings.z;
      float domainWarpStrength = turbulenceSettings.w;

      float bladeHeight = curveSettings.x;
      float curveStrength = curveSettings.y;
      float tipStrength = curveSettings.z;

      vec2 dir = normalize(windDirection);

      vec2 windUV = worldPos.xz * noiseScale;

      vec2 noiseOffset = dir * noiseSpeed * time;

      float baseNoise = texture(
        noiseTexture,
        windUV + noiseOffset
      ).r;

      vec2 turbulenceUV = worldPos.xz * turbulenceScale;

      vec2 turbulenceOffset = dir * turbulenceSpeed * time;

      vec2 turbulence = texture(
        turbulenceTexture,
        turbulenceUV + turbulenceOffset
      ).rg * 2.0 - 1.0;

      vec2 warpedUV = windUV + turbulence * domainWarpStrength;

      float warpedNoise = texture(
        noiseTexture,
        warpedUV + noiseOffset
      ).r;

      float windNoise = mix(
        baseNoise,
        warpedNoise,
        domainWarpStrength
      );

      windNoise += length(turbulence) * turbulenceStrength;

      float t = uv.y;

      float heightMask = pow(t, bendFalloff);

      vec3 wind = vec3(dir.x, 0.0, dir.y) * windNoise * windStrength;

      vec3 p0 = vec3(0.0);

      vec3 p1 =
        (wind * 0.25 * curveStrength) +
        vec3(0.0, bladeHeight * 0.33, 0.0);

      vec3 p2 =
        (wind * 0.75 * curveStrength) +
        vec3(0.0, bladeHeight * 0.66, 0.0);

      vec3 p3 =
        (wind * tipStrength) +
        vec3(0.0, bladeHeight, 0.0);

      vec3 curve = bezierCubic(
        p0,
        p1,
        p2,
        p3,
        t
      );

      vec3 finalPosition = position;

      finalPosition.xz += curve.xz * heightMask;
      finalPosition.y = curve.y;

      return finalPosition;
    }

    mat2 rotate2D(float angle) {
      float s = sin(angle);
      float c = cos(angle);

      return mat2(c, -s, s, c);
    }

    void main() {
      vUv = uv;

      vec3 pos = position;
      pos.y += 0.5;
      pos *= instanceScale;
      pos.xz *= rotate2D(instanceRotation);

      vec3 worldPos = instanceOffset + pos;

      vec3 deformed = windDeform(
        pos,
        uv,
        worldPos,
        uNoiseTexture,
        uTurbulenceTexture,
        uTime,
        uWindSettings,
        uTurbulenceSettings,
        uCurveSettings,
        uWindDirection
      );

      deformed += instanceOffset;

      // ---------------------------------------------
      // NORMAL RECONSTRUCTION (TANGENT BASIS)
      // ---------------------------------------------

      float t = uv.y;
      float eps = 0.01;

      vec3 deformedNext = windDeform(
        pos,
        vec2(uv.x, uv.y + eps),
        worldPos,
        uNoiseTexture,
        uTurbulenceTexture,
        uTime,
        uWindSettings,
        uTurbulenceSettings,
        uCurveSettings,
        uWindDirection
      );

      deformedNext += instanceOffset;

      vec3 tangentV = normalize(deformedNext - deformed);

      mat2 r = rotate2D(instanceRotation);
      vec2 localX = r * vec2(1.0, 0.0);
      vec3 tangentU = normalize(vec3(localX.x, 0.0, localX.y));

      vec3 normal = normalize(cross(tangentU, tangentV));

      gl_Position = projectionMatrix * modelViewMatrix * vec4(deformed, 1.0);
    }
  `,

  /* glsl */ `
    varying vec2 vUv;

    void main() {
      vec3 base = mix(
        vec3(0.08, 0.25, 0.08),
        vec3(0.3, 0.8, 0.25),
        vUv.y
      );

      gl_FragColor = vec4(base, 1.0);
    }
  `
);

extend({ GrassFieldMaterial });

export default function GrassField({
  count = 20000,
  area = 40,
}) {
  const materialRef = useRef();

  const controls = useControls('Grass Wind', {
    windStrength: {
      value: 1.25,
      min: 0,
      max: 5,
      step: 0.01,
    },

    noiseScale: {
      value: 0.08,
      min: 0.001,
      max: 1,
      step: 0.001,
    },

    noiseSpeed: {
      value: 0.05,
      min: 0,
      max: 1,
      step: 0.001,
    },

    bendFalloff: {
      value: 2.0,
      min: 0.1,
      max: 8,
      step: 0.01,
    },

    turbulenceScale: {
      value: 0.15,
      min: 0.001,
      max: 1,
      step: 0.001,
    },

    turbulenceSpeed: {
      value: 0.1,
      min: 0,
      max: 2,
      step: 0.001,
    },

    turbulenceStrength: {
      value: 0.5,
      min: 0,
      max: 5,
      step: 0.01,
    },

    domainWarpStrength: {
      value: 0.25,
      min: 0,
      max: 2,
      step: 0.01,
    },

    bladeHeight: {
      value: 1,
      min: 0.1,
      max: 3,
      step: 0.01,
    },

    curveStrength: {
      value: 1,
      min: 0,
      max: 5,
      step: 0.01,
    },

    tipStrength: {
      value: 1,
      min: 0,
      max: 5,
      step: 0.01,
    },

    windX: {
      value: 1,
      min: -1,
      max: 1,
      step: 0.01,
    },

    windY: {
      value: 0,
      min: -1,
      max: 1,
      step: 0.01,
    },
  });

  const geometry = useMemo(() => {
    const geo = new THREE.PlaneGeometry(0.08, 1, 1, 12);

    const offsets = new Float32Array(count * 3);
    const scales = new Float32Array(count);
    const rotations = new Float32Array(count);

    for (let i = 0; i < count; i++) {
      const i3 = i * 3;

      offsets[i3 + 0] = (Math.random() - 0.5) * area;
      offsets[i3 + 1] = 0;
      offsets[i3 + 2] = (Math.random() - 0.5) * area;

      scales[i] = THREE.MathUtils.randFloat(0.75, 1.5);
      rotations[i] = Math.random() * Math.PI;
    }

    geo.setAttribute(
      'instanceOffset',
      new THREE.InstancedBufferAttribute(offsets, 3)
    );

    geo.setAttribute(
      'instanceScale',
      new THREE.InstancedBufferAttribute(scales, 1)
    );

    geo.setAttribute(
      'instanceRotation',
      new THREE.InstancedBufferAttribute(rotations, 1)
    );

    return geo;
  }, [count, area]);

  const noiseTexture = useMemo(() => {
    const size = 128;
    const data = new Uint8Array(size * size * 4);

    for (let i = 0; i < data.length; i += 4) {
      const v = Math.random() * 255;

      data[i + 0] = v;
      data[i + 1] = v;
      data[i + 2] = v;
      data[i + 3] = 255;
    }

    const tex = new THREE.DataTexture(
      data,
      size,
      size,
      THREE.RGBAFormat
    );

    tex.wrapS = tex.wrapT = THREE.RepeatWrapping;
    tex.needsUpdate = true;

    return tex;
  }, []);

  useFrame(({ clock }) => {
    if (!materialRef.current) return;

    materialRef.current.uTime = clock.elapsedTime;

    materialRef.current.uWindSettings.set(
      controls.windStrength,
      controls.noiseScale,
      controls.noiseSpeed,
      controls.bendFalloff
    );

    materialRef.current.uTurbulenceSettings.set(
      controls.turbulenceScale,
      controls.turbulenceSpeed,
      controls.turbulenceStrength,
      controls.domainWarpStrength
    );

    materialRef.current.uCurveSettings.set(
      controls.bladeHeight,
      controls.curveStrength,
      controls.tipStrength,
      0
    );

    materialRef.current.uWindDirection.set(
      controls.windX,
      controls.windY
    );
  });

  return (
    <instancedMesh args={[geometry, null, count]} frustumCulled={false}>
      <grassFieldMaterial
        ref={materialRef}
        side={THREE.DoubleSide}
        uNoiseTexture={noiseTexture}
        uTurbulenceTexture={noiseTexture}
      />
    </instancedMesh>
  );
}

/*
Replace this placeholder with the full implementation below if you want to continue iterating.

Requested structure:
- Single file R3F component
- Component name: GrassField
- Shader material name: GrassFieldMaterial
- Uses Leva for tuning uniforms
- Demonstrates cubic bezier wind deformation
- Uses world-space XZ wind sampling
- Includes turbulence + optional domain warping
- Uses uv.y for blade height curve sampling
*/
