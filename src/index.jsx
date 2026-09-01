import './style.css'
import ReactDOM from 'react-dom/client'
import { Canvas } from '@react-three/fiber'
import GrassUI from './components/GrassUI.jsx'
import Experience from './Experience.jsx'
import { OrbitControls } from '@react-three/drei'
import { Perf } from 'r3f-webgpu-perf'
import PostEffects from './PostEffects.jsx'




const root = ReactDOM.createRoot(document.querySelector('#root'))

root.render(
    <div className='webgl-container'>
        {/* <GrassUI /> */}
    <Canvas
        camera={ {
            fov: 45,
            near: 1,
            far: 1000,
            position: [ 0, 0, 6 ]
        } }

        gl={{
            antialias: true,
            alpha: true,
        }}
    >   
    <OrbitControls makeDefault />
        {/* <fogExp2
            attach="fog"
            args={['#282828', 0.0015]}
        /> */}
        {/* <Perf /> */}
        <Perf />
        <Experience />
        <PostEffects />
    </Canvas>
    </div>
)