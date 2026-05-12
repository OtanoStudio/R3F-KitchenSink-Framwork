import { useRef, useMemo, useEffect } from "react"
import { Object3D, InstancedBufferAttribute, MathUtils } from "three"
import GrassMaterial from "../materials/GrassMaterial.jsx"

export default function GrassField({
  count = 2000,
  area = 12
}) {
  const meshRef = useRef()
  const dummy = useMemo(() => new Object3D(), [])

  useEffect(() => {
    if (!meshRef.current) return

    for (let i = 0; i < count; i++) {
      const x = MathUtils.randFloatSpread(area)
      const z = MathUtils.randFloatSpread(area)

      dummy.position.set(x, 0, z)

      // random scale variation
      const scale = 1.0
      dummy.scale.set(scale, scale, scale)

      dummy.updateMatrix()
      meshRef.current.setMatrixAt(i, dummy.matrix)
    }

    meshRef.current.instanceMatrix.needsUpdate = true


  }, [count, area, dummy])

  return (
    <instancedMesh ref={meshRef} args={[undefined, undefined, count]}>
      <planeGeometry args={[0.6, 0.6, 1, 1]} />
      <GrassMaterial />
    </instancedMesh>
  )
}
