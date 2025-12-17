
import { DigitizePlane } from "./components/DigitizePlane"
import ODSLogo from "./components/ODSLogo"


export default function Experience()
{


    return(
        <group>
            <DigitizePlane />
            <ODSLogo position={[0,0,-0.01]} />
        </group>
    )
    
}