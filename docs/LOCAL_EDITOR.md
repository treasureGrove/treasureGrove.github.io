# Local Scene Editor

## Purpose

The editor is a local browser tool for composing the 3D hero scene before publishing it as a portfolio page.

It is development-only and is not meant to be uploaded as a public editing tool. It exists so you can visually tune:

- local GLB model preview
- character transform
- placeholder animation state
- keyframed timeline playback
- camera position and FOV
- lighting colors and intensity
- energy ring color and speed
- particle count and color
- bloom and vignette
- debug grid and axes

## Run

On a new computer, install dependencies first:

```bash
npm install
```

```bash
npm run dev
```

Open:

```text
http://localhost:5173/editor.html
```

Or run the dedicated editor command:

```bash
npm run editor
```

It opens:

```text
http://localhost:5174/editor.html
```

The normal runtime page remains:

```text
http://localhost:5173/
```

The editor uses `editor.html` as a separate development entry. The normal runtime page only reads the saved JSON config from `src/data/scenes/homeScene.json`.

## Workflow

1. Open `/editor.html`.
2. Import a `.glb` model if needed.
3. Tune the scene in the parameter inspector.
4. Scrub the timeline and add keyframes for supported properties.
5. Use `Copy JSON` or `Export JSON`.
6. Replace the contents of `src/data/scenes/homeScene.json`.
7. Put the model in `public/models/` using the same filename shown in the exported JSON.
8. Open `/` to see the runtime page using the saved scene config.

This keeps the public page clean while letting you edit visually.

## Current Limit

The browser cannot directly overwrite files in `src/data/scenes/` without adding a local Node save API. For now, export or copy the JSON and replace `homeScene.json`.

Imported GLB files are previewed with a temporary `blob:` URL. That URL is only valid in the current browser session. When exporting JSON, the editor writes the runtime model path as:

```text
/models/<filename>.glb
```

So the real model should be copied to:

```text
public/models/<filename>.glb
```

## Timeline

The timeline can keyframe all serializable scene parameters exposed by `SceneConfig`, including:

- character model path
- character animation clip
- character transform
- character animation mode and speed
- camera position, target, and FOV
- lighting colors and intensities
- energy ring color and speed
- particle color and count
- bloom and vignette
- debug display flags

Basic use:

1. Move the time slider.
2. Tune a property in the parameter inspector.
3. Find the same property in `Keyframe Inspector`.
4. Click the `K` button beside that property.
5. Move to another time and repeat.
6. Press `Play`.

The bottom timeline is for playback, scrubbing, duration, and track visibility. Keyframes are created from the property-side `K` buttons, closer to Blender / Unreal style.

Each track has an interpolation mode:

- `Constant`: hold the previous keyframe value until the next key.
- `Linear`: default engine-style interpolation.
- `Smooth`: ease-in-out interpolation.
- `Bezier`: cubic Bezier interpolation with editable `x1/y1/x2/y2` control values.

The Bezier data model is already in the timeline. A visual curve editor can be added on top of the same data later.

Playback mode:

- Pause: parameter inputs are editable and update the viewport immediately.
- Play: the viewport is driven by evaluated timeline data; inputs show playback values and are locked.
- Scrub the timeline while paused: the viewport previews evaluated timeline data at the playhead.
- Edit any parameter while paused: the viewport returns to live edit preview.
- Pressing `K` while playing records the evaluated value at the current frame.

Later we can add a small local-only save endpoint so the editor can write the JSON file with one click during development.

## Next Editor Features

- TransformControls drag gizmo
- Animation clip list from imported GLB
- Skeleton and bounding-box helpers
- Light helpers
- Camera bookmark presets
- One-click local save endpoint
- Shader uniform tracks
- Scroll progress mapped to timeline time
