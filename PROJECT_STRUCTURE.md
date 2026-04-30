# NEON TOON ORBIT Project Structure

This branch is now organized for a Vite + React + Three.js interactive portfolio.
Detailed technical notes live in `docs/`.

```text
src/
  components/
    layout/        App frame and persistent HUD
    ui/            Reusable controls
    navigation/    Module entry navigation
    panels/        Hologram and status panels
  canvas/          React Three Fiber scene modules
  shaders/         GLSL and shader notes by effect family
  pages/           Home and future lab/archive pages
  data/            Project, skill, and shader configuration
  hooks/           Input, scroll, transition, and performance helpers
  state/           Shared interaction state
  assets/          Future models, textures, videos, audio, references
```

Legacy static-site files were moved to `backup/legacy-static/`.

Start here:

- `docs/DEVELOPMENT_SETUP.md`
- `docs/TECH_STACK.md`
- `docs/ARCHITECTURE.md`
- `docs/CODING_GUIDE.md`
- `docs/DEBUGGING.md`
- `docs/LOCAL_EDITOR.md`
- `docs/ROADMAP.md`
