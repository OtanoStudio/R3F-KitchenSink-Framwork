import React, { forwardRef, useMemo, useLayoutEffect } from 'react';
import { DualKawaseBloomEffect } from '../utils/DualKawaseBloomEffect.js';

export const DualKawaseBloom = forwardRef( function DualKawaseBloom(
  {
    resolutionScale = 'quarter', // 'quarter' (0.25, default) or 'half' (0.5)
    strength = 1.0,
    radius = 1.0,
    threshold = 0.8,
    pyramidLevels = 4
  },
  ref
) 
{

  const effect = useMemo(
    () =>
      new DualKawaseBloomEffect({
        resolutionScale,
        strength,
        radius,
        threshold,
        pyramidLevels
      }),
    [resolutionScale, strength, radius, threshold, pyramidLevels]
  );

  useLayoutEffect(() => {
    return () => effect.dispose();
  }, [effect]);

  return <primitive ref={ref} object={effect} dispose={null} />;

});