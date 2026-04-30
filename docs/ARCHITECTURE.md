# Architecture

## Mental Model

The app has three layers:

```text
App shell
  Layout, HUD, persistent status

Page layer
  Home, Shader Lab, VFX Lab, Character Render, Tools, Projects, Contact

Canvas layer
  Realtime 3D scene systems
```

The home page currently mounts the realtime scene and overlays the module dock.

The local editor page lives at `/editor.html`. It uses the same scene components as the runtime page, but adds a custom parameter inspector, per-parameter key buttons, and editor-only camera controls.

## Source Layout

```text
src/
  App.tsx
  main.tsx
  styles/
    global.css

  components/
    layout/        App frame and persistent HUD
    navigation/    Module entry navigation
    panels/        Status and hologram panels
    ui/            Reusable buttons and controls

  canvas/
    Scene.tsx          Root <Canvas> composition
    CameraRig.tsx      Mouse and future scroll camera logic
    MainCharacter.tsx  Character placeholder, later GLB + toon material
    EnergyRing.tsx     Rotating ring behind character
    Particles.tsx      Orbit dust and future GPU particles
    FloatingPanels.tsx 3D panel placeholders
    Lighting.tsx       Cinematic lighting setup
    PostEffects.tsx    Bloom / vignette / later DOF and film grain

  shaders/
    toonShader/
    outlineShader/
    dissolveShader/
    particleShader/
    postEffects/

  data/
    siteModules.ts
    projects.ts
    skills.ts
    shaderParams.ts

  hooks/
    useMouseParallax.ts
    useScrollProgress.ts
    useTransition.ts
    usePerformanceMode.ts

  editor/
    EditorApp.tsx
    EditorViewport.tsx
    EditorToolbar.tsx

  engine/
    timeline/      Keyframe evaluation for editor and runtime
    runtime/       Timeline-driven scene runtime components

  types/
    scene.ts
```

## Data Flow

Page UI should not directly mutate Three.js objects. Keep the direction like this:

```text
UI event
  -> global state or typed config
  -> canvas component reads state
  -> useFrame animates visual result
```

Example:

```text
Hover "LAB_01 / TOON SHADER"
  -> selectedModule = "shader"
  -> EnergyRing spins faster
  -> FloatingPanels highlight shader keywords
  -> MainCharacter can flash debug scan lines
```

## Scene Composition

`src/canvas/Scene.tsx` is the orchestration file. It should stay small:

```tsx
<Canvas>
  <CameraRig>
    <Lighting />
    <EnergyRing />
    <MainCharacter />
    <OrbitParticles />
    <FloatingPanels />
    <PostEffects />
  </CameraRig>
</Canvas>
```

If a file starts handling multiple responsibilities, split it.

## Asset Plan

Use `src/assets/` for source-managed runtime assets:

```text
src/assets/models/      GLB / GLTF characters and props
src/assets/textures/    WebP / KTX2 textures
src/assets/hdr/         HDR or environment references
src/assets/videos/      Compressed showcase clips
src/assets/audio/       Optional UI and ambience sounds
src/assets/reference/   Visual references used while building
```

Large raw files should stay out of runtime paths unless they are actually needed by the site.

## Implementation Order

1. Replace placeholder character with an optimized GLB.
2. Add real toon material and outline pass.
3. Connect module hover state to scene reactions.
4. Add GSAP timeline for startup sequence.
5. Add Lenis + scroll progress for orbit camera scenes.
6. Split later lab pages with dynamic imports to reduce first-load bundle size.
