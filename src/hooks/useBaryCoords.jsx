import React from 'react'
import { BufferAttribute } from 'three';

export const useBaryCoords = ({
     geometry,
     ...props 
}) => 
{

    const count = geometry?.attributes?.position?.count || 0;
    const baryCoords = count > 0 ? new Float32Array(count * 3) : null;
    const baryCoordsAttribute = new BufferAttribute( baryCoords, 3 );

    // calculate barycentric coords

    //

    if( baryCoords != null )
    {
            geometry.setAttribute( 'baryCoords', baryCoordsAttribute );
    }

  return geometry;

}
