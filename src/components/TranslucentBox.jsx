import { useRef } from 'react'
import TranslucentMaterial from '../materials/TranslucentMaterial'
import SparkleMaterial from '../materials/SparkleMaterial'

export default function TransLucentBox() 
{
  const self = useRef()

  return (
    <mesh ref={ self } >
        <icosahedronGeometry
            args={ [ 3, 5 ] }
        />
        <SparkleMaterial />
    </mesh>
  )
}
