import { shaderMaterial } from '@react-three/drei'
import { extend } from '@react-three/fiber'
import React, { useEffect, useRef } from 'react'
import vertex from '../shaders/parallax/vertex.glsl'
import fragment from '../shaders/parallax/fragment.glsl'


const customMaterial = shaderMaterial( 
    {
        uTime: 0,
        uBaseImg: null,
        uDepthImg: null,
        uDepthOffset: 0.01
    }, 
    vertex, 
    fragment 
);

extend( { customMaterial } );

export default function ParallaxDepthMaterial() 
{

    const self = useRef();

    useEffect( () =>{
        self.current.uniforms.uBaseImg.value = ''
    }, []);

  return (
    <ParallaxDepthMaterial
        key={ customMaterial.key }
        ref={ self }
        { ...props }
    />
  )

}
