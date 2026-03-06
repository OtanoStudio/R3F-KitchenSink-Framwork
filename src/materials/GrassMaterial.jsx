// import { shaderMaterial, useTexture } from '@react-three/drei'
// import { extend, useFrame } from '@react-three/fiber'
// import { useRef } from 'react'
// import vertex from '../shaders/grass/vertex.glsl'
// import fragment from '../shaders/grass/fragment.glsl'
// import { RepeatWrapping, Vector2, Color, Vector3, SRGBColorSpace } from 'three'

// export default function GrassMaterial( {
//     texture ='./textures/noise/noiseValue_albedo60.webp',
//     grassTexture ='./textures/tiles/grass/grass3.webp',
//     colorTip = '#9ae37d',
//     colorBase = '#154406',
//     grassColorMap = './textures/gradientmaps/grassblu.webp',
//     ...props
// } ) 
// {
//     const self = useRef()

//     const noise = useTexture( texture )
//     noise.wrapS = RepeatWrapping
//     noise.wrapT = RepeatWrapping

//     const textureGrass = useTexture( grassTexture )

//     const phaseOffset = Math.random() * Math.PI * 2

//     const colorMap = useTexture( grassColorMap )
//     colorMap.colorSpace = SRGBColorSpace

//     const uniforms =
//     {

//         uTime: 0,
//         uNoiseTexture: noise,
//         uGrassTexture: textureGrass,
//         uTipColor: new Color( colorTip ),
//         uBaseColor: new Color( colorBase ),
//         uPhase: phaseOffset,
//         uColorMap: colorMap,

//     }

//     useFrame( ( state, delta ) =>
//     {
//         self.current.uniforms.uTime.value += delta
//     })

//     const GrassMaterial = shaderMaterial( uniforms, vertex, fragment )
//     extend( { GrassMaterial } )

//     return (
//         <grassMaterial
//             key={ GrassMaterial.key }
//             ref={ self }
//             {...props}
//         />
//     )
// }

// GrassMaterial.jsx

import { shaderMaterial, useTexture } from "@react-three/drei"
import { extend, useFrame, useThree } from "@react-three/fiber"
import { useRef, useEffect } from "react"
import {
  RepeatWrapping,
  Color,
  SRGBColorSpace,
  MultiplyBlending,
  AdditiveBlending,
  NormalBlending,
  DoubleSide,
  LinearMipMapLinearFilter,
  NearestFilter,
  LinearFilter,
  NoBlending
} from "three"

import vertex from "../shaders/grass/vertex.glsl"
import fragment from "../shaders/grass/fragment.glsl"

/* ---------- MATERIAL DEFINITION OUTSIDE COMPONENT ---------- */

const GrassMaterialImpl = shaderMaterial(
  {
    uTime: 0,
    uNoiseTexture: null,
    uColorMap: null,
    uGrassAtlas: null,
    uVelocityTexture: null,
    uCamInverseMatrix: null,
  },
  vertex,
  fragment
)

extend({ GrassMaterialImpl })

/* ---------- COMPONENT ---------- */

export default function GrassMaterial({
  texture = "./textures/noise/noiseWind.webp",
  velocityTexture = './textures/noise/noiseFBM.webp',
  grassColorMap = "./textures/gradientmaps/grassocean.webp",
  grassTextureAtlas = './textures/tiles/grass/grassAtlasHanddrawn.webp',
  ...props
}) {
  const materialRef = useRef()

  const noise = useTexture(texture)
  noise.wrapS = noise.wrapT = RepeatWrapping
  const colorMap = useTexture(grassColorMap)
  colorMap.colorSpace = SRGBColorSpace
  const grassAtlas = useTexture( grassTextureAtlas )
  grassAtlas.colorSpace =SRGBColorSpace
  grassAtlas.minFilter = grassAtlas.magFilter = LinearFilter
  grassAtlas.generateMipmaps = false
  const windVelocity = useTexture( velocityTexture )
  windVelocity.wrapS = windVelocity.wrapT = RepeatWrapping
  const { camera } = useThree()
  const camInvMat = camera.matrixWorldInverse

  useEffect(() => {
    
    materialRef.current.uNoiseTexture = noise
    materialRef.current.uColorMap = colorMap
    materialRef.current.uGrassAtlas = grassAtlas
    materialRef.current.uVelocityTexture = windVelocity
    materialRef.current.uCamInverseMatrix = camInvMat

  }, [ noise, grassAtlas, colorMap ])

  useFrame((_, delta) => {
    materialRef.current.uTime += delta
  })

  return (
    <grassMaterialImpl
      ref={materialRef}
      toneMapped={ false }
      transparent
      depthWrite={ true }
      alphaTest={ 0.4 }
      blend={ NoBlending }
      {...props}
    />
  )
}