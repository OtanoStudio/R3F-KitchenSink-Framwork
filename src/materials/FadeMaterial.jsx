
import { shaderMaterial, useTexture } from '@react-three/drei'
import { extend, useFrame } from '@react-three/fiber'
import { Color, DoubleSide, SRGBColorSpace } from 'three';
import vertex from '../shaders/Fade/vertex.glsl';
import fragment from '../shaders/Fade/fragment.glsl';
import { useRef } from 'react';
import gsap from 'gsap';
import { useGSAP } from '@gsap/react';

export function FadeMaterial(
    {
        imgTexture = './textures/logo/ODS.webp',
        lineTexture = './textures/logo/ODSLines.webp',
        colorTexture = './textures/logo/ODSColor.webp',
        ...props
    }
) 
{
    const self = useRef();

    gsap.registerPlugin( useGSAP );

    const textureAlpha = useTexture( imgTexture );
    const textureLine = useTexture( lineTexture );
    const textureAlbedo = useTexture( colorTexture );
    textureAlbedo.colorSpace = SRGBColorSpace;

    const uniforms =
    {

        uTime: 0,
        uTexture: textureAlpha,
        uTextureLine: textureLine,
        uTextureColor: textureAlbedo,
        uColor: new Color( "#9ffcff" ).multiplyScalar( 1.5 ),
        uProgress: 0,
        uRevealProgress: 0,
        uFadeProgress: 0,

    }

    useGSAP( () =>
    {

        gsap.to( self.current.uniforms.uProgress,
        { 
            duration: 3,
            value: 1,
            ease: 'back.out'
        });

        gsap.to( self.current.uniforms.uRevealProgress,
        { 
            duration: 4,
            value: 1,
            ease: 'back.out',
            delay: 1,
            onComplete: () =>
            {
                gsap.to( self.current.uniforms.uFadeProgress, 
                {
                    duration:2,
                    value: 1,
                    ease: 'power4.out'
                } )
            }
        }, );

    });

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
