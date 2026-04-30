# Development Setup

## Can I Debug On Another Computer?

Yes, but that computer needs the Node/npm dependency environment.

This project is not a plain double-click HTML project during development. It uses Vite, React, TypeScript, Three.js, React Three Fiber, and custom editor UI code. Those dependencies are installed through npm.

## Required Software

Install these on the other computer:

```text
Node.js 22 LTS or newer
npm 10 or newer
Git
Modern browser: Chrome, Edge, or Firefox
```

Current working environment used while setting this project up:

```text
npm 11.13.0
```

Node 22 LTS is recommended because the current toolchain is modern Vite + TypeScript.

## First-Time Setup On Another Computer

Clone or copy the repository, then run:

```bash
npm install
```

This creates:

```text
node_modules/
```

`node_modules/` is intentionally not committed to git.

## Start Runtime Page

```bash
npm run dev
```

Open:

```text
http://localhost:5173/
```

## Start Local Editor

Use the same dev server:

```bash
npm run dev
```

Open:

```text
http://localhost:5173/editor.html
```

The editor is local-development tooling. It is not included in the normal production build output.

## Validate Environment

Run:

```bash
node --version
npm --version
npm run typecheck
npm run build
```

If both `typecheck` and `build` pass, the computer is ready for development.

## Why npm install Is Required

The source code imports packages like:

```text
react
three
@react-three/fiber
@react-three/drei
@react-three/postprocessing
zustand
```

Those packages live in `node_modules/`. Without `npm install`, Vite cannot resolve imports and the app cannot run.

## Why Not Double-Click index.html?

Development uses:

```text
http://localhost:5173
```

not:

```text
file://index.html
```

because the browser needs Vite to process:

- TypeScript
- React JSX
- ES module imports
- npm package imports
- GLB / texture / shader asset imports
- hot reload

Double-clicking HTML skips all of that and will break development.

## Production Build

When you are ready to publish:

```bash
npm run build
```

Vite generates:

```text
dist/
  index.html
  assets/
```

Those are static files and can be uploaded to GitHub Pages or any static web host.

## Troubleshooting

### npm install fails

Check internet access and npm registry access:

```bash
npm config get registry
```

Expected default:

```text
https://registry.npmjs.org/
```

### Port 5173 is already used

Run:

```bash
npm run dev -- --port 5174
```

Then open:

```text
http://localhost:5174/
http://localhost:5174/editor.html
```

### Editor opens but controls are missing

Make sure you opened:

```text
/editor.html
```

not:

```text
/editor
```

### Scene is blank

Check:

1. Terminal running `npm run dev`
2. Browser console
3. `src/data/scenes/homeScene.json`
4. `src/canvas/Scene.tsx`
5. `src/canvas/MainCharacter.tsx`
