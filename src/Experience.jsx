
import { Vector3 } from "three"
import DigitalTrianglePortal from "./components/DigitalTrianglePortal"
import ODSLogo from "./components/ODSLogo"
import GrassField from "./components/GrassField"
//import GridLightColumns from "./components/GridLightColumns"


export default function Experience()
{


    return(

        <group>
            {/* <DigitizePlane position={ [ 0, 0, 0 ] } digaDensity={ new Vector3( 0.1, 0.05, 0.025 )} />
            <ODSLogo position={ [ 0, 0, -0.03 ] } />
            <DigitizePlane position={[ 0, 0, -0.08 ]} digaDensity={ new Vector3( 0.1, 0.05, 0.025 )} /> */}
            {/* <DigitalTrianglePortal /> */}
            <GrassField />
            <mesh 
                rotation-x={ -90 * Math.PI / 180 }
                position-y={ -0.75 }
            >
                <planeGeometry args={[6,6]} />
                <meshBasicMaterial color='#d2663b' />
            </mesh>
        </group>
    
    )
    
}