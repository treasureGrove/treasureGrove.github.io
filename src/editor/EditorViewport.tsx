import { Scene } from "../canvas/Scene";
import type { SceneConfig } from "../types/scene";

type EditorViewportProps = {
  config: SceneConfig;
};

export function EditorViewport({ config }: EditorViewportProps) {
  return (
    <div className="editor-viewport">
      <Scene config={config} editorMode />
      <div className="editor-orbit-hint">Orbit: drag / zoom / inspect scene</div>
    </div>
  );
}
