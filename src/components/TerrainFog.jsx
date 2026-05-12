import React, { useEffect, useRef, forwardRef } from 'react'
import TerrainFogMaterial from '../materials/TerrainFogMaterial';
import { DepthTexture } from 'three';
import { useTexture } from '@react-three/drei';

export default forwardRef( function TerrainFog(
    {
        terrainWidth = 12, // width of the terrain in threejs units
        terrainHeight = 12, // height of the plane
        subDivisions = 258, // for finer fog
        terrainHeightMap = './textures/noise/noiseFBM.webp', // conform fog to your terrain's shape
        fogNoiseTexture = './textures/noise/noiseValue.webp', // noise texture for the fog
        displaceAmount = 0.2, // how much to displace the vertices of the plane using the noise
        noiseScrollSpeed = -0.03, // how muc the noise moves
        opacityMultiplier = 0.6, // additional opacity control
        useHeight = true,
        depth = './textures/noise/noiseValue.webp',
        fogParallaxAmt = 0.2,
        ...props
    },
    ref
) 
{

    const self = ref;

    depth = ( depth instanceof DepthTexture ) ? depth : useTexture( depth );

    useEffect( () =>
    {

        self.current.geometry.computeTangents();

    }, [] )

  return (
    <mesh ref={ self } { ...props }>
        <planeGeometry args={ [ terrainWidth, terrainHeight, subDivisions, subDivisions ] } />
        <TerrainFogMaterial
            terrainHeightMap={ terrainHeightMap }
            fogNoiseTexture={ fogNoiseTexture }
            displaceAmount={ displaceAmount }
            noiseScrollSpeed={ noiseScrollSpeed }
            useHeight={ useHeight }
            opacityMultiplier={ opacityMultiplier }
            depthText={ depth }
            fogParallaxAmt={ fogParallaxAmt }
        />
    </mesh>
  )
} )
