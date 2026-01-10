import { FadeMaterial } from "../materials/FadeMaterial"
import gsap from "gsap"
import { useEffect, useRef } from "react"

export default function ODSLogo(
    {
        size = 3
        ,
        ...props
    }
) 
{

  return (
    <mesh
        { ...props }
    >
        <planeGeometry args={[size, size]} />
        <FadeMaterial />
    </mesh>
  )
}
