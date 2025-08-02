import { shaderMaterial } from '@react-three/drei';
import { extend } from '@react-three/fiber';
import vertex from '../shaders/wiredVert.glsl';
import fragment from '../shaders/wiredFrag.glsl';
import { Color, DoubleSide, FrontSide } from 'three';

export default function WireframeMaterial({
    lineWidth = 2, // default line width
    color = '#ffffff', // default color
    gradientTop = '#c3a867',
    gradientBottom = '#2e6659',
    gradient = false, // toggle gradient
    brightness = 1.0, // brightness for colors
    seeThrough = false, // determine if material is see-through
    backColor = '#ffffff', // if backface enabled set backside color
}) 
{
    color = new Color( color );
    gradientTop = new Color( gradientTop );
    gradientTop.multiplyScalar( brightness );
    gradientBottom = new Color( gradientBottom );
    gradientBottom.multiplyScalar( brightness );

    gradient = typeof gradient === 'boolean' ? gradient : false;
    seeThrough = typeof seeThrough === 'boolean' ? seeThrough : false;

    const uniforms =
    {
        uLineWidth: lineWidth,
        uBaseColor: color,
        uGradientTop: gradientTop,
        uGradientBottom: gradientBottom,
        uGradient: gradient,
        uBackground: seeThrough,
    };

    const WireframeMaterial = shaderMaterial( uniforms, vertex, fragment );

    const facing = seeThrough ? DoubleSide : FrontSide;

    extend( { WireframeMaterial } );

    return (
        <wireframeMaterial
            key={ WireframeMaterial.key }
            transparent={ true }
            side={ facing }
        />
        )
}
