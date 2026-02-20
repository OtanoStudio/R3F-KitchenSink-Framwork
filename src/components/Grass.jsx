import { DoubleSide, MultiplyBlending, NormalBlending } from "three";
import GrassMaterial from "../materials/GrassMaterial";

export default function Grass( props ) 
{
    return (
        <mesh { ...props }>
            <planeGeometry
                args={ [ 1.3, 1.5, 1, 5 ] }
            />
            <GrassMaterial
            
            transparent
            alphaTest={ 0.5 }
            side={ DoubleSide }
            blend={ NormalBlending }
            depthTest
            depthWrite
            toneMapped={ false }
            />
        </mesh>
    )
}
