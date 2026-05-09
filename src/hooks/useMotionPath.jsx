import { useEffect, useMemo } from "react";

import {
  DataTexture,
  FloatType,
  RGBAFormat,
  LinearFilter,
  ClampToEdgeWrapping,
  NoColorSpace,
  Vector3
} from "three";

const current = new Vector3();
const next = new Vector3();
const tangent = new Vector3();

export function useMotionPath(
{

  shape = (t, target) => {
    target.set(t, 0, 0);
  },
  size = 512

}) 
{

const texture = useMemo( () => 
{

    const data = new Float32Array( size * 4 );

    const step = 1 / ( size - 1 );

    for( let i = 0; i < size; i++ ) {

        const t = i / ( size - 1 );

        shape(t, current);

        shape(
            Math.min( t + step, 1.0 ),
            next
        );

        tangent
            .subVectors( next, current )
            .normalize();

        const angle = Math.atan2(
            tangent.x,
            tangent.z
        );

        const stride = i * 4;

        data[ stride ] = current.x;
        data[ stride + 1 ] = current.y;
        data[ stride + 2 ] = current.z;
        data[ stride + 3 ] = angle;

        }

        const tex = new DataTexture(
        data,
        size,
        1,
        RGBAFormat,
        FloatType
        );

        tex.minFilter = LinearFilter;
        tex.magFilter = LinearFilter;

        tex.wrapS = ClampToEdgeWrapping;
        tex.wrapT = ClampToEdgeWrapping;

        tex.colorSpace = NoColorSpace;

        tex.needsUpdate = true;

        return tex;

    }, [ shape, size ]);

    useEffect(() => 
    {

        return () => 
        {
            texture.dispose();
        };

  }, [texture]);

  return texture;

}