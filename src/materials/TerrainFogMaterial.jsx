import { shaderMaterial, useTexture } from '@react-three/drei'
import vertex from '../shaders/terrainfog/vertex.glsl'
import fragment from '../shaders/terrainfog/fragment.glsl'
import { extend, useFrame, useThree } from '@react-three/fiber';
import { useEffect, useRef } from 'react';
import { AdditiveBlending, MultiplyBlending, RepeatWrapping } from 'three/src/constants.js';
import { Vector2 } from 'three';



// core material logic here
const MaterialImpl = shaderMaterial(
    {
        uTime: 0,
        uTerrainMap: null,
        uFogNoise: null,
        uDisplacementFactor: 1,
        uFogSpeed: 1,
        uDepthTexture: null,
        uOpacityMultiplier: 1,
        uUseTerrainMap: false,
        ufogParallaxAmt: 0.2,
        uResolution: null,
        uPositionMask: null,
        uNear: null,
        uFar: null,
        uSceneColor: null
    },
    vertex,
    fragment
);

extend({ MaterialImpl });


export default function TerrainFogMaterial(
    {
        terrainHeightMap = './textures/noise/noisePerlin.webp', // conform fog to your terrain's shape
        fogNoiseTexture = './textures/noise/noiseValue.webp', // noise texture for the fog
        displaceAmount = 0.3, // how much to displace the vertices of the plane using the noise
        noiseScrollSpeed = 0.3, // how muc the noise moves
        opacityMultiplier = 1, // additional opacity control
        depthText = './textures/noise/noiseValue.webp', // rt noise texture
        useHeight = false,
        fogParallaxAmt = 0.02,
        ...props
    }
) 
{

    const self = useRef();
    const fogMask = useTexture( './textures/alphamaps/fogMask.webp');
    const hMap = useTexture( terrainHeightMap );
    hMap.wrapS = hMap.wrapT = RepeatWrapping;
    const fogTxt = useTexture(  fogNoiseTexture );
    fogTxt.wrapS = fogTxt.wrapT = RepeatWrapping;
    const { size, camera } = useThree();

    useEffect( () =>
    {
        self.current.uniforms.uFogNoise.value = fogTxt;
        self.current.uniforms.uTerrainMap.value = hMap;
        self.current.uniforms.uDisplacementFactor.value = displaceAmount;
        self.current.uniforms.uFogSpeed.value = noiseScrollSpeed;
        self.current.uniforms.uOpacityMultiplier.value = opacityMultiplier;
        self.current.uniforms.uDepthTexture.value = depthText;
        self.current.uniforms.uUseTerrainMap.value  = useHeight;
        self.current.uniforms.ufogParallaxAmt.value = fogParallaxAmt;
        self.current.uniforms.uResolution.value = new Vector2( size.x, size.y );
        self.current.uniforms.uPositionMask.value = fogMask;
        self.current.uniforms.uNear.value = camera.near;
        self.current.uniforms.uFar.value = camera.far;
        self.current.uniforms.uSceneColor.value = depthText;
    });

    useFrame( ( state, delta ) =>
    {

        self.current.uniforms.uTime.value += delta;

    });

  return (
    <materialImpl
        ref={ self }
        transparent={ true }
        depthWrite={false}
    />
  )
}
