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

// import { shaderMaterial, useTexture } from "@react-three/drei"
// import { extend, useFrame, useThree } from "@react-three/fiber"
// import { useRef, useEffect } from "react"
// import {
//   RepeatWrapping,
//   Color,
//   SRGBColorSpace,
//   MultiplyBlending,
//   AdditiveBlending,
//   NormalBlending,
//   DoubleSide,
//   LinearMipMapLinearFilter,
//   NearestFilter,
//   LinearFilter,
//   NoBlending
// } from "three"

// import vertex from "../shaders/grass/vertex.glsl"
// import fragment from "../shaders/grass/fragment.glsl"

// /* ---------- MATERIAL DEFINITION OUTSIDE COMPONENT ---------- */

// const GrassMaterialImpl = shaderMaterial(
//   {
//     uTime: 0,
//     uNoiseTexture: null,
//     uColorMap: null,
//     uGrassAtlas: null,
//     uVelocityTexture: null,
//     uCamInverseMatrix: null,
//   },
//   vertex,
//   fragment
// )

// extend({ GrassMaterialImpl })

// /* ---------- COMPONENT ---------- */

// export default function GrassMaterial({
//   texture = "./textures/noise/noisePerlinWind.webp",
//   velocityTexture = './textures/noise/noiseWindTurbulence.webp',
//   grassColorMap = "./textures/gradientmaps/grassocean.webp",
//   grassTextureAtlas = './textures/tiles/grass/grassAtlasHanddrawn.webp',
//   ...props
// }) {
//   const materialRef = useRef()

//   const noise = useTexture(texture)
//   noise.wrapS = noise.wrapT = RepeatWrapping
//   noise.minFilter = noise.magFilter = LinearFilter
//   const colorMap = useTexture(grassColorMap)
//   colorMap.colorSpace = SRGBColorSpace
//   const grassAtlas = useTexture( grassTextureAtlas )
//   grassAtlas.colorSpace =SRGBColorSpace
//   grassAtlas.minFilter = grassAtlas.magFilter = LinearFilter
//   grassAtlas.generateMipmaps = false
//   const windVelocity = useTexture( velocityTexture )
//   windVelocity.wrapS = windVelocity.wrapT = RepeatWrapping
//   windVelocity.minFilter = windVelocity.magFilter = LinearFilter
//   const { camera } = useThree()
//   const camInvMat = camera.matrixWorldInverse

//   useEffect(() => {
    
//     materialRef.current.uNoiseTexture = noise
//     materialRef.current.uColorMap = colorMap
//     materialRef.current.uGrassAtlas = grassAtlas
//     materialRef.current.uVelocityTexture = windVelocity
//     materialRef.current.uCamInverseMatrix = camInvMat

//   }, [ noise, grassAtlas, colorMap ])

//   useFrame((_, delta) => {
//     materialRef.current.uTime += delta
//   })

//   return (
//     <grassMaterialImpl
//       ref={materialRef}
//       toneMapped={ false }
//       transparent
//       depthWrite={ true }
//       alphaTest={ 0.4 }
//       blend={ NoBlending }
//       {...props}
//     />
//   )
// }

// gemini test

import { shaderMaterial, useTexture } from "@react-three/drei"
import { extend, useFrame, useThree } from "@react-three/fiber"
import { useRef, useEffect, forwardRef, useImperativeHandle } from "react"
import { RepeatWrapping, SRGBColorSpace, LinearFilter, Vector2, Vector3, Matrix2, NoBlending } from "three"

import vertex from "../shaders/grass/vertex.glsl"
import fragment from "../shaders/grass/fragment.glsl"

const GrassMaterialImpl = shaderMaterial(
  {
    uTime: 0,
    uNoiseTexture: null,
    uVelocityTexture: null,
    uColorMap: null,
    uGrassAtlas: null,
    uCamInverseMatrix: null,
    
    uWindDirection: new Vector2(1.0, 0.35),
    uVelocity: new Vector2(0.18, 0.08),
    uWindMultiplier: 0.8,
    uWindOffset: 0.3,
    uLiftOffset: 0.25,
    uDomainOffset: 0.45,
    uSwayMultiplier: new Vector2(1.0, 0.35),
    uBendStiffness: 3.0,
    uGustModifiers: new Vector3(0.35, 0.6, 2.0),
    uGustBlend: new Vector2(0.3, 2.5),
    uGustTurbulence: new Vector2(1.0, 0.4),
    uTerrainWave: new Vector3(0.15, 0.45, 0.4),
    uPrecalculatedRot: new Matrix2() // Registered Matrix Uniform
  },
  vertex,
  fragment
)

extend({ GrassMaterialImpl })

const GrassMaterial = forwardRef(({
  texture = "./textures/noise/noiseWindBase.webp",
  velocityTexture = './textures/noise/noiseWindVelocity.webp',
  grassColorMap = "./textures/gradientmaps/grassocean.webp",
  grassTextureAtlas = './textures/tiles/grass/grassAtlasHanddrawn.webp',
  ...props
}, ref) => {
  const materialRef = useRef()

  const noise = useTexture(texture)
  noise.wrapS = noise.wrapT = RepeatWrapping
  noise.minFilter = noise.magFilter = LinearFilter

  const windVelocity = useTexture(velocityTexture)
  windVelocity.wrapS = windVelocity.wrapT = RepeatWrapping
  windVelocity.minFilter = windVelocity.magFilter = LinearFilter

  const colorMap = useTexture(grassColorMap)
  colorMap.colorSpace = SRGBColorSpace

  const grassAtlas = useTexture(grassTextureAtlas)
  grassAtlas.colorSpace = SRGBColorSpace
  grassAtlas.minFilter = grassAtlas.magFilter = LinearFilter
  grassAtlas.generateMipmaps = false

  const { camera } = useThree()
  const camInvMat = camera.matrixWorldInverse

  useImperativeHandle(ref, () => materialRef.current)

  useEffect(() => {
    if (!materialRef.current) return
    materialRef.current.uNoiseTexture = noise
    materialRef.current.uVelocityTexture = windVelocity
    materialRef.current.uColorMap = colorMap
    materialRef.current.uGrassAtlas = grassAtlas
    materialRef.current.uCamInverseMatrix = camInvMat
  }, [noise, windVelocity, grassAtlas, colorMap, camInvMat])

  useFrame((_, delta) => {
    if (materialRef.current) {
      materialRef.current.uTime += delta
    }
  })

  return (
    <grassMaterialImpl
      ref={materialRef}
      toneMapped={false}
      transparent
      depthWrite={true}
      alphaTest={0.4}
      blend={NoBlending}
      {...props}
    />
  )
})

export default GrassMaterial