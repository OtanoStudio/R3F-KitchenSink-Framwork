import { useRef, useMemo, useEffect } from "react"
import { Object3D, InstancedBufferAttribute, MathUtils } from "three"
import GrassMaterial from "../materials/GrassMaterial.jsx"

export default function GrassField({
  count = 1000,
  area = 5
}) {
  const meshRef = useRef()
  const dummy = useMemo(() => new Object3D(), [])

  // Per-instance wind phase
  const phases = useMemo(() => {
    const arr = new Float32Array(count)
    for (let i = 0; i < count; i++) {
      arr[i] = Math.random() * Math.PI * 2
    }
    return arr
  }, [count])

  useEffect(() => {
    if (!meshRef.current) return

    for (let i = 0; i < count; i++) {
      const x = MathUtils.randFloatSpread(area)
      const z = MathUtils.randFloatSpread(area)

      dummy.position.set(x, 0, z)

      // random rotation
      dummy.rotation.y = Math.random() * Math.PI * 2

      // random scale variation
      const scale = 1.0
      dummy.scale.set(scale, scale, scale)

      dummy.updateMatrix()
      meshRef.current.setMatrixAt(i, dummy.matrix)
    }

    meshRef.current.instanceMatrix.needsUpdate = true

    meshRef.current.geometry.setAttribute(
      "instancePhase",
      new InstancedBufferAttribute(phases, 1)
    )

  }, [count, area, phases, dummy])

  return (
    <instancedMesh ref={meshRef} args={[undefined, undefined, count]}>
      <planeGeometry args={[1.3, 1.5, 1, 5]} />
      <GrassMaterial />
    </instancedMesh>
  )
}
