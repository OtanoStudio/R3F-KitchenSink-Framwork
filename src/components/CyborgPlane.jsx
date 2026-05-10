import React, { useRef, useMemo } from 'react'
import { Canvas, useFrame, useThree, extend } from '@react-three/fiber'
import { useTexture, shaderMaterial, Center } from '@react-three/drei'
import * as THREE from 'three'

// 1. Define the Shader Material using your parallax logic
const ParallaxMaterial = shaderMaterial(
  {
    uImage: null,
    uDepth: null,
    uMouse: new THREE.Vector2(0, 0),
    uIntensity: 0.05,
  },
  // Vertex Shader
  `
  varying vec2 vUv;
  void main() {
    vUv = uv;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
  }
  `,
  // Fragment Shader
  `
  uniform sampler2D uImage;
  uniform sampler2D uDepth;
  uniform vec2 uMouse;
  uniform float uIntensity;
  varying vec2 vUv;

  // Your customized parallax function
  vec4 parallaxImage(sampler2D color, sampler2D depthText, vec2 uv, vec2 mouseCoords, float intensity) {
      vec3 depthSample = texture2D(depthText, uv).rgb;
      
      // Luminance dot product for high-precision depth mapping
      float depth = dot(depthSample, vec3(0.299, 0.587, 0.114));

      vec2 displacement = mouseCoords * depth * intensity;
      return texture2D(color, uv + displacement);
  }

  void main() {
    gl_FragColor = parallaxImage(uImage, uDepth, vUv, uMouse, uIntensity);
  }
  `
)

extend({ ParallaxMaterial })

export const CyborgPlane = () => {
  const meshRef = useRef()
  const { mouse } = useThree()
  
  // 2. Load your provided images
  const [tex, depth] = useTexture([
    './images/parallax/character.png', // The color cyborg image
    './images/parallax/grayscale.png'  // The depth mask image
  ])

  // Set textures to LinearFilter for smooth sub-pixel movement
  useMemo(() => {
    [tex, depth].forEach(t => {
      t.minFilter = THREE.LinearFilter;
      t.magFilter = THREE.LinearFilter;
    })
  }, [tex, depth])

  // 3. Update mouse uniforms with lerping for "weighty" feel
  useFrame((state) => {
    if (!meshRef.current) return
    
    // Smoothly interpolate towards the target mouse position
    // R3F mouse is already -1 to +1, we map to ~ -0.5 to 0.5
    const targetX = mouse.x * 0.25
    const targetY = mouse.y * 0.25
    
    const uMouse = meshRef.current.material.uniforms.uMouse.value
    uMouse.x += (targetX - uMouse.x) * 0.1
    uMouse.y += (targetY - uMouse.y) * 0.1
  })

  return (
    <mesh ref={meshRef} scale={[1.1, 1.1, 1]}> 
      {/* Plane sized to match the cyborg image aspect ratio */}
      <planeGeometry args={[16, 9]} />
      <parallaxMaterial 
        uImage={tex} 
        uDepth={depth} 
        uIntensity={0.043} // Adjust for more/less pop
        transparent
      />
    </mesh>
  )
}