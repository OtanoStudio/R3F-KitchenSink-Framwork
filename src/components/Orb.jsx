import { useRef } from 'react'
import MatcapMeshMaterial from '../materials/matcapMeshMaterial.jsx'

export default function Orb({
    version2 = false,
    ...props
}) 
{
  const self = useRef()

  version2 = ( typeof version2 === 'boolean' ) ? version2 : false


  return (
    <mesh ref={ self } {...props}>
        <torusKnotGeometry
            args={ [ 1.3, 0.4, 64, 64 ] }
        />
        <MatcapMeshMaterial
            isVersion2={ version2 }
        />
    </mesh>
  )
}