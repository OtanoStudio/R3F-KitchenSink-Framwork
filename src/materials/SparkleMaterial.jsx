import { shaderMaterial, useTexture } from '@react-three/drei'
import { extend, useFrame } from '@react-three/fiber'
import React, { useRef } from 'react'
import vertex from '../shaders/sparkles/vertex.glsl'
import fragment from '../shaders/sparkles/fragment.glsl'
import { RepeatWrapping, Vector2, Color } from 'three'

export default function SparkleMaterial( {
    texture ='./textures/noise/Noise.png',
    ...props
} ) 
{
    const self = useRef()

    const { sceneTexture } = props

    console.log( sceneTexture )

    const noise = useTexture( texture )
    noise.wrapS = RepeatWrapping
    noise.wrapT = RepeatWrapping

    const uniforms =
    {
        uTime: 0,
        uNoiseTexture: noise,
    }

    useFrame( ( state, delta ) =>
    {
        self.current.uniforms.uTime.value += delta
    })

    const SparkleMaterial = shaderMaterial( uniforms, vertex, fragment )
    extend( { SparkleMaterial } )

    return (
        <sparkleMaterial
            key={ SparkleMaterial.key }
            ref={ self }
            {...props}
        />
    )
}