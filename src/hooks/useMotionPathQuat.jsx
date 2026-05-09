import { useEffect, useMemo } from "react";

import {
  ClampToEdgeWrapping,
  DataTexture,
  FloatType,
  LinearFilter,
  NoColorSpace,
  Quaternion,
  RGBAFormat,
  Vector3
} from "three";

const current = new Vector3();
const next = new Vector3();

const tangent = new Vector3();

const forward = new Vector3(0, 0, 1);

const quaternion = new Quaternion();

export function useMotionPathQuat({

  shape = (t, target) => {
    target.set(t, 0, 0);
  },

  size = 512

}) {

  const textures = useMemo(() => {

    const positionData =
      new Float32Array(size * 4);

    const rotationData =
      new Float32Array(size * 4);

    const step = 1 / (size - 1);

    for(let i = 0; i < size; i++) {

      const t = i / (size - 1);

      shape(t, current);

      shape(
        Math.min(t + step, 1.0),
        next
      );

      tangent
        .subVectors(next, current)
        .normalize();

      quaternion.setFromUnitVectors(
        forward,
        tangent
      );

      const angle = Math.atan2(
        tangent.x,
        tangent.z
      );

      const stride = i * 4;

      positionData[stride + 0] = current.x;
      positionData[stride + 1] = current.y;
      positionData[stride + 2] = current.z;

      positionData[stride + 3] = angle;

      rotationData[stride + 0] =
        quaternion.x;

      rotationData[stride + 1] =
        quaternion.y;

      rotationData[stride + 2] =
        quaternion.z;

      rotationData[stride + 3] =
        quaternion.w;

    }

    const positionTexture =
      new DataTexture(
        positionData,
        size,
        1,
        RGBAFormat,
        FloatType
      );

    const rotationTexture =
      new DataTexture(
        rotationData,
        size,
        1,
        RGBAFormat,
        FloatType
      );

    [
      positionTexture,
      rotationTexture
    ].forEach((texture) => {

      texture.minFilter =
        LinearFilter;

      texture.magFilter =
        LinearFilter;

      texture.wrapS =
        ClampToEdgeWrapping;

      texture.wrapT =
        ClampToEdgeWrapping;

      texture.colorSpace =
        NoColorSpace;

      texture.needsUpdate = true;

    });

    return {
      positionTexture,
      rotationTexture
    };

  }, [shape, size]);

  useEffect(() => {

    return () => {

      textures.positionTexture.dispose();

      textures.rotationTexture.dispose();

    };

  }, [textures]);

  return textures;

}