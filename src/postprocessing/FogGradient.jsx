/* Stylized Fog
// original unity shader url: https://bitbucket.org/grrava/unitytoolset/src/master/Assets/StylizedFog/Shaders/StylizedFog.shader
// Ported by: Rickey Otano of Otano Studio
// Date: 06/12/2026
// MIT copyright

*/

import { Effect, EffectAttribute } from "postprocessing";
import { wrapEffect } from "@react-three/postprocessing";
import { Uniform } from "three";

const frag = /*glsl*/`

uniform sampler2D gradientMap;
uniform float intensity;
uniform float start;
uniform float end;
uniform float density;
uniform int fogType;
uniform float spread;
uniform bool clip;


float ComputeFog(
    float z, 
    float start, 
    float end, 
    float density, 
    int fogType 
) 
{

    float fog = 0.0;

    switch( fogType ) {
        case 0: // linear fog
            fog = ( end - z ) / ( end - start );
        break;

        case 1: // exp fog
            fog = exp2( -density * z );
        break;

        case 2: // exp2 fog
            fog = density * z;
            fog = exp2( -fog * fog );
        break;

        case 3: // hybrid uses linear fog as exp2 value
            float linear = clamp( ( z - start ) / ( end - start ), 0.0, 1.0 );
            float densityFactor = linear * density;
            fog = exp2( -densityFactor * densityFactor );
        break;

        default: // linear default
            fog = ( end - z ) / ( end - start );
        break;
    }
    
    return clamp( fog, 0.0, 1.0 );

}

void mainImage( 
    const in vec4 inputColor, 
    const in vec2 uv,
    const in float depth, 
    out vec4 outputColor
) 
{
    // clip the fog if enabled and depth is 0.9999
    if ( clip && depth >= 0.9999 ) 
    {

        outputColor = inputColor;
        return;

    }

    float dist = -getViewZ( depth );

    // Compute the physical alpha thickness of the fog (1.0 - visibility)
    float fogVisibility = ComputeFog( dist, start, end, density, fogType );
    float fogAmt = 1.0 - fogVisibility;

    // Compute where on the gradient strip to look, integrating the color spread factor
    float gradientVisibility = ComputeFog( dist * spread, start, end, density, fogType );
    float gradientSample = clamp( 1.0 - gradientVisibility, 0.0, 0.99 );

    // Sample gradient strip and blend
    vec4 colorFog = texture( gradientMap, vec2( gradientSample, 0.0 ) );
    outputColor = mix( inputColor, colorFog, fogAmt * colorFog.a * intensity );

}
`;

class FogGradientImpl extends Effect {
    constructor({ 
        blendFunction, 
        gradientMap = null, 
        intensity = 1.0, 
        start = 0.0, // Only used if fogType = 0 (Linear)
        end = 9.0, // Only used if fogType = 0 (Linear)
        density = 0.45, // Used if fogType = 1 or 2 (Exp/Exp2)
        fogType = 2, // 0 = Linear, 1 = Exp, 2 = Exp2
        spread = 1.0, // Adjusts the color distribution stretch
        clip = false, // clip in shader when beyond 0.99999

    } = {}) {
        super( "FogGradient", frag, {
            blendFunction, 
            attributes: EffectAttribute.DEPTH,
            uniforms: new Map([
                [ "gradientMap", new Uniform( gradientMap ) ],
                [ "intensity", new Uniform( intensity ) ],
                [ "start", new Uniform( start ) ],
                [ "end", new Uniform( end ) ],
                [ "density", new Uniform( density ) ],
                [ "fogType", new Uniform( fogType ) ],
                [ "spread", new Uniform( spread ) ],
                [ "clip", new Uniform( clip ) ]
            ])
        });
    }

    // Getters and Setters for reactive updates
    set gradientMap( value ) { this.uniforms.get( "gradientMap" ).value = value; }
    set intensity( value ) { this.uniforms.get( "intensity" ).value = value; }
    set start( value ) { this.uniforms.get( "start" ).value = value; }
    set end( value ) { this.uniforms.get( "end" ).value = value; }
    set density( value ) { this.uniforms.get( "density" ).value = value; }
    set fogType( value ) { this.uniforms.get( "fogType" ).value = value; }
    set spread( value ) { this.uniforms.get( "spread" ).value = value; }
    set clip( value ) { this.uniforms.get( "clip" ).value = value; }

}

export const FogGradient = wrapEffect( FogGradientImpl );