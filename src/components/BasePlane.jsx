import React from 'react'
import BaseMaterial from '../materials/BaseMaterial.jsx'

export default function BasePlane() 
{
  return (
    <mesh>
        <planeGeometry
            args={ [ 10, 7, 64, 64 ] }
        />
        <BaseMaterial />
    </mesh>
  )
}
