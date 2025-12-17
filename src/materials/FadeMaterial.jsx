
import { shaderMaterial, useTexture } from '@react-three/drei'
import { extend, useFrame } from '@react-three/fiber'
import { Color, DoubleSide } from 'three';
import vertex from '../shaders/Fade/vertex.glsl';
import fragment from '../shaders/Fade/fragment.glsl';
import { useRef } from 'react';

export function FadeMaterial(
    {
        imgTexture = './textures/logo/ODS.webp',
        ...props
    }
) 
{
    const self = useRef();
    const textureAlpha = useTexture( imgTexture )

    const uniforms =
    {

        uTime: 0,
        uTexture: textureAlpha,
        uColor: new Color( "#9ffcff" ).multiplyScalar( 1.5 ),
        uProgress: 0,

    }

    useFrame( ( state, delta ) =>
    {
        self.current.uniforms.uTime.value += delta;
    })
    const FadeMaterial = shaderMaterial( uniforms, vertex, fragment );
    extend( { FadeMaterial } );

  return (
    <fadeMaterial
        key={ FadeMaterial.key }
        ref={ self }
        { ...props }
        transparent={ true }
        sided={ DoubleSide }
    />
  )
}
