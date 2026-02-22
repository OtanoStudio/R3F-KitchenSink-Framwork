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
import { extend, useFrame } from "@react-three/fiber"
import { useRef, useEffect } from "react"
import {
  RepeatWrapping,
  Color,
  SRGBColorSpace,
  MultiplyBlending,
  AdditiveBlending,
  NormalBlending,
  DoubleSide
} from "three"

import vertex from "../shaders/grass/vertex.glsl"
import fragment from "../shaders/grass/fragment.glsl"

/* ---------- MATERIAL DEFINITION OUTSIDE COMPONENT ---------- */

const GrassMaterialImpl = shaderMaterial(
  {
    uTime: 0,
    uNoiseTexture: null,
    uGrassTexture: null,
    uColorMap: null
  },
  vertex,
  fragment
)

extend({ GrassMaterialImpl })

/* ---------- COMPONENT ---------- */

export default function GrassMaterial({
  texture = "./textures/noise/noiseWind.webp",
  grassTexture = "./textures/tiles/grass/grass3.webp",
  grassColorMap = "./textures/gradientmaps/grasssunset.webp",
  ...props
}) {
  const materialRef = useRef()

  const noise = useTexture(texture)
  noise.wrapS = noise.wrapT = RepeatWrapping
  const grass = useTexture(grassTexture)
  const colorMap = useTexture(grassColorMap)
  colorMap.colorSpace = SRGBColorSpace

  useEffect(() => {
    
    materialRef.current.uNoiseTexture = noise
    materialRef.current.uGrassTexture = grass
    materialRef.current.uColorMap = colorMap

  }, [ noise, grass ])

  useFrame((_, delta) => {
    materialRef.current.uTime += delta
  })

  return (
    <grassMaterialImpl
      ref={materialRef}
      alphaTest={ 0.1 }
      {...props}
    />
  )
}