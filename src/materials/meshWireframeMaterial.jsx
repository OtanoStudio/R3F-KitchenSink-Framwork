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
    colorBack = false, // enable double side color
    seeThrough = false, // determine if material is see-through
    backColor = '#ffffff', // if backface enabled set backside color
    backGradientTop = '#c3a867',
    backGradientBottom = '#2e6659',
}) 
{
    color = new Color( color );
    color.multiplyScalar( brightness );
    backColor = new Color( backColor );
    backColor.multiplyScalar( brightness );
    gradientTop = new Color( gradientTop );
    gradientTop.multiplyScalar( brightness );
    gradientBottom = new Color( gradientBottom );
    gradientBottom.multiplyScalar( brightness );
    backGradientTop = new Color( backGradientTop );
    backGradientTop.multiplyScalar( brightness );
    backGradientBottom = new Color( backGradientBottom );
    backGradientBottom.multiplyScalar( brightness );

    gradient = typeof gradient === 'boolean' ? gradient : false;
    seeThrough = typeof seeThrough === 'boolean' ? seeThrough : false;
    colorBack = typeof colorBack === 'boolean' ? colorBack : false;

    const uniforms =
    {
        uLineWidth: lineWidth,
        uBaseColor: color,
        uBackColor: backColor,
        uGradientTop: gradientTop,
        uGradientBottom: gradientBottom,
        uGradient: gradient,
        uBackground: seeThrough,
        uGradientBackTop: backGradientTop,
        uGradientBackBottom: backGradientBottom,
        uBackColored: colorBack,
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
