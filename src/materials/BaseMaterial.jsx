import { shaderMaterial, useTexture } from '@react-three/drei'
import { extend, useFrame } from '@react-three/fiber'
import React, { useRef } from 'react'
import vertex from '../shaders/vertex.glsl'
import fragment from '../shaders/fragment.glsl'
import { RepeatWrapping, Vector2, Color } from 'three'
import { SRGBColorSpace } from 'three/src/constants.js'

export default function BaseMaterial( {
    texture ='./textures/noise/wind_noise.png',
    gradientMap = './textures/gradientmaps/grassred.webp',
    offsetNoise = './textures/noise/noisePerlinWind2.webp',
    ...props
} ) 
{
    const self = useRef()

    const [ noise, colorMap, noiseOffset ] = useTexture( [ texture, gradientMap, offsetNoise ] )
    noise.wrapS = RepeatWrapping
    noise.wrapT = RepeatWrapping
    colorMap.colorSpace = SRGBColorSpace
    noiseOffset.wrapS = noiseOffset.wrapT = RepeatWrapping


    const uniforms =
    {
        uTime: 0,
        uNoiseTexture: noise,
        uColorMap: colorMap,
        uOffsetNoise: noiseOffset
    }

    useFrame( ( state, delta ) =>
    {
        self.current.uniforms.uTime.value += delta
    })

    const BaseMaterial = shaderMaterial( uniforms, vertex, fragment )
    extend( { BaseMaterial } )

    return (
        <baseMaterial
            key={ BaseMaterial.key }
            ref={ self }
            transparent={ true }
            {...props}
        />
    )
}