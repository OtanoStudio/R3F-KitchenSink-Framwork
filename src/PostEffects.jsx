import { EffectComposer } from "@react-three/postprocessing"
import { FogGradient } from "./postprocessing/FogGradient"
import { useTexture } from "@react-three/drei";
import { useThree } from "@react-three/fiber";
import { SRGBColorSpace, Matrix4, RepeatWrapping } from "three";

export default function PostEffects() 
{

    const [gradientColor, heightTexture ] = useTexture( ['./textures/gradientmaps/fog/fogStylish3.png', './textures/noise/noisePerlinWind.webp' ] );
    gradientColor.colorSpace = SRGBColorSpace;
    heightTexture.wrapS = heightTexture.wrapT = RepeatWrapping;
    const { camera } = useThree();

    return (
        <EffectComposer>
            <FogGradient
                camera={ camera }
                gradientMap={ gradientColor }
                heightNoiseTexture={ heightTexture }
                start={ 2 }
                end={ 7 }
                density={ 2.5 }
                fogType={ 3 }
                spread={ 1.0 }
                clip={ false }
                heightEnd={ 40 } 
            />
        </EffectComposer>
    )

}
