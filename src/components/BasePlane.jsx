import { useRef } from 'react'
import BaseMaterial from '../materials/BaseMaterial.jsx'
import { useRenderTexture } from '../hooks/useRenderTexture.jsx'

export function BasePlane() 
{
  const self = useRef()

  return (
    <mesh ref={ self } >
        <planeGeometry
            args={ [ 3, 3, 1, 1 ] }
        />
        <BaseMaterial />
    </mesh>
  )
}
