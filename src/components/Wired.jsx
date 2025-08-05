import { calculateBaryCoords } from "../calculateBaryCoords.js";
import WireframeMaterial from "../materials/meshWireframeMaterial.jsx"
import { IcosahedronGeometry } from "three"

export default function Wired() 
{
    const geo = new IcosahedronGeometry( 1, 4 );

    calculateBaryCoords( geo );



  return (
    <mesh geometry={ geo }>
        <WireframeMaterial
            lineWidth={ 3 }
            gradient={ true }
            color={ '#ca457b'} 
            backColor={ '#9fa1df' }
            gradientTop={ '#9fa1df' }
            gradientBottom={ '#ca457b' }
            brightness={ 2 }
            seeThrough={ true }
            colorBack={ true }
        />
    </mesh>
  )

}
