# Coding Guide

## Where To Add Code

Use this table when you are unsure where code belongs.

| Need | File or folder |
| --- | --- |
| Add a new 3D object | `src/canvas/` |
| Add a shader | `src/shaders/<effectName>/` |
| Add a button or reusable UI control | `src/components/ui/` |
| Add a HUD panel | `src/components/panels/` |
| Add page content | `src/pages/` |
| Add project metadata | `src/data/projects.ts` |
| Add interaction state | `src/state/` |
| Add input or scroll logic | `src/hooks/` |
| Add keyframe playback logic | `src/engine/timeline/` |
| Add runtime timeline playback | `src/engine/runtime/` |
| Add global visual styling | `src/styles/global.css` |

## Timeline Rule

Any parameter that should be animated must be represented in `SceneConfig` first. The editor records keyframes as `propertyPath` strings, and the runtime evaluates those tracks through `src/engine/timeline/evaluateTimeline.ts`.

Runtime playback should not implement a second animation system for scene parameters. Use `TimelineScene` from `src/engine/runtime/TimelineScene.tsx` so editor preview and published playback read the same timeline data.

Keyframes should be created from parameter-side controls in the editor inspector. Avoid adding separate dropdown-based keyframe workflows unless they are only advanced search helpers.

Track interpolation lives on each `TimelineTrack`, not on each ad hoc UI control. Supported modes are `constant`, `linear`, `smoothstep`, and `bezier`. Keep runtime evaluation in `evaluateTimeline.ts` so editor preview and published playback stay identical.

## Scene Coding Pattern

Each 3D component should follow this shape:

```tsx
export function EnergyRing() {
  const ref = useRef<Mesh>(null);

  useFrame((_, delta) => {
    if (!ref.current) return;
    ref.current.rotation.z += delta * 0.28;
  });

  return <mesh ref={ref}>{/* geometry + material */}</mesh>;
}
```

Keep per-frame animation inside `useFrame`. Keep static configuration in `src/data/`.

## State Pattern

Shared interaction state should live in Zustand stores under `src/state/`.

Use state for things like:

- selected module
- current transition target
- performance mode
- sound enabled
- startup sequence phase

Do not pass deeply nested props through many components for scene-wide interaction.

## Shader Pattern

Keep raw shader strings small at first. When a shader grows, split into:

```text
shaderName/
  vertex.glsl
  fragment.glsl
  uniforms.ts
  material.ts
```

For now, TypeScript shader string files are enough.

## Performance Rules

- Avoid creating geometry, material, or large arrays inside `useFrame`.
- Use `useMemo` for generated particle buffers.
- Limit device pixel ratio, especially on mobile.
- Prefer instancing or points for repeated objects.
- Load heavy pages and labs later with dynamic import.
- Keep post effects controlled; bloom should support the image, not wash it out.

## Naming Rules

Use clear system names:

- `CameraRig`
- `MainCharacter`
- `EnergyRing`
- `OrbitParticles`
- `FloatingPanels`
- `PostEffects`

Avoid generic names like `Thing`, `Effect1`, or `NewComponent`.
