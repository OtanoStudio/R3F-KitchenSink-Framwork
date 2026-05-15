
import { Vector3 } from "three"
import DigitalTrianglePortal from "./components/DigitalTrianglePortal"
import ODSLogo from "./components/ODSLogo"
import GrassField from "./components/GrassField"
import { Text, useDepthBuffer, useFBO } from "@react-three/drei"
import { useFrame, useThree } from "@react-three/fiber"
import useMouse from './hooks/useMouse.jsx'
import gsap from "gsap"
import { useEffect, useMemo, useRef } from "react"
import ParallaxDepth from "./components/ParallaxDepth.jsx"
//import GridLightColumns from "./components/GridLightColumns"
import { CyborgPlane } from './components/CyborgPlane.jsx'
import TerrainFog from "./components/TerrainFog.jsx"
import { NearestFilter, RGBADepthPacking } from "three/src/constants.js"


export default function Experience()
{

    const fog1 = useRef();
    const fog2 = useRef();
    const { size } = useThree();

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
        fog1.current.visible = false;
        // fog2.current.visible = false;

        gl.setRenderTarget( sceneFBO );
        gl.clear();
        gl.render( scene, camera );
        fog1.current.material.uniforms.uDepthTexture.value = sceneFBO.depthTexture;
        fog1.current.material.uniforms.uSceneColor.value = sceneFBO.texture;
        // fog2.current.material.uniforms.uDepthTexture.value = sceneFBO.depthTexture;
        // fog2.current.material.uniforms.uSceneColor.value = sceneFBO.texture;
        gl.setRenderTarget( null );

        fog1.current.visible = true;
        // fog2.current.visible = true;

        gl.render( scene, camera );

    })

    return(

        <group>
            {/* <DigitizePlane position={ [ 0, 0, 0 ] } digaDensity={ new Vector3( 0.1, 0.05, 0.025 )} />
            <ODSLogo position={ [ 0, 0, -0.03 ] } />
            <DigitizePlane position={[ 0, 0, -0.08 ]} digaDensity={ new Vector3( 0.1, 0.05, 0.025 )} /> */}
            {/* <DigitalTrianglePortal /> */}
            
            <GrassField />
            <mesh 
                rotation-x={ -90 * Math.PI / 180 }
                position-y={ -0.49 }
            >
                <planeGeometry args={[12, 12]} />
                <meshBasicMaterial color='#5e3958' />
            </mesh>

            {/* <ParallaxDepth /> */}
            {/* <CyborgPlane /> */}
            <TerrainFog
                rotation-x={ -90 * Math.PI / 180}
                position-y={ .08 }
                ref={ fog1 }
            />
            {/* <TerrainFog
                rotation-x={ -90 * Math.PI / 180}
                position-y={ .173 }
                noiseScrollSpeed={ -0.04 }
                fogParallaxAmt={ 0.5 }
                ref={ fog2 }
            /> */}
        </group>
    
    )
    
}