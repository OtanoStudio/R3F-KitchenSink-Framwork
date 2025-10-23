import { shaderMaterial, useTexture } from '@react-three/drei'
import { extend, useFrame } from '@react-three/fiber'
import React, { useRef } from 'react'
import vertex from '../shaders/sphere/vertex.glsl'
import fragment from '../shaders/sphere/fragment.glsl'
import { RepeatWrapping, Vector2, Color } from 'three'

export default function SphereMaterial( {
    texture ='./textures/noise/noiseVoronoi.png',
    textureNoise = './textures/noise/noiseWavey.png',
    textureColorRamp = './textures/gradientmaps/gradientmap2.png',
    ...props
} ) 
{
    const self = useRef()

    const noise = useTexture( texture )
    noise.wrapS = RepeatWrapping
    noise.wrapT = RepeatWrapping

    const noiseOffsetTexture = useTexture( textureNoise )
    noiseOffsetTexture.wrapS = RepeatWrapping
    noiseOffsetTexture.wrapT = RepeatWrapping

    const colorRamp = useTexture( textureColorRamp )
    colorRamp.wrapS = RepeatWrapping
    colorRamp.wrapT = RepeatWrapping

    const uniforms =
    {
        uTime: 0,
        uNoiseTexture: noise,
        uOffsetTexture: noiseOffsetTexture,
        uColorRamp: colorRamp,
    }

    useFrame( ( state, delta ) =>
    {
        self.current.uniforms.uTime.value += delta
    })

    const SphereMaterial = shaderMaterial( uniforms, vertex, fragment )
    extend( { SphereMaterial } )

    return (
        <sphereMaterial
            key={ SphereMaterial.key }
            ref={ self }
            {...props}
        />
    )
}