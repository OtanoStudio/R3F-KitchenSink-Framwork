import * as THREE from "three";
import React, { useMemo, useRef, useEffect } from "react";
import { useFrame, createPortal } from "@react-three/fiber";
import { OrthographicCamera } from "@react-three/drei";

/* ------------------------------------------------------------------ */
/* CONFIG                                                             */
/* ------------------------------------------------------------------ */

const RESOLUTION_SCALE = 0.5;

/* ------------------------------------------------------------------ */
/* SHADER LIBRARY (GLSL - PORTABLE FUNCTIONS)                        */
/* ------------------------------------------------------------------ */

const GLSL_COMMON = /* glsl */`
precision highp float;

uniform float uTime;
uniform vec3 uCameraPos;
uniform mat4 uInvProjection;
uniform mat4 uInvView;

#define PI 3.14159265359

vec3 getViewDir(vec2 uv) {
    vec4 clip = vec4(uv * 2.0 - 1.0, 1.0, 1.0);
    vec4 view = uInvProjection * clip;
    view /= view.w;
    return normalize((uInvView * vec4(view.xyz, 0.0)).xyz);
}
`;

const GLSL_NOISE = /* glsl */`
uniform sampler3D uBaseNoise;
uniform sampler3D uDetailNoise;
uniform sampler2D uCurlNoise;
uniform sampler2D uBlueNoise;
uniform float uFrame;

float sampleBase(vec3 p) {
    return texture(uBaseNoise, p * 0.0005).r;
}

float sampleDetail(vec3 p) {
    return texture(uDetailNoise, p * 0.002).r;
}

vec2 sampleCurl(vec2 uv) {
    return texture(uCurlNoise, uv * 0.1).rg * 2.0 - 1.0;
}

float blueNoise(vec2 uv)
{
    return texture(uBlueNoise, uv + vec2(uFrame * 0.013, uFrame * 0.017)).r;
}

vec2 jitter(vec2 uv)
{
    float n = blueNoise(uv);
    return vec2(n, fract(n * 1.618)) * 2.0 - 1.0;
}

`;

const GLSL_WEATHER = /* glsl */`
uniform sampler2D uWeatherMap;

vec4 sampleWeather(vec3 pos) {
    vec2 uv = pos.xz * 0.00005;
    return texture(uWeatherMap, uv);
}
`;

const GLSL_DENSITY = /* glsl */`
float heightGradient(float h) {
    return smoothstep(0.0, 0.2, h) * smoothstep(1.0, 0.4, h);
}

float computeDensity(vec3 pos) {
    vec4 weather = sampleWeather(pos);

    float base = sampleBase(pos);
    float detail = sampleDetail(pos * 1.5);

    float height = clamp((pos.y - 1000.0) / 3000.0, 0.0, 1.0);

    float density =
        weather.r *
        base *
        detail *
        heightGradient(height);

    return density;
}
`;

const GLSL_PHASE = /* glsl */`

float phaseHG(float cosTheta, float g)
{
    float g2 = g * g;

    return (1.0 - g2) /
           (4.0 * PI *
           pow(max(0.0001, 1.0 + g2 - 2.0 * g * cosTheta), 1.5));
}

`;

const GLSL_POWDER = /* glsl */`

float powderEffect(float density)
{
    return 1.0 - exp(-density * 3.0);
}

`;

const GLSL_EXTINCTION = /* glsl */`

float extinction(float density,float distance)
{
    return exp(-density * distance);
}

`;

const GLSL_LIGHTING = /* glsl */`

uniform vec3 uSunDir;

vec3 computeLighting(
    vec3 position,
    vec3 viewDir,
    float density
)
{
    // Normalize once
    vec3 lightDir = normalize(uSunDir);

    // Angle between the view ray and the sun
    float cosTheta = clamp(dot(viewDir, lightDir), -1.0, 1.0);

    // Henyey-Greenstein phase
    float phase = phaseHG(cosTheta, 0.65);

    // Beer-Lambert attenuation
    float transmittance = extinction(density, 1.0);

    // Powder effect brightens cloud interiors
    float powder = powderEffect(density);

    // Silver lining (forward scattering)
    float forwardScatter = pow(max(cosTheta, 0.0), 8.0);

    // Base sunlight color
    vec3 sunColor = vec3(1.0, 0.96, 0.90);

    // Ambient sky contribution
    vec3 ambientColor = vec3(0.45, 0.55, 0.70);

    // Direct sunlight
    vec3 direct =
        sunColor *
        phase *
        transmittance;

    // Interior brightening
    direct *= mix(1.0, powder, 0.6);

    // Edge glow
    direct +=
        sunColor *
        forwardScatter *
        density *
        0.35;

    // Ambient fill so cloud bottoms aren't black
    vec3 ambient =
        ambientColor *
        density *
        0.15;

    return direct + ambient;
}

`;

const GLSL_RAYMARCH = /* glsl */`
vec4 marchCloud(
    vec3 ro,
    vec3 rd
)
{
    float t = 0.0;

    vec3 color = vec3(0.0);
    float alpha = 0.0;

    for(int i = 0; i < MAX_STEPS; i++)
    {
        vec3 pos = ro + rd * t;

        float density = computeDensity(pos);

        if(density > 0.01)
        {
            vec3 lighting =
                computeLighting(
                    pos,
                    rd,
                    density
                );

            float sampleAlpha = density * 0.08;

            color +=
                lighting *
                sampleAlpha *
                (1.0 - alpha);

            alpha +=
                sampleAlpha *
                (1.0 - alpha);

            if(alpha > 0.98)
                break;
        }

        t += mix(20.0, 4.0, density);
    }

    return vec4(color, alpha);
}
`;

const GLSL_MOTION = /* glsl */`
uniform mat4 uPrevViewProj;
uniform mat4 uCurrViewProj;

vec2 getMotionVector(vec3 worldPos)
{
    vec4 currClip = uCurrViewProj * vec4(worldPos, 1.0);
    vec4 prevClip = uPrevViewProj * vec4(worldPos, 1.0);

    vec2 currNDC = currClip.xy / currClip.w;
    vec2 prevNDC = prevClip.xy / prevClip.w;

    return (currNDC - prevNDC) * 0.5;
}
`;

const GLSL_TEMPORAL = /* glsl */`
uniform sampler2D uHistory;
uniform sampler2D uCurrent;

uniform float uHistoryWeight;
uniform float uRejectionStrength;

vec3 temporalBlend(vec2 uv, vec3 currColor, vec2 motion)
{
    vec2 prevUV = uv - motion;

    vec3 history = texture(uHistory, prevUV).rgb;

    float reject =
        step(uRejectionStrength, length(motion));

    float weight = mix(uHistoryWeight, 0.0, reject);

    return mix(currColor, history, weight);
}
`;

const GLSL_FRAGMENT = /* glsl */`
${GLSL_COMMON}
${GLSL_NOISE}
${GLSL_WEATHER}
${GLSL_DENSITY}
${GLSL_PHASE}
${GLSL_POWDER}
${GLSL_EXTINCTION}
${GLSL_LIGHTING}
${GLSL_RAYMARCH}

uniform vec3 uSunDir;

void main()
{
    vec2 uv = gl_FragCoord.xy / vec2(1024.0);

    vec2 j = jitter(uv);
    vec3 rd = getViewDir(uv + j * 0.002);

    vec3 ro = uCameraPos;

    vec3 worldPos = ro + rd * 500.0;

    vec4 cloud = marchCloud(ro,rd);

    vec3 sky = mix(
        vec3(0.4, 0.6, 1.0),
        vec3(1.0),
        rd.y * 0.5 + 0.5
    );

    float horizon = smoothstep(
        -0.15,
        0.2,
        rd.y
    );

    sky *= mix(
        0.7,
        1.0,
        horizon
    );

    vec3 cloudColor = cloud.rgb;
    float alpha = cloud.a;

    vec2 motion = getMotionVector(worldPos);

    vec3 finalColor = mix(
        sky,
        cloudColor,
        alpha
    );

    gl_FragColor = vec4(finalColor, 1.0);

    // store motion in alpha for now (we'll split buffers later)
    gl_FragColor.a = motion.x;
}
`;

/* ------------------------------------------------------------------ */
/* MATERIALS                                                         */
/* ------------------------------------------------------------------ */

function createMaterial(fragmentShader) {
    return new THREE.ShaderMaterial({
        uniforms: {
            uTime: { value: 0 },
            uCameraPos: { value: new THREE.Vector3() },
            uInvProjection: { value: new THREE.Matrix4() },
            uInvView: { value: new THREE.Matrix4() },
            uSunDir: { value: new THREE.Vector3(1, 1, 0) },
            uWeatherMap: { value: null },
            uBaseNoise: { value: null },
            uDetailNoise: { value: null },
            uCurlNoise: { value: null },
            uBlueNoise: { value: null },
            uHistory: { value: null },
            uCurrent: { value: null },
            uPrevViewProj: { value: new THREE.Matrix4() },
            uCurrViewProj: { value: new THREE.Matrix4() },
            uHistoryWeight: { value: 0.92 },
            uRejectionStrength: { value: 0.015 },
            uFrame: { value: 0.0 },
        },
        vertexShader: /* glsl */`
            varying vec2 vUv;
            void main() {
                vUv = uv;
                gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
            }
        `,
        fragmentShader
    });
}

/* ------------------------------------------------------------------ */
/* CLOUD RENDERER COMPONENT                                          */
/* ------------------------------------------------------------------ */

export default function VolumetricClouds({
    weatherMap,
    baseNoise,
    detailNoise,
    curlNoise,
    blueNoise,
    sunDirection = new THREE.Vector3(1, 1, 0)
}) {

    const quad = useRef();
    const camera = useRef();

    /* ----------------------------- FBOs ---------------------------- */

    const cloudRT = useMemo(() => new THREE.WebGLRenderTarget(
        1024 * RESOLUTION_SCALE,
        1024 * RESOLUTION_SCALE
    ), []);

    const historyA = useMemo(() =>
    new THREE.WebGLRenderTarget(size(), size(), {
        type: THREE.HalfFloatType
    }), []);

const historyB = useMemo(() =>
    new THREE.WebGLRenderTarget(size(), size(), {
        type: THREE.HalfFloatType
    }), []);

const currentFrame = useMemo(() =>
    new THREE.WebGLRenderTarget(size(), size(), {
        type: THREE.HalfFloatType
    }), []);

    const material = useMemo(() =>
        createMaterial(GLSL_FRAGMENT),
    []);

    /* ------------------------ CAMERA STATE ------------------------- */

    const prevView = useRef(new THREE.Matrix4());
    const prevProj = useRef(new THREE.Matrix4());

    /* ------------------------ FRAME LOOP --------------------------- */

    let ping = true;

    useFrame(({ camera, gl }, delta) =>
    {
        material.uniforms.uFrame.value++;

        material.uniforms.uCurrViewProj.value
            .copy(camera.projectionMatrix)
            .multiply(camera.matrixWorldInverse);

        // swap history buffers
        const read = ping ? historyA : historyB;
        const write = ping ? historyB : historyA;

        material.uniforms.uHistory.value = read.texture;

        gl.setRenderTarget(currentFrame);
        gl.render(scene, camera);

        // temporal pass happens in shader (same material for now)

        gl.setRenderTarget(write);
        gl.render(scene, camera);

        gl.setRenderTarget(null);

        ping = !ping;
    });
    /* ------------------------ RENDER QUAD -------------------------- */

    return (
        <>
            <OrthographicCamera ref={camera} makeDefault position={[0, 0, 1]} />

            {createPortal(
                <mesh ref={quad} material={material}>
                    <planeGeometry args={[2, 2]} />
                </mesh>,
                new THREE.Scene()
            )}
        </>
    );
}