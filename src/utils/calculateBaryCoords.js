import { BufferAttribute } from 'three';

export const calculateBaryCoords = (
     geometry
) => 
{

    const count = geometry.attributes.position.array.length;
    
    let b = []; // placeholder for barycentric coordinates

    // calculate barycentric coords
    for( let i = 0; i < count / 3; i++ )
    {
        b.push( 0, 0, 1, 0, 1, 0, 1, 0, 0 );
    }
    

    const bary = new Float32Array( b );

    geometry.setAttribute( 'baryCoords', new BufferAttribute( bary, 3 ) );

    return geometry;

}
