import { PerspectiveCamera } from '@react-three/drei';
import { useThree } from '@react-three/fiber';
import React from 'react'

export function AspectCamera({
    zDistance = 600,
    near = 1,
    far = 1000,
    makeDefault = true,
    ...props

})
{

    const { size, aspect  } = useThree();
    makeDefault = ( typeof makeDefault === 'boolean' ) ? makeDefault: true;
    
    const fov = 2 * Math.atan( ( size.height / 2 ) / zDistance ) * 180 / Math.PI;

    return (
        <PerspectiveCamera
        position-z={ zDistance }
        aspect={ aspect }
        fov={ fov }
        near={ near }
        far={ far }
        makeDefault={ makeDefault }
      />
    )

}
