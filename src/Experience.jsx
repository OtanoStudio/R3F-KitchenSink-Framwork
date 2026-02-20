
import { Vector3 } from "three"
import DigitalTrianglePortal from "./components/DigitalTrianglePortal"
import ODSLogo from "./components/ODSLogo"
import Grass from "./components/Grass"
//import GridLightColumns from "./components/GridLightColumns"


export default function Experience()
{


    return(

        <group
            position={[-0.8,0,0]}
        >
            {/* <DigitizePlane position={ [ 0, 0, 0 ] } digaDensity={ new Vector3( 0.1, 0.05, 0.025 )} />
            <ODSLogo position={ [ 0, 0, -0.03 ] } />
            <DigitizePlane position={[ 0, 0, -0.08 ]} digaDensity={ new Vector3( 0.1, 0.05, 0.025 )} /> */}
            {/* <DigitalTrianglePortal /> */}
            <Grass 
                position={[ 0, 0, 0]}
            />
            <Grass
                position={[ 0.6, 0, 0.1]}
            />
            <Grass
                position={[ 1.0, 0, 0.2]}
            />
            <Grass
                position={[ 1.4, 0, 0.3]}
            />

            <Grass 
                position={[ 0, 0, 0.2]}
            />
            <Grass
                position={[ 0.4, 0, 0.3]}
            />
            <Grass
                position={[ 0.8, 0, 0.4]}
            />
            <Grass
                position={[ 1.2, 0, 0.5]}
            />

            <Grass 
                position={[ 0, 0, 0.3]}
            />
            <Grass
                position={[ 0.4, 0, 0.4]}
            />
            <Grass
                position={[ 0.8, 0, 0.5]}
            />
            <Grass
                position={[ 1.2, 0, 0.6]}
            />

            <Grass 
                position={[ 0, 0, 0.4]}
            />
            <Grass
                position={[ 0.6, 0, 0.5]}
            />
            <Grass
                position={[ 1.0, 0, 0.6]}
            />
            <Grass
                position={[ 1.4, 0, 0.7]}
            />
        </group>
    
    )
    
}