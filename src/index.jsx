import './style.css'
import ReactDOM from 'react-dom/client'
import { Canvas } from '@react-three/fiber'
import GrassUI from './components/GrassUI.jsx'
import Experience from './Experience.jsx'
import { OrbitControls } from '@react-three/drei'
import { Bloom, EffectComposer } from '@react-three/postprocessing'
import { Perf } from 'r3f-perf'



const root = ReactDOM.createRoot(document.querySelector('#root'))

root.render(
    <div className='webgl-container'>
        {/* <GrassUI /> */}
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
    >   <OrbitControls makeDefault />
        {/* <Perf /> */}
        <Experience />
        {/* <EffectComposer>
            <Bloom luminanceThreshold={0} luminanceSmoothing={0.9} mipmapBlur />
        </EffectComposer> */}
    </Canvas>
    </div>
)