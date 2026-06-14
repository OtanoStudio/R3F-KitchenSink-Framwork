import { forwardRef, useMemo } from "react";
import { Effect, EffectAttribute } from "postprocessing";
import { Uniform } from "three";
import { wrapEffect } from "@react-three/postprocessing";

const fragmentShader = /* glsl */ `
uniform sampler2D gradientMap;
uniform float fogAmount;
uniform float fogOffset;
uniform float intensity;
uniform bool clipSky;

void mainImage(
    const in vec4 inputColor,
    const in vec2 uv,
    const in float depth,
    out vec4 outputColor
) 
{

    // Optional sky clipping
    if (clipSky && depth >= 0.9999) 
    {
        outputColor = inputColor;
        return;
    }

    // ShaderGraph equivalent:
    // uv = saturate(depth * FogAmount + FogOffset)

    float gradientUV =
        clamp(
            depth * fogAmount + fogOffset,
            0.0,
            1.0
        );

    vec4 fogColor =
        texture(
            gradientMap,
            vec2(gradientUV, 0.5)
        );

    outputColor =
        mix(
            inputColor,
            fogColor,
            fogColor.a * intensity
        );
}
`;

class GradientFogEffectImpl extends Effect {
    constructor({
        blendFunction,
        gradientMap = null,
        fogAmount = 1.5,
        fogOffset = -0.8,
        intensity = 1.0,
        clipSky = false
        
    } = {}) {
        super("GradientFog", fragmentShader, {
            blendFunction,
            attributes: EffectAttribute.DEPTH,
            uniforms: new Map([
                ["gradientMap", new Uniform(gradientMap)],
                ["fogAmount", new Uniform(fogAmount)],
                ["fogOffset", new Uniform(fogOffset)],
                ["intensity", new Uniform(intensity)],
                ["clipSky", new Uniform(clipSky)]
            ])
        });
    }

    set gradientMap(v) {
        this.uniforms.get("gradientMap").value = v;
    }

    set fogAmount(v) {
        this.uniforms.get("fogAmount").value = v;
    }

    set fogOffset(v) {
        this.uniforms.get("fogOffset").value = v;
    }

    set intensity(v) {
        this.uniforms.get("intensity").value = v;
    }

    set clipSky(v) {
        this.uniforms.get("clipSky").value = v;
    }
}

export const GradientFog = wrapEffect(GradientFogEffectImpl);