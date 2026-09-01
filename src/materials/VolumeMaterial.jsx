import { shaderMaterial, useTexture } from "@react-three/drei";
import { extend, useFrame } from "@react-three/fiber";
import { useRef } from "react";
import { Color, Matrix4, Vector3 } from "three";
import { imageToVolume3D } from "../utils/imageToVolume3D";
import fragment from '../shaders/volume/fragment.glsl';
import vertex from '../shaders/volume/vertex.glsl';


export const VolumeMaterial = (
    {
        colorBase = '#eef2f3',
        colorShadow = '#4a5a6f',
        volumeTexture = './textures/volumes/cloud_01_3dtex.png',
        volumeslices = 8,
        timeOffset = 0.2,
        factorDarkness = 0.19,
        factorTransmittance = 1.0,
        factorAbsorption = 1.5,
        lightDirection = new Vector3( 0, 1, 0 ),
        ...props
    }
) => 
{

    const volumeImg = useTexture( volumeTexture );
    const volumeData = imageToVolume3D( volumeImg.image, volumeslices, volumeslices );
    colorBase = new Color( colorBase );
    colorShadow = new Color( colorShadow );

    const self = useRef();

    const uniforms = 
    {

        uTime: 0,
        uColorBase: colorBase,
        uColorShadow: colorShadow,
        uTimeOffset: timeOffset,
        uVolume: volumeData,
        uDarkness: factorDarkness,
        uTransmittance: factorTransmittance,
        uAbsorption: factorAbsorption,
        uLightDir: lightDirection,
        uInvViewMat: new Matrix4(),

    };

    useFrame( ( state, delta ) =>
    {

        self.current.uniforms.uTime.value += delta;
        self.current.uniforms.uInvViewMat.value = state.camera.matrixWorld;

    });

    const VolumeMaterial = shaderMaterial( uniforms, vertex, fragment );
    extend( { VolumeMaterial } );

  return (
    <volumeMaterial
        ref={ self }
        key={ VolumeMaterial.key }
        transparent={ true }
        { ...props }
    />
  )

}

