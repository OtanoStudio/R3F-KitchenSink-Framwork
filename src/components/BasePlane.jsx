import { useRef } from 'react'
import BaseMaterial from '../materials/BaseMaterial.jsx'
import { useRenderTexture } from '../hooks/useRenderTexture.jsx'

export default function BasePlane() 
{
  const self = useRef()

  const rtTextures = useRenderTexture( self, false, true )

  console.log( rtTextures )


  return (
    <mesh ref={ self } >
        <planeGeometry
            args={ [ 10, 7, 64, 64 ] }
        />
        <BaseMaterial sceneTexture={ rtTextures.scene } />
    </mesh>
  )
}
