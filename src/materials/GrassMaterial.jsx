import { shaderMaterial, useTexture } from '@react-three/drei'
import { extend, useFrame } from '@react-three/fiber'
import { useRef } from 'react'
import vertex from '../shaders/grass/vertex.glsl'
import fragment from '../shaders/grass/fragment.glsl'
import { RepeatWrapping, Vector2, Color, Vector3 } from 'three'

export default function GrassMaterial( {
    texture ='./textures/noise/noisePerlin.webp',
    grassTexture ='./textures/tiles/grass/grass3.webp',
    colorTip = '#A1D88D',
    colorBase = '#136d15',
    ...props
} ) 
{
    const self = useRef()

    const noise = useTexture( texture )
    noise.wrapS = RepeatWrapping
    noise.wrapT = RepeatWrapping

    const textureGrass = useTexture( grassTexture )

    const uniforms =
    {

        uTime: 0,
        uNoiseTexture: noise,
        uGrassTexture: textureGrass,
        uTipColor: new Color( colorTip ),
        uBaseColor: new Color( colorBase )

    }

    useFrame( ( state, delta ) =>
    {
        self.current.uniforms.uTime.value += delta
    })

    const GrassMaterial = shaderMaterial( uniforms, vertex, fragment )
    extend( { GrassMaterial } )

    return (
        <grassMaterial
            key={ GrassMaterial.key }
            ref={ self }
            {...props}
        />
    )
}