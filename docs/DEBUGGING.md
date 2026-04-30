# Debugging

## Normal Debug Flow

Install dependencies first on any new computer:

```bash
npm install
```

Run the dev server in the foreground:

```bash
npm run dev
```

Then open:

```text
http://localhost:5173
```

This is the correct workflow because Vite prints compile errors, runtime overlay messages, and hot-module-reload status in the terminal and browser.

## Do Not Debug With Hidden Background Servers

Background servers are only useful for quick automated checks. They are bad for daily debugging because you cannot see:

- TypeScript transform errors
- Vite dependency pre-bundle errors
- Port conflicts
- React runtime stack traces
- Hot reload status

For your own development, always keep one terminal tab dedicated to `npm run dev`.

## Common Commands

```bash
npm run typecheck
```

Checks TypeScript without producing build files.

```bash
npm run build
```

Builds the production output into `dist/`.

```bash
npm run preview
```

Serves the production build locally after `npm run build`.

## Common Problems

### Port 5173 is already used

Stop the old Vite process, or run:

```bash
npm run dev -- --port 5174
```

### Browser is blank

Check these in order:

1. Terminal output from `npm run dev`
2. Browser console
3. `src/main.tsx`
4. `src/App.tsx`
5. `src/canvas/Scene.tsx`

### 3D scene is black

Check:

- Canvas is mounted in `src/pages/Home.tsx`
- Camera position in `src/canvas/Scene.tsx`
- Lights in `src/canvas/Lighting.tsx`
- Object positions in `src/canvas/MainCharacter.tsx`
- Material opacity and color values

### Build warns about large chunks

This is expected at this stage because Three.js and postprocessing are in the first bundle. Later, split lab pages and heavy effects with dynamic imports.

## Debugging 3D Logic

Most visual behavior lives in:

```text
src/canvas/
```

Most shared interaction state lives in:

```text
src/state/useExperienceStore.ts
```

Use this chain when debugging interactions:

```text
UI event -> Zustand state -> canvas component -> useFrame animation
```

For example:

```text
Hover module button
  -> ModuleDock sets selectedModule
  -> EnergyRing reads selectedModule
  -> ring rotation speed changes
```
