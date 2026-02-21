
import { Vector3 } from "three"
import DigitalTrianglePortal from "./components/DigitalTrianglePortal"
import ODSLogo from "./components/ODSLogo"
import GrassField from "./components/GrassField"
import { Text } from "@react-three/drei"
import { useFrame, useThree } from "@react-three/fiber"
import useMouse from './hooks/useMouse.jsx'
import gsap from "gsap"
//import GridLightColumns from "./components/GridLightColumns"


export default function Experience()
{

    const { x,y } = useMouse()

    const { scene } = useThree()

    gsap.to( scene.rotation,{
            y: gsap.utils.mapRange( 0, window.innerWidth, 0.05, -0.05, x ),
            x: gsap.utils.mapRange( 0, window.innerHeight, 0.05, -0.05, y)
        })

    return(

        <group>
            {/* <DigitizePlane position={ [ 0, 0, 0 ] } digaDensity={ new Vector3( 0.1, 0.05, 0.025 )} />
            <ODSLogo position={ [ 0, 0, -0.03 ] } />
            <DigitizePlane position={[ 0, 0, -0.08 ]} digaDensity={ new Vector3( 0.1, 0.05, 0.025 )} /> */}
            {/* <DigitalTrianglePortal /> */}
            <Text position-y={1.3} fontSize={ 1.7 } fillOpacity={0.8} characters="GRAS" font="./fonts/Betatron-Regular.otf">
                GRASS
            </Text>
            <GrassField />
            <mesh 
                rotation-x={ -90 * Math.PI / 180 }
                position-y={ -0.49 }
            >
                <planeGeometry args={[10, 10]} />
                <meshBasicMaterial color='#d2663b' />
            </mesh>
        </group>
    
    )
    
}