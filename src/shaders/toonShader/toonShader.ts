export const toonVertexShader = /* glsl */ `
varying vec3 vNormal;

void main() {
  vNormal = normalize(normalMatrix * normal);
  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}
`;

export const toonFragmentShader = /* glsl */ `
varying vec3 vNormal;

void main() {
  float light = dot(normalize(vNormal), normalize(vec3(0.35, 0.55, 0.75)));
  float ramp = smoothstep(0.12, 0.2, light);
  vec3 base = mix(vec3(0.18, 0.24, 0.42), vec3(0.92, 0.96, 1.0), ramp);
  gl_FragColor = vec4(base, 1.0);
}
`;
