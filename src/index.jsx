import './style.css'
import ReactDOM from 'react-dom/client'
import { Canvas } from '@react-three/fiber'
import GrassUI from './components/GrassUI.jsx'
import Experience from './Experience.jsx'
import { OrbitControls, useTexture } from '@react-three/drei'
import { Bloom, EffectComposer } from '@react-three/postprocessing'
import { Perf } from 'r3f-webgpu-perf'
import { FogGradient } from './postprocessing/FogGradient.jsx'
import { TextureLoader } from 'three'
import { AdditiveBlending, MultiplyBlending, SRGBColorSpace } from 'three/src/constants.js'



const root = ReactDOM.createRoot(document.querySelector('#root'))
const gradientColor = new TextureLoader().load( './textures/gradientmaps/fog/fogStylish3.png' );
gradientColor.colorSpace = SRGBColorSpace;

root.render(
    <div className='webgl-container'>
        <GrassUI />
    <Canvas
        camera={ {
            fov: 45,
            near: 1,
            far: 1000,
            position: [ 0, 1, 6 ]
        } }

        gl={{
            antialias: true,
            alpha: true,
        }}
    >   
    {/* <OrbitControls makeDefault /> */}
        {/* <fogExp2
            attach="fog"
            args={['#282828', 0.0015]}
        /> */}
        {/* <Perf /> */}
        <Perf />
        <Experience />
        <EffectComposer>
            {/* <Bloom luminanceThreshold={0} luminanceSmoothing={0.9} mipmapBlur /> */}
            <FogGradient
                gradientMap={ gradientColor }
                start={ 0 }
                end={ 15 }
                density={ 2.5 }
                fogType={ 3 }
                spread={ 1.0 }
                clip={ false } 
            />
        </EffectComposer>
    </Canvas>
    </div>
)