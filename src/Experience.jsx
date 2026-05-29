
import { Vector3 } from "three"
import DigitalTrianglePortal from "./components/DigitalTrianglePortal"
import ODSLogo from "./components/ODSLogo"
import GrassField from "./components/GrassField"
import { Center, Float, Sky, Text, useDepthBuffer, useFBO } from "@react-three/drei"
import { useFrame, useThree } from "@react-three/fiber"
import useMouse from './hooks/useMouse.jsx'
import gsap from "gsap"
import { useEffect, useMemo, useRef } from "react"
import ParallaxDepth from "./components/ParallaxDepth.jsx"
//import GridLightColumns from "./components/GridLightColumns"
import { CyborgPlane } from './components/CyborgPlane.jsx'
import TerrainFog from "./components/TerrainFog.jsx"
import { NearestFilter, RGBADepthPacking } from "three/src/constants.js"
import TerrainGrass from "./components/TerrainGrass.jsx"
import { GlassSign } from './components/GlassSign.jsx'



export default function Experience()
{

    const fog1 = useRef();
    const fog2 = useRef();
    const groupRef = useRef();
    const { size } = useThree();
    const { x, y } = useMouse();

    const sceneFBO = useFBO(
            size.width,
            size.height,
            {
                depth: true,
                stencilBuffer: false,
                minFilter: NearestFilter,
                magFilter: NearestFilter,
            }
    )

    useFrame( ( { gl, camera, scene }, delta ) =>
    {
        // fog1.current.visible = false;
        // // fog2.current.visible = false;

        // gl.setRenderTarget( sceneFBO );
        // gl.clear();
        // gl.render( scene, camera );
        // fog1.current.material.uniforms.uDepthTexture.value = sceneFBO.depthTexture;
        // fog1.current.material.uniforms.uSceneColor.value = sceneFBO.texture;
        // // fog2.current.material.uniforms.uDepthTexture.value = sceneFBO.depthTexture;
        // // fog2.current.material.uniforms.uSceneColor.value = sceneFBO.texture;
        // gl.setRenderTarget( null );

        // fog1.current.visible = true;
        // // fog2.current.visible = true;

        // gl.render( scene, camera );

        gsap.to(camera.rotation,{
            y: gsap.utils.mapRange( 0, window.innerWidth, -.02, .02, x ),
            x: gsap.utils.mapRange( 0, window.innerHeight, -.02, .02, y )
        })

    })


    return(

        <group>
            {/* <DigitizePlane position={ [ 0, 0, 0 ] } digaDensity={ new Vector3( 0.1, 0.05, 0.025 )} />
            <ODSLogo position={ [ 0, 0, -0.03 ] } />
            <DigitizePlane position={[ 0, 0, -0.08 ]} digaDensity={ new Vector3( 0.1, 0.05, 0.025 )} /> */}
            {/* <DigitalTrianglePortal /> */}
            
            {/* <GrassField /> */}
            <Sky
                rayleigh={0.1}
            />
            {/* <Float
                floatIntensity={ 0.3 }
            >
                <GlassSign />
            </Float> */}
                
            
            
            <group ref={ groupRef }>
                <group 
                    rotation-x={ 8 * Math.PI / 180 }
                    position-z={ -2.7 }
                    position-y={ -1.5 }
                >
                    <TerrainGrass 
                        bladeHeight={ 0.3 }
                        bladeCount={ 101000 }
                        areaSize={ 20 }
                        windStrength={ 0.33 }
                        windTimeScale={ 0.18 }
                        windScale={ 0.2 }
                    />
                    <mesh 
                        rotation-x={ -90 * Math.PI / 180 }
                        position-y={ -0.01 }
                    >
                        <planeGeometry args={[20, 20]} />
                        <meshBasicMaterial color='#5e3958' />
                    </mesh>
                </group>
            </group>

            {/* <ParallaxDepth /> */}
            {/* <CyborgPlane /> */}
            {/* <TerrainFog
                rotation-x={ -90 * Math.PI / 180}
                position-y={ .3 }
                ref={ fog1 }
            />
            <TerrainFog
                rotation-x={ -90 * Math.PI / 180}
                position-y={ .4 }
                noiseScrollSpeed={ -0.04 }
                fogParallaxAmt={ 0.5 }
                ref={ fog2 }
            /> */}
        </group>
    
    )
    
}