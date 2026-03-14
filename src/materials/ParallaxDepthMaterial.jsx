import { shaderMaterial, useTexture } from '@react-three/drei'
import { extend, useFrame } from '@react-three/fiber'
import React, { useEffect, useRef } from 'react'
import vertex from '../shaders/parallax/vertex.glsl'
import fragment from '../shaders/parallax/fragment.glsl'
import { SRGBColorSpace } from 'three'

const CustomMaterial = shaderMaterial(
  {
    uTime: 0,
    uBaseImg: null,
    uDepthImg: null,
    uDepthOffset: 0.05
  },
  vertex,
  fragment
)

extend({ CustomMaterial })

export default function ParallaxDepthMaterial({
  baseImg = './textures/parallax/david.webp',
  depthImg = './textures/parallax/daviddepth.webp',
  ...props
}) {

  const self = useRef()

  const base = useTexture(baseImg)
  const depth = useTexture(depthImg)

  base.colorSpace = SRGBColorSpace

  useEffect(() => {
    if (!self.current) return

    self.current.uBaseImg = base
    self.current.uDepthImg = depth
  }, [base, depth])

  useFrame((state, delta) => {
    if (!self.current) return
    self.current.uTime += delta
  })

  return (
    <customMaterial
      ref={self}
      key={CustomMaterial.key}
      {...props}
    />
  )
}