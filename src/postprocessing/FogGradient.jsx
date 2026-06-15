/* Stylized Fog
// original unity shader url: https://bitbucket.org/grrava/unitytoolset/src/master/Assets/StylizedFog/Shaders/StylizedFog.shader
// Ported by: Rickey Otano of Otano Studio
// Date: 06/12/2026
// MIT copyright

*/

import { Effect, EffectAttribute } from "postprocessing";
import { wrapEffect } from "@react-three/postprocessing";
import { Matrix4, Uniform, Vector3 } from "three";

const frag = /*glsl*/`

uniform sampler2D gradientMap;
uniform sampler2D heightNoiseTexture;

uniform float intensity;
uniform float start;
uniform float end;
uniform float density;
uniform float heightStart;
uniform float heightEnd;
uniform float spread;
uniform float time;
uniform float noiseScale;
uniform float noiseStrength;

uniform vec2 noiseSpeed;

uniform vec3 cameraPos;

uniform int fogType;

uniform bool clip;
uniform bool heightEnabled;
uniform bool heightNoise;

uniform mat4 invMat;

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

vec3 reconstructWorldPos(
    vec2 uv,
    float depth,
    mat4 invMat,
    int renderType
)
{

    vec3 NDC = vec3( 0.0 );

    switch( renderType )
    {
        case 0:
            NDC = vec3( uv * 2.0 - 1.0, depth * 2.0 - 1.0 );
        break;

        case 1:
            NDC = vec3( uv  * 2.0 - 1.0, depth );
        break;

        default:
            NDC = vec3( uv * 2.0 - 1.0, depth * 2.0 - 1.0 );
        break;
    }

    vec4 world = invMat * vec4( NDC, 1.0 );
    world.xyz /= world.w;

    return world.xyz;

}

void mainImage( 
    const in vec4 inputColor, 
    const in vec2 uv,
    const in float depth, 
    out vec4 outputColor
) 
{

    vec3 worldPos = reconstructWorldPos( uv, depth, invMat, 0 );

    // clip the fog if enabled and depth is 0.9999
    if ( depth >= 0.9999 ) 
    {

        if( clip )
        {

            outputColor = inputColor;
            return;

        }

        vec3 rayDir = normalize( worldPos - cameraPos );
        worldPos = cameraPos + rayDir * 150.0;

    }

    float dist = -getViewZ( depth );

    // handle if noise is used to handle the height cutoff

    vec2 uvNoise = ( uv * noiseScale ) + ( time * noiseSpeed );
    float heightNoiseFactor = texture( heightNoiseTexture, uvNoise ).r;


    float baseHeightGradient = 1.0 - smoothstep( heightStart, heightEnd, worldPos.y );

    float heightOffset = baseHeightGradient;
    
    if ( heightNoise ) 
    {
        
        float erosionMask = 1.0 - baseHeightGradient;
        
        
        float erosionAmount = heightNoiseFactor * noiseStrength * erosionMask;
        
        
        heightOffset = clamp( baseHeightGradient - erosionAmount, 0.0, 1.0 );

    }

    // Compute the physical alpha thickness of the fog (1.0 - visibility)
    float fogVisibility = ComputeFog( dist, start, end, density, fogType );
    float fogAmt = 1.0 - fogVisibility;

    if( heightEnabled ) fogAmt *= heightOffset;


    // Compute where on the gradient strip to look, integrating the color spread factor
    float gradientVisibility = ComputeFog( dist * spread, start, end, density, fogType );
    float gradientSample = clamp( 1.0 - gradientVisibility, 0.0, 0.99 );

    // Sample gradient strip and blend
    vec4 colorFog = texture( gradientMap, vec2( gradientSample, 0.0 ) );
    outputColor = mix( inputColor, colorFog, fogAmt * colorFog.a * intensity );
    //outputColor = vec4( vec3( heightOffset ), 1.0 );

}
`;

class FogGradientImpl extends Effect {
    constructor({ 
        blendFunction,
        camera, 
        gradientMap = null, 
        intensity = 1.0, 
        start = 0.0, // Only used if fogType = 0 (Linear)
        end = 9.0, // Only used if fogType = 0 (Linear)
        density = 0.45, // Used if fogType = 1 or 2 (Exp/Exp2)
        fogType = 2, // 0 = Linear, 1 = Exp, 2 = Exp2
        spread = 1.0, // Adjusts the color distribution stretch
        clip = false, // clip in shader when beyond 0.99999
        heightEnabled = true, // if there should be fog  height
        heightNoise = true, // use noise with fog height
        heightStart = 0.0, // height start
        heightEnd = 0.1, // height end
        heightNoiseTexture = null, // noise cutoff texture
        noiseScale = 5, // scale to size the noise
        noiseSpeed = [ 0.2, 0.0 ], // noise movement speed
        noiseStrength = 0.03, // strength of the noise


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
                [ "clip", new Uniform( clip ) ],
                [ "invMat", new Uniform( new Matrix4() ) ],
                [ "heightStart", new Uniform( heightStart ) ],
                [ "heightEnd", new Uniform( heightEnd ) ],
                [ "heightEnabled", new Uniform( heightEnabled ) ],
                [ "heightNoise", new Uniform( heightNoise ) ],
                [ "heightNoiseTexture", new Uniform( heightNoiseTexture ) ],
                [ "noiseScale", new Uniform( noiseScale ) ],
                [ "noiseSpeed", new Uniform( noiseSpeed ) ],
                [ "time", new Uniform( 0.0 ) ],
                [ "noiseStrength", new Uniform( noiseStrength ) ],
                [ "cameraPos", new Uniform( new Vector3() ) ]
            ])
        });

        this.camera = camera;
    }

    update(renderer, inputBuffer, deltaTime)
    {

        this.uniforms.get("time").value += deltaTime;

        if ( this.camera ) 
        {

            const viewProj = new Matrix4().multiplyMatrices( this.camera.projectionMatrix, this.camera.matrixWorldInverse );
            this.uniforms.get("invMat").value.copy( viewProj ).invert();

            this.uniforms.get("cameraPos").value.copy( this.camera.position );

        }

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
    set invMat( value ) { this.uniforms.get( "invMat" ).value = value; }
    set heightStart( value ) { this.uniforms.get( "heightStart" ).value = value; }
    set heightEnd( value ) { this.uniforms.get( "heightEnd" ).value = value; }
    set heightEnabled( value ) { this.uniforms.get( "heightEnabled" ).value = value; }
    set heightNoise( value ) { this.uniforms.get( "heightNoise" ).value = value; }
    set heightNoiseTexture( value ) { this.uniforms.get( "heightNoiseTexture" ).value = value; }
    set noiseScale( value ) { this.uniforms.get( "noiseScale" ).value = value; }
    set noiseSpeed( value ) { this.uniforms.get( "noiseSpeed" ).value = value; }
    set noiseStrength( value ) { this.uniforms.get( "noiseStrength" ).value = value; }

}

export const FogGradient = wrapEffect( FogGradientImpl );