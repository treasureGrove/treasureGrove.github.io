import { useEffect, useMemo, useState } from "react";
import { defaultSceneConfig } from "../data/scenes/defaultScene";
import { evaluateTimeline } from "../engine/timeline/evaluateTimeline";
import type { SceneConfig, TimelineConfig, TimelineValue } from "../types/scene";
import { setSceneConfigValue } from "./configPath";
import { EditorToolbar } from "./EditorToolbar";
import { EditorViewport } from "./EditorViewport";
import { ParameterInspector } from "./ParameterInspector";
import { TimelinePanel } from "./TimelinePanel";
import "./editor.css";

export function EditorApp() {
  const [editConfig, setEditConfig] = useState<SceneConfig>(defaultSceneConfig);
  const [previewModelUrl, setPreviewModelUrl] = useState<string | null>(null);
  const [timeline, setTimeline] = useState<TimelineConfig>(defaultSceneConfig.timeline);
  const [currentTime, setCurrentTime] = useState(0);
  const [isPlaying, setIsPlaying] = useState(false);
  const [isScrubbing, setIsScrubbing] = useState(false);

  useEffect(() => {
    if (!isPlaying) return undefined;

    let frameId = 0;
    let last = performance.now();

    const tick = (now: number) => {
      const delta = (now - last) / 1000;
      last = now;
      setCurrentTime((time) => {
        const next = time + delta;
        return next > timeline.duration ? 0 : next;
      });
      frameId = requestAnimationFrame(tick);
    };

    frameId = requestAnimationFrame(tick);
    return () => cancelAnimationFrame(frameId);
  }, [isPlaying, timeline.duration]);

  useEffect(() => {
    return () => {
      if (previewModelUrl?.startsWith("blob:")) {
        URL.revokeObjectURL(previewModelUrl);
      }
    };
  }, [previewModelUrl]);

  const baseConfig = useMemo<SceneConfig>(
    () => ({
      ...editConfig,
      character: {
        ...editConfig.character,
        modelUrl: previewModelUrl ?? editConfig.character.modelUrl,
      },
      timeline,
    }),
    [editConfig, previewModelUrl, timeline],
  );

  const evaluatedConfig = useMemo(
    () => evaluateTimeline(baseConfig, timeline, currentTime),
    [baseConfig, currentTime, timeline],
  );

  const viewportConfig = isPlaying || isScrubbing ? evaluatedConfig : baseConfig;

  const exportConfig = useMemo<SceneConfig>(
    () => ({
      ...baseConfig,
      character: {
        ...baseConfig.character,
        modelUrl: editConfig.character.modelUrl,
      },
      timeline,
    }),
    [baseConfig, editConfig.character.modelUrl, timeline],
  );

  const importModel = (file: File) => {
    if (previewModelUrl?.startsWith("blob:")) {
      URL.revokeObjectURL(previewModelUrl);
    }

    setPreviewModelUrl(URL.createObjectURL(file));
    setEditConfig((config) => setSceneConfigValue(config, "character.modelUrl", `/models/${file.name}`));
  };

  const changeConfig = (propertyPath: string, value: TimelineValue) => {
    if (isPlaying) return;
    setIsScrubbing(false);
    setEditConfig((config) => setSceneConfigValue(config, propertyPath, value));
  };

  const scrubTime = (time: number) => {
    setIsPlaying(false);
    setIsScrubbing(true);
    setCurrentTime(time);
  };

  return (
    <main className="editor-shell">
      <EditorViewport config={viewportConfig} />
      <EditorToolbar config={exportConfig} onImportModel={importModel} />
      <ParameterInspector
        currentTime={currentTime}
        editConfig={baseConfig}
        isPlaying={isPlaying}
        previewConfig={evaluatedConfig}
        timeline={timeline}
        onChangeConfig={changeConfig}
        onUpdateTimeline={setTimeline}
      />
      <TimelinePanel
        currentTime={currentTime}
        isPlaying={isPlaying}
        timeline={timeline}
        onChangeTime={setCurrentTime}
        onScrubTime={scrubTime}
        onTogglePlay={() => {
          setIsScrubbing(false);
          setIsPlaying((value) => !value);
        }}
        onUpdateTimeline={setTimeline}
      />
    </main>
  );
}
