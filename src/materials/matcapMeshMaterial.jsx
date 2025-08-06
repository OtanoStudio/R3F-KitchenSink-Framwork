import { shaderMaterial, useTexture } from '@react-three/drei'
import { extend, useFrame } from '@react-three/fiber'
import React, { useRef } from 'react'
import vertex from '../shaders/matcapVert.glsl'
import fragment from '../shaders/matcapFrag.glsl'
import { RepeatWrapping, Vector2, Color } from 'three'

export default function MatcapMeshMaterial( {
    texture ='./textures/noise/noiseVoronoi.png',
    textureMatcap = './textures/matcaps/4.jpg',
    isVersion2 = false,
    ...props
} ) 
{
    const self = useRef()

    const noise = useTexture( texture )
    noise.wrapS = RepeatWrapping
    noise.wrapT = RepeatWrapping

    const MatcapTexture = useTexture( textureMatcap )

    isVersion2 = ( typeof isVersion2 === 'boolean' ) ? isVersion2 : false

    const uniforms =
    {
        uTime: 0,
        uNoiseTexture: noise,
        uV2: isVersion2,
        uMatcap: MatcapTexture,
    }

    useFrame( ( state, delta ) =>
    {
        self.current.uniforms.uTime.value += delta
    })

    const MatcapMeshMaterial = shaderMaterial( uniforms, vertex, fragment )
    extend( { MatcapMeshMaterial } )

    return (
        <matcapMeshMaterial
            key={ MatcapMeshMaterial.key }
            ref={ self }
            {...props}
        />
    )
}