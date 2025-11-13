import { shaderMaterial, useTexture } from '@react-three/drei'
import { extend, useFrame } from '@react-three/fiber'
import React, { useRef } from 'react'
import vertex from '../shaders/translucent/vertex.glsl'
import fragment from '../shaders/translucent/fragment.glsl'
import { RepeatWrapping, Vector2, Color } from 'three'

export default function TranslucentMaterial( {
    texture ='./textures/noise/noiseVoronoi.png',
    ...props
} ) 
{
    const self = useRef()

    const noise = useTexture( texture )
    noise.wrapS = RepeatWrapping
    noise.wrapT = RepeatWrapping

    const uniforms =
    {
        uTime: 0,
        uNoiseTexture: noise,
        uAlbedo: new Color('#4BA3C7'),
        uDiffuse: new Color('#3E94B5'),
        uTranslucent: new Color('#7FD0E0')
    }

    useFrame( ( state, delta ) =>
    {
        self.current.uniforms.uTime.value += delta
    })

    const TranslucentMaterial = shaderMaterial( uniforms, vertex, fragment )
    extend( { TranslucentMaterial } )

    return (
        <translucentMaterial
            key={ TranslucentMaterial.key }
            ref={ self }
            {...props}
        />
    )
}