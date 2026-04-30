# Technical Stack

## Goal

This project is a realtime 3D anime tech-art portfolio. The site should feel like an interactive WebGL scene first, not a traditional static homepage.

The MVP focuses on the home experience:

- Central stylized 3D character placeholder
- Toon-shader direction
- Orbiting energy ring
- Particle field
- Mouse parallax camera rig
- Hologram module navigation
- Bloom and vignette post effects

## Chosen Stack

| Area | Choice | Why |
| --- | --- | --- |
| Build tool | Vite | Fast dev server, simple static deployment, good WebGL asset support |
| UI runtime | React | Good component model for HUD, panels, pages, and state-driven interactions |
| Language | TypeScript | Keeps scene config, shader params, project data, and interaction state typed |
| 3D engine | Three.js | Standard WebGL engine for browser-based 3D |
| 3D React layer | React Three Fiber | Lets us organize the scene as composable React components |
| 3D helpers | Drei | Provides common helpers such as GLTF loading, text, controls, points, and environment tools |
| Post FX | @react-three/postprocessing | Bloom, vignette, depth of field, and later chromatic aberration / film grain |
| Timeline animation | GSAP | Future camera transitions, scroll scenes, module enter effects |
| Smooth scroll | Lenis | Future scroll-controlled cinematic camera movement |
| Icons | lucide-react | Clean UI icon system for tool buttons and panels |
| State | Zustand | Lightweight global state for selected module, performance mode, and transition phase |
| Editor controls | Custom React inspector | Parameter rows with inline `K` buttons and timeline integration |

## Why Not Other Paths

Unity WebGL is not the first choice because it usually produces a heavier first load and is harder to blend with regular portfolio content.

Pure Three.js is possible, but the scene will quickly grow into many systems. React Three Fiber gives each system a clear file and lifecycle.

Next.js is not necessary for this phase. The current goal is a visual WebGL experience and static deployment. Vite is lighter and faster for iteration.

## Development Rule

Do not put everything in one scene file. Each visual system gets its own module:

- Camera behavior goes in `src/canvas/CameraRig.tsx`
- Character rendering goes in `src/canvas/MainCharacter.tsx`
- Particle systems go in `src/canvas/Particles.tsx`
- Energy-ring logic goes in `src/canvas/EnergyRing.tsx`
- Post effects go in `src/canvas/PostEffects.tsx`
- HUD and page UI stay in `src/components/` and `src/pages/`

## Current Commands

```bash
npm install
npm run dev
npm run typecheck
npm run build
```

`npm run build` runs TypeScript checking first, then produces the static site in `dist/`.
