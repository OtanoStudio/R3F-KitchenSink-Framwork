import * as THREE from 'three'
import { useThree, useFrame } from '@react-three/fiber'
import { useFBO } from '@react-three/drei'
import { useMemo, useRef, useEffect } from 'react'
 
const SIM_VERTEX = `
varying vec2 vUv;
void main() {
  vUv = uv;
  gl_Position = vec4(position, 1.0);
}
`
 
const SIM_FRAGMENT = `
uniform sampler2D uTexture;
uniform vec2 uMouse;
uniform vec2 uVelocity;
uniform vec2 uResolution;
uniform float uRadius;
uniform float uStrength;
uniform float uDamping;
varying vec2 vUv;
 
void main() {
  vec4 prev = texture2D(uTexture, vUv) * uDamping;
 
  vec2 aspect = vec2(uResolution.x / uResolution.y, 1.0);
  float dist  = length((vUv - uMouse) * aspect);
  float stamp = smoothstep(uRadius, 0.0, dist) * uStrength;
 
  vec2 packedVelocity = uVelocity * 0.5 + 0.5;
 
  vec4 drawData = vec4(
    stamp,
    packedVelocity.x * stamp,
    packedVelocity.y * stamp,
    stamp
  );
 
  gl_FragColor = max(prev, drawData);
}
`
 
export function useMouseTrail({
  resolution   = 512,
  radius       = 0.15,
  strength     = 1.0,
  damping      = 0.96,
  lerpStrength = 10,
} = {}) {
 
  const { gl, size, viewport, pointer } = useThree()
 
  const scene  = useMemo(() => new THREE.Scene(), [])
  const camera = useMemo(() =>
    new THREE.OrthographicCamera(-1, 1, 1, -1, 0, 1), [])
 
  const fboOpts = {
    type:          THREE.HalfFloatType,
    format:        THREE.RGBAFormat,
    minFilter:     THREE.LinearFilter,
    magFilter:     THREE.LinearFilter,
    depthBuffer:   false,
    stencilBuffer: false,
  }
 
  const targetA = useFBO(resolution, resolution, fboOpts)
  const targetB = useFBO(resolution, resolution, fboOpts)
 
  const read  = useRef(targetA)
  const write = useRef(targetB)
 
  const textureRef = useRef(targetA.texture)
 
  const targetMouse  = useRef(new THREE.Vector2(0.5, 0.5))
  const currentMouse = useRef(new THREE.Vector2(0.5, 0.5))
  const prevMouse    = useRef(new THREE.Vector2(0.5, 0.5))
  const velocity     = useRef(new THREE.Vector2())
 
  const material = useMemo(() => new THREE.ShaderMaterial({
    uniforms: {
      uTexture:    { value: null },
      uMouse:      { value: new THREE.Vector2() },
      uVelocity:   { value: new THREE.Vector2() },
      uResolution: { value: new THREE.Vector2(size.width, size.height) },
      uRadius:     { value: radius },
      uStrength:   { value: strength },
      uDamping:    { value: damping },
    },
    vertexShader:   SIM_VERTEX,
    fragmentShader: SIM_FRAGMENT,
  }), [])
 
  const quad = useMemo(() => {
    const mesh = new THREE.Mesh(new THREE.PlaneGeometry(2, 2), material)
    scene.add(mesh)
    return mesh
  }, [])
 
  useEffect(() => () => {
    quad.geometry.dispose()
    material.dispose()
  }, [])
 
    useFrame((_, delta) =>
    {
        targetMouse.current.set(
        pointer.x *  0.5 + 0.5,
        pointer.y * -0.5 + 0.5
    )
 
    const alpha = 1.0 - Math.exp(-lerpStrength * delta)
    currentMouse.current.lerp(targetMouse.current, alpha)
 
    velocity.current.subVectors(currentMouse.current, prevMouse.current)
 
    material.uniforms.uTexture.value = read.current.texture
    material.uniforms.uMouse.value.copy(currentMouse.current)
    material.uniforms.uVelocity.value.copy(velocity.current)
    material.uniforms.uResolution.value.set(size.width, size.height)
 
    gl.setRenderTarget(write.current)
    gl.render(scene, camera)
    gl.setRenderTarget(null)
 
    const tmp     = read.current
    read.current  = write.current
    write.current = tmp

    textureRef.current = read.current.texture
 
    prevMouse.current.copy(currentMouse.current)
  })
 
  return {
    textureRef,
    mouse:       currentMouse,
    targetMouse: targetMouse,
    velocity:    velocity,
    viewport,
    size,
  }
}