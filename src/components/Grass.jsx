import { DoubleSide, MultiplyBlending } from "three";
import GrassMaterial from "../materials/GrassMaterial";

export default function Grass() 
{
    return (
        <mesh>
            <planeGeometry
                args={ [ 1.3, 1.5, 1, 5 ] }
            />
            <GrassMaterial
            
            transparent={ true }
            side={ DoubleSide }
            blend={ MultiplyBlending }
            />
        </mesh>
    )
}
