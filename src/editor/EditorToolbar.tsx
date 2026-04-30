import type { ChangeEvent } from "react";
import type { SceneConfig } from "../types/scene";

type EditorToolbarProps = {
  config: SceneConfig;
  onImportModel: (file: File) => void;
};

export function EditorToolbar({ config, onImportModel }: EditorToolbarProps) {
  const exportConfig = () => {
    const blob = new Blob([JSON.stringify(config, null, 2)], { type: "application/json" });
    const url = URL.createObjectURL(blob);
    const link = document.createElement("a");
    link.href = url;
    link.download = "homeScene.json";
    link.click();
    URL.revokeObjectURL(url);
  };

  const copyConfig = async () => {
    await navigator.clipboard.writeText(JSON.stringify(config, null, 2));
  };

  const importModel = (event: ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (!file) return;
    onImportModel(file);
    event.target.value = "";
  };

  return (
    <div className="editor-toolbar">
      <strong>Local Scene Editor</strong>
      <label>
        Import GLB
        <input accept=".glb,.gltf,model/gltf-binary,model/gltf+json" type="file" onChange={importModel} />
      </label>
      <button type="button" onClick={copyConfig}>
        Copy JSON
      </button>
      <button type="button" onClick={exportConfig}>
        Export JSON
      </button>
      <a href="/" target="_blank" rel="noreferrer">
        Open Runtime
      </a>
    </div>
  );
}
