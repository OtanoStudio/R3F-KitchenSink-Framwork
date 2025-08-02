import WireframeMaterial from "../materials/meshWireframeMaterial.jsx"
import { IcosahedronGeometry, BufferAttribute, DoubleSide  } from "three"

export default function Wired() 
{
    const geo = new IcosahedronGeometry( 1, 1 );

    const geoCount = geo.attributes.position.array.length;

    let b = [];
    

    for( let i = 0; i < geoCount / 3; i++ )
    {
        b.push( 0, 0, 1, 0, 1, 0, 1, 0, 0 );
    }
    

    const bary = new Float32Array( b );

    geo.setAttribute( 'baryCoords', new BufferAttribute( bary, 3 ) );

  return (
    <mesh geometry={ geo }>
        <WireframeMaterial
            lineWidth={ 1.3 } 
            gradient={ true }
            gradientTop={ '#9fa1df' }
            gradientBottom={ '#ca457b' }
            brightness={ 2 }
            seeThrough={ true}
        />
    </mesh>
  )

}
