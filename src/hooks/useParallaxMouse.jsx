import { useRef } from 'react'
import { useFrame, useThree } from '@react-three/fiber'
import { Vector2 } from 'three'
import { lerp } from 'three/src/math/MathUtils.js'

export const useParallaxMouse = (smoothness = 0.1) => {
  const { viewport, mouse } = useThree()
  
  // 1. Setup refs for "current" values to avoid re-renders
  const current = useRef( new Vector2( 0, 0 ) );
  const target = useRef( new Vector2( 0, 0 ) );

  useFrame(() => 
  {

    target.current.set(
      (mouse.x * viewport.width) / 2,
      (mouse.y * viewport.height) / 2
    );

    current.current.x = lerp(
      current.current.x,
      target.current.x,
      smoothness
    );

    current.current.y = lerp(
      current.current.y,
      target.current.y,
      smoothness
    );

  })


  return current;

}