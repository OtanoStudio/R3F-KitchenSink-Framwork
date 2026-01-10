import { shaderMaterial, useTexture } from "@react-three/drei";
import { extend, useFrame } from "@react-three/fiber";
import { useRef } from "react";
import { AdditiveBlending, Color, RepeatWrapping, Vector3 } from "three";
import vertex from '../shaders/planeparticles/vertex.glsl';
import fragment from '../shaders/planeparticles/fragment.glsl';
import gsap from "gsap";
import { useGSAP } from "@gsap/react";


export function DigitizeMaterial(
    {
        color1 = "#9ffcff",
        color2 = "#ffffff",
        color3 = "#5fdcff",
        digaSize = new Vector3( 0.8, 0.6, 0.35 ),
        digaDensity = new Vector3( 0.6, 0.3, 0.1 ),
        digaLifetime = new Vector3( 2.5, 2.5, 2.1 ),
        colorIntensity = new Vector3( 1, 1, 1 ),
        noiseTexture = './textures/noise/noiseValue.webp',
        ...props
    }
) 
{

    const self = useRef();
    gsap.registerPlugin(useGSAP);

    color1 = new Color( color1 );
    color2 = new Color( color2 );
    color3 = new Color( color3 );

    const textureNoise = useTexture( noiseTexture );
    textureNoise.wrapS = RepeatWrapping;
    textureNoise.wrapT = RepeatWrapping;

    colorIntensity = ( colorIntensity instanceof Vector3 ) ? colorIntensity : new Vector3( 1, 1, 1 );

    color1.multiplyScalar( colorIntensity.x );
    color2.multiplyScalar( colorIntensity.y );
    color3.multiplyScalar( colorIntensity.z );

    digaDensity = ( digaDensity instanceof Vector3 ) ? digaDensity : new Vector3( 0.6, 0.3, 0.1 );
    digaLifetime = ( digaLifetime instanceof Vector3 ) ? digaLifetime : new Vector3( 2.5, 2.5, 2.1 );
    digaSize = ( digaSize instanceof Vector3 ) ? digaSize : new Vector3( 0.8, 0.6, 0.35 );

    console.log( digaDensity );

    const uniforms =
    {
        uColor1: color1,
        uColor2: color2,
        uColor3: color3,
        uSizes: digaSize,
        uDensity: digaDensity,
        uLifetime: digaLifetime,
        uTime: 0,
        uNoiseTex: textureNoise,
        uReveal: 0,
        uPhase: 0,
    }

    useGSAP( () =>
    {
        gsap.to( self.current.uniforms.uReveal,
        {
            value: 1,
            duration: 2,
            ease: 'back.inOut'
        })
        gsap.to( self.current.uniforms.uPhase,
        {
            value: 1,
            duration: 2,
            ease: 'back.inOut'
        })
    })

    useFrame(( state, delta ) =>
    {

        self.current.uniforms.uTime.value += delta;

    })

    const DigitizeMaterial = shaderMaterial( uniforms, vertex, fragment );

    extend( { DigitizeMaterial } );

    return (
    <digitizeMaterial
        key={ DigitizeMaterial.key }
        ref={ self }
        depthWrite={ false }
        blending={ AdditiveBlending }
        transparent={ true }
        { ...props }
    />
    )
}
