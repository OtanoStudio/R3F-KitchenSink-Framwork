import ParallaxDepthMaterial from '../materials/ParallaxDepthMaterial.jsx';

export default function ParallaxDepth(
    {
        imageTxt = '',
        depthTxt = '',
        ...props
    }
) 
{


  return (
    <mesh>
      <planeGeometry args={[ 4, 4, 1, 1 ]} />
      <ParallaxDepthMaterial />
    </mesh>
  )

}
