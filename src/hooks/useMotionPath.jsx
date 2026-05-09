// Generate a data texture as a motion path for animation

import { useEffect, useMemo } from "react";
import { Vector4 } from "three";
import { ClampToEdgeWrapping, 
    DataTexture, 
    FloatType, 
    LinearFilter, 
    NoColorSpace, 
    RGBAFormat } from "three/src/constants.js";


export function useMotionPath({
    shape = ( t ) =>{
        return new Vector4( Math.sin( t ) * 0.3, 0, 0, 0 );
    },
    size = 512
})
{
    
    const motionCurve = useMemo( () =>
    {

        const data = new Float32Array( size * 4 );

        for( let i = 0; i < size; i++ )
        {

            const t = i / ( size - 1 );
            const point = shape( t );

            const index = i * 4;

            data[ index ] = point.x;
            data[ index + 1 ] = point.y;
            data[ index + 2 ] = point.z;
            data[ index + 3 ] = point.w ?? 0;

        }

        const motionTexture = new DataTexture( data, size, 1, RGBAFormat, FloatType );
        motionTexture.magFilter = LinearFilter;
        motionTexture.minFilter = LinearFilter;
        motionTexture.wrapS = motionTexture.wrapT = ClampToEdgeWrapping;
        motionTexture.colorSpace = NoColorSpace;
        motionTexture.needsUpdate = true;

        return motionTexture;
    }, [ shape, size ] );

    useEffect( () =>
    {

        return () =>
        {
            motionCurve.dispose();
        }

    }, [ motionCurve ])

    return motionCurve;

}