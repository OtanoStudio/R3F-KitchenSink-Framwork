import { FadeMaterial } from "../materials/FadeMaterial"

export default function ODSLogo(
    {
        size = 3
        ,
        ...props
    }
) 
{
  return (
    <mesh
        { ...props }
    >
        <planeGeometry args={[size, size]} />
        <FadeMaterial />
    </mesh>
  )
}
