# NEON TOON ORBIT

Realtime anime tech-art portfolio built with Vite, React, TypeScript, Three.js, and React Three Fiber.

## Start Development

Required on each development computer:

```text
Node.js 22 LTS or newer
npm 10 or newer
```

```bash
npm install
npm run dev
```

Open:

```text
http://localhost:5173
```

Keep `npm run dev` running in the terminal while debugging. Do not start it hidden in the background, because Vite errors and hot-reload logs are useful.

Local editor:

```bash
npm run editor
```

```text
http://localhost:5174/editor.html
```

The editor uses a separate HTML entry. The normal production build only uses `index.html`, so the runtime experience is separate from the editing UI.

Imported `.glb` files are previewed locally. Put published models in:

```text
public/models/
```

Timeline data is saved inside `src/data/scenes/homeScene.json`. The runtime page reads the same timeline through `src/engine/runtime/TimelineScene.tsx`.

## Validate

```bash
npm run typecheck
npm run build
```

## Main Docs

- `docs/DEVELOPMENT_SETUP.md`
- `docs/TECH_STACK.md`
- `docs/ARCHITECTURE.md`
- `docs/CODING_GUIDE.md`
- `docs/DEBUGGING.md`
- `docs/LOCAL_EDITOR.md`
- `docs/ROADMAP.md`

## Legacy Files

The old static site was moved to:

```text
backup/legacy-static/
```
