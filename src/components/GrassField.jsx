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

import { useRef, useMemo, useEffect } from "react"
import { Object3D, MathUtils, Vector2, Vector3, Matrix2 } from "three"
import { useFrame } from "@react-three/fiber"
import { useControls, folder } from "leva"
import GrassMaterial from "../materials/GrassMaterial.jsx"

export default function GrassField({
  count = 3000,
  area = 12
}) {
  const meshRef = useRef()
  const materialRef = useRef()
  const dummy = useMemo(() => new Object3D(), [])

  // Leva controls configured for baseline vs periodic wind bursts
  const config = useControls("Grass Wind Engine", {
    Wind_Core: folder({
  windDirection: { value: [1.0, 0.35], step: 0.05 },
  velocity: { value: [0.25, 0.05], step: 0.01 },       // Raised: x moves the wave, keeping y low prevents micro-shaking
  windMultiplier: { value: 1.5, min: 0, max: 5, step: 0.1 }, // Raised: Gives the overall movement more physical range
  windOffset: { value: 0.5, min: 0, max: 3, step: 0.05 },
  domainOffset: { value: 0.45, min: 0, max: 3, step: 0.05 },
  windRotation: { value: 45, min: 0, max: 360, step: 1 }, 
}),
Sway_Settings: folder({
  swayMultiplier: { value: [1.2, 0.4], step: 0.05 },    // Raised: Increases the mechanical leaning distance
  bendStiffness: { value: 2.5, min: 1.0, max: 6.0, step: 0.1 }, // Lowered: Makes the blades more pliable/responsive
}),
Periodic_Gusts: folder({
  gustModifiers: { value: [0.4, 0.5, 2.0], step: 0.05 },
  gustBlend: { value: [0.3, 1.8], step: 0.05 },        // Adds a healthy mix of constant wave + occasional push
  gustTurbulence: { value: [0.5, 0.2], step: 0.05 },
}),
Terrain_Waves: folder({
  terrainWave: { value: [0.15, 0.3, 0.2], step: 0.01 },
})
  })

  // Population loop for instanced positioning and variations
  useEffect(() => {
    if (!meshRef.current) return

    for (let i = 0; i < count; i++) {
      const x = MathUtils.randFloatSpread(area)
      const z = MathUtils.randFloatSpread(area)

      dummy.position.set(x, 0, z)

      const scale = MathUtils.randFloat(0.6, 1.4)
      dummy.scale.set(scale, scale, scale)
      
      dummy.rotation.y = MathUtils.randFloat(0, Math.PI * 2)

      dummy.updateMatrix()
      meshRef.current.setMatrixAt(i, dummy.matrix)
    }

    meshRef.current.instanceMatrix.needsUpdate = true
  }, [count, area, dummy])

  // Uniform pipeline streaming calculations straight to the GPU program
  useFrame((state) => {
    if (!materialRef.current) return

    const matUniforms = materialRef.current.uniforms

    matUniforms.uTime.value = state.clock.getElapsedTime()

    // PRECALCULATE ROTATION MATRIX: Drop per-vertex sin/cos logic
    const rad = (config.windRotation * Math.PI) / 180
    matUniforms.uPrecalculatedRot.value.set(
      Math.cos(rad), -Math.sin(rad),
      Math.sin(rad),  Math.cos(rad)
    )

    // Sync all parameters reactively
    matUniforms.uWindDirection.value.fromArray(config.windDirection)
    matUniforms.uVelocity.value.fromArray(config.velocity)
    matUniforms.uWindMultiplier.value = config.windMultiplier
    matUniforms.uWindOffset.value = config.windOffset
    matUniforms.uLiftOffset.value = config.liftOffset
    matUniforms.uDomainOffset.value = config.domainOffset
    matUniforms.uSwayMultiplier.value.fromArray(config.swayMultiplier)
    matUniforms.uBendStiffness.value = config.bendStiffness
    matUniforms.uGustModifiers.value.fromArray(config.gustModifiers)
    matUniforms.uGustBlend.value.fromArray(config.gustBlend)
    matUniforms.uGustTurbulence.value.fromArray(config.gustTurbulence)
    matUniforms.uTerrainWave.value.fromArray(config.terrainWave)
  })

  return (
    <instancedMesh ref={meshRef} args={[null, null, count]}>
      <planeGeometry args={[0.6, 0.6, 1, 6]} />
      <GrassMaterial ref={materialRef} />
    </instancedMesh>
  )
}