import * as THREE from 'three';
import { Effect, EffectAttribute } from 'postprocessing';
import { DualKawaseGLSL } from './DualKawaseShaders.js';

const fragmentShader = /* glsl */ `
  uniform sampler2D uBloomTexture;
  uniform float uStrength;

  void mainImage(const in vec4 inputColor, const in vec2 uv, out vec4 outputColor) {
    vec4 bloom = texture2D(uBloomTexture, uv);
    outputColor = vec4(inputColor.rgb + bloom.rgb * uStrength, inputColor.a);
  }
`;

export class DualKawaseBloomEffect extends Effect {
  constructor({
    resolutionScale = 'quarter',
    strength = 1.0,
    radius = 1.0,
    threshold = 0.8,
    pyramidLevels = 4
  } = {}) {
    super('DualKawaseBloomEffect', fragmentShader, {
      attributes: EffectAttribute.CONVOLUTION,
      uniforms: new Map([
        ['uBloomTexture', new THREE.Uniform(null)],
        ['uStrength', new THREE.Uniform(strength)]
      ])
    });

    this.resolutionScale = resolutionScale === 'half' ? 0.5 : 0.25;
    this.strength = strength;
    this.radius = radius;
    this.threshold = threshold;
    this.pyramidLevels = pyramidLevels;

    this.pyramidTargetsDown = [];
    this.pyramidTargetsUp = [];

    this._initMaterials();
  }

  _initMaterials() {
    this.thresholdMaterial = new THREE.ShaderMaterial({
      uniforms: {
        tDiffuse: { value: null },
        threshold: { value: this.threshold }
      },
      fragmentShader: /* glsl */ `
        uniform sampler2D tDiffuse;
        uniform float threshold;
        varying vec2 vUv;
        void main() {
          vec4 color = texture2D(tDiffuse, vUv);
          float brightness = max(color.r, max(color.g, color.b));
          float contribution = max(0.0, brightness - threshold) / max(brightness, 0.00001);
          gl_FragColor = vec4(color.rgb * contribution, color.a);
        }
      `
    });

    this.downMaterial = new THREE.ShaderMaterial({
      uniforms: {
        tDiffuse: { value: null },
        texelSize: { value: new THREE.Vector2() }
      },
      fragmentShader: /* glsl */ `
        uniform sampler2D tDiffuse;
        uniform vec2 texelSize;
        varying vec2 vUv;
        ${DualKawaseGLSL}
        void main() {
          gl_FragColor = dualKawaseDown(tDiffuse, vUv, texelSize);
        }
      `
    });

    this.upMaterial = new THREE.ShaderMaterial({
      uniforms: {
        tDiffuse: { value: null },
        texelSize: { value: new THREE.Vector2() },
        radius: { value: this.radius }
      },
      fragmentShader: /* glsl */ `
        uniform sampler2D tDiffuse;
        uniform vec2 texelSize;
        uniform float radius;
        varying vec2 vUv;
        ${DualKawaseGLSL}
        void main() {
          gl_FragColor = dualKawaseUp(tDiffuse, vUv, texelSize, radius);
        }
      `
    });

    this.quadScene = new THREE.Scene();
    this.quadCamera = new THREE.OrthographicCamera(-1, 1, 1, -1, 0, 1);
    this.quadMesh = new THREE.Mesh(new THREE.PlaneGeometry(2, 2));
    this.quadScene.add(this.quadMesh);
  }

  _initRenderTargets(width, height) {
    this._disposeTargets();

    let baseW = Math.floor(width * this.resolutionScale);
    let baseH = Math.floor(height * this.resolutionScale);

    const pars = {
      minFilter: THREE.LinearFilter,
      magFilter: THREE.LinearFilter,
      format: THREE.RGBAFormat,
      type: THREE.HalfFloatType
    };

    for (let i = 0; i < this.pyramidLevels; i++) {
      const w = Math.max(1, Math.floor(baseW / Math.pow(2, i)));
      const h = Math.max(1, Math.floor(baseH / Math.pow(2, i)));

      this.pyramidTargetsDown.push(new THREE.WebGLRenderTarget(w, h, pars));
      this.pyramidTargetsUp.push(new THREE.WebGLRenderTarget(w, h, pars));
    }
  }

  _disposeTargets() {
    [...this.pyramidTargetsDown, ...this.pyramidTargetsUp].forEach((t) => t.dispose());
    this.pyramidTargetsDown = [];
    this.pyramidTargetsUp = [];
  }

  setSize(width, height) {
    this._initRenderTargets(width, height);
  }

  update(renderer, inputBuffer) {
    if (this.pyramidTargetsDown.length === 0) return;

    // 1. Threshold Pass
    this.thresholdMaterial.uniforms.tDiffuse.value = inputBuffer.texture;
    this.thresholdMaterial.uniforms.threshold.value = this.threshold;
    this.quadMesh.material = this.thresholdMaterial;
    renderer.setRenderTarget(this.pyramidTargetsDown[0]);
    renderer.render(this.quadScene, this.quadCamera);

    // 2. Downsample
    let currentSrc = this.pyramidTargetsDown[0];
    for (let i = 1; i < this.pyramidLevels; i++) {
      const dest = this.pyramidTargetsDown[i];
      this.downMaterial.uniforms.tDiffuse.value = currentSrc.texture;
      this.downMaterial.uniforms.texelSize.value.set(1 / currentSrc.width, 1 / currentSrc.height);
      this.quadMesh.material = this.downMaterial;
      renderer.setRenderTarget(dest);
      renderer.render(this.quadScene, this.quadCamera);
      currentSrc = dest;
    }

    // 3. Upsample
    this.upMaterial.uniforms.radius.value = this.radius;
    for (let i = this.pyramidLevels - 1; i >= 0; i--) {
      const dest = this.pyramidTargetsUp[i];
      this.upMaterial.uniforms.tDiffuse.value = currentSrc.texture;
      this.upMaterial.uniforms.texelSize.value.set(1 / currentSrc.width, 1 / currentSrc.height);
      this.quadMesh.material = this.upMaterial;
      renderer.setRenderTarget(dest);
      renderer.render(this.quadScene, this.quadCamera);
      currentSrc = dest;
    }

    // Pass final upsampled bloom texture to composite material
    this.uniforms.get('uBloomTexture').value = this.pyramidTargetsUp[0].texture;
    this.uniforms.get('uStrength').value = this.strength;
  }

  dispose() {
    this._disposeTargets();
    this.thresholdMaterial.dispose();
    this.downMaterial.dispose();
    this.upMaterial.dispose();
    this.quadMesh.geometry.dispose();
    super.dispose();
  }
}