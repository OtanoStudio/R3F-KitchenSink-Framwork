
import { Vector3 } from "three"
import DigitalTrianglePortal from "./components/DigitalTrianglePortal"
import ODSLogo from "./components/ODSLogo"
import GrassField from "./components/GrassField"
import { Text } from "@react-three/drei"
import { useFrame, useThree } from "@react-three/fiber"
import useMouse from './hooks/useMouse.jsx'
import gsap from "gsap"
import { useEffect, useMemo } from "react"
//import GridLightColumns from "./components/GridLightColumns"


export default function Experience()
{

    // const { x,y } = useMouse()

    // const { scene, size } = useThree()

    // let fontSize = 1.7

    // if( size.width < 640 )
    // {
    //     fontSize = 0.33
    // }
    // if( size.width < 1024 )
    // {
    //     fontSize = 0.73
    // }

    // gsap.to( scene.rotation,{
    //         y: gsap.utils.mapRange( 0, window.innerWidth, 0.05, -0.05, x ),
    //         x: gsap.utils.mapRange( 0, window.innerHeight, 0.05, -0.05, y)
    //     })



    return(

        <group>
            {/* <DigitizePlane position={ [ 0, 0, 0 ] } digaDensity={ new Vector3( 0.1, 0.05, 0.025 )} />
            <ODSLogo position={ [ 0, 0, -0.03 ] } />
            <DigitizePlane position={[ 0, 0, -0.08 ]} digaDensity={ new Vector3( 0.1, 0.05, 0.025 )} /> */}
            {/* <DigitalTrianglePortal /> */}
            
            <GrassField />
            <mesh 
                rotation-x={ -90 * Math.PI / 180 }
                position-y={ -0.49 }
            >
                <planeGeometry args={[10, 10]} />
                <meshBasicMaterial color='#5e3958' />
            </mesh>
        </group>
    
    )
    
}