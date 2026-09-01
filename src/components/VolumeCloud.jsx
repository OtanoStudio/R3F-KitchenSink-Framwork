import { useRef } from 'react';
import { VolumeMaterial } from '../materials/VolumeMaterial.jsx';

export function VolumeCloud( props ) 
{
  const self = useRef()

  return (
    <mesh 
      ref={ self } 
      {...props }
    >
        <boxGeometry
            args={ [ 1, 1, 1 ] }
        />
        <VolumeMaterial />
    </mesh>
  )
}