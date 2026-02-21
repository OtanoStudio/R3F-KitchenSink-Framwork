import './style.css'
import ReactDOM from 'react-dom/client'
import { Canvas } from '@react-three/fiber'
import Experience from './Experience.jsx'
import { OrbitControls } from '@react-three/drei'
import { Bloom, EffectComposer } from '@react-three/postprocessing'



const root = ReactDOM.createRoot(document.querySelector('#root'))

root.render(
    <div className='webgl-container'>

    <Canvas
        camera={ {
            fov: 45,
            near: 1,
            far: 100,
            position: [ 0, 3, 14 ]
        } }

        gl={{
            antialias: true,
            alpha: true,
        }}
    >   
        <OrbitControls makeDefault />
        <Experience />
        {/* <EffectComposer>
            <Bloom luminanceThreshold={0} luminanceSmoothing={0.9} mipmapBlur />
        </EffectComposer> */}
    </Canvas>
    </div>
)