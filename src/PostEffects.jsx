import { EffectComposer } from "@react-three/postprocessing"
import { FogGradient } from "./postprocessing/FogGradient"
import { useTexture } from "@react-three/drei";
import { useThree } from "@react-three/fiber";
import { SRGBColorSpace, Matrix4 } from "three";

export default function PostEffects() 
{

    const gradientColor = useTexture( './textures/gradientmaps/fog/fogStylish3.png' );
    gradientColor.colorSpace = SRGBColorSpace;
    const { camera } = useThree();
    const invProjViewMat = new Matrix4().multiplyMatrices( camera.projectionMatrix, camera.matrixWorldInverse );

    return (
        <EffectComposer>
            <FogGradient
                invMat={ invProjViewMat }
                gradientMap={ gradientColor }
                start={ 2 }
                end={ 9 }
                density={ 2.5 }
                fogType={ 3 }
                spread={ 1.0 }
                clip={ false }
                heightEnd={ 0.1 - 0.03 } 
            />
        </EffectComposer>
    )

}
