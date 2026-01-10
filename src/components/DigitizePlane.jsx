import { Vector3 } from "three"
import { useFrame } from "@react-three/fiber"
import { useRef } from "react"
import { DigitizeMaterial } from "../materials/DigitizeMaterial"


export function DigitizePlane( {
    size = 4, //size of the plane
    ...props
} )
{
    const self = useRef()

    return (
        <mesh
            ref={ self }
            { ...props }
        >
            <planeGeometry args={ [ size,size ] } />
            <DigitizeMaterial
                colorIntensity={ new Vector3( 2, 1, 4 )}
                digaDensity={ new Vector3( 0.1, 0.075, 0.025 ) }
            />
        </mesh>
    )
}