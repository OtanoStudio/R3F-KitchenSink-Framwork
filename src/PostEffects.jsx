import { EffectComposer } from "@react-three/postprocessing"
import { DualKawaseBloom } from './postprocessing/DualKawaseBlur.jsx'

export default function PostEffects() 
{

    return (
        <EffectComposer>
            
            <DualKawaseBloom 
                resolutionScale="quarter"
                strength={ 5 }
                radius={ 2.4 }
                threshold={ 0.4 }
            />

        </EffectComposer>
    )

}
