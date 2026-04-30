import { useEffect, useMemo, useState } from "react";
import { Scene } from "../../canvas/Scene";
import type { SceneConfig } from "../../types/scene";
import { evaluateTimeline } from "../timeline/evaluateTimeline";

type TimelineSceneProps = {
  config: SceneConfig;
  editorMode?: boolean;
  time?: number;
  autoplay?: boolean;
};

export function TimelineScene({ config, editorMode = false, time, autoplay = false }: TimelineSceneProps) {
  const [internalTime, setInternalTime] = useState(0);

  useEffect(() => {
    if (!autoplay || time !== undefined) return undefined;

    let frameId = 0;
    let last = performance.now();

    const tick = (now: number) => {
      const delta = (now - last) / 1000;
      last = now;
      setInternalTime((current) => {
        const next = current + delta;
        return next > config.timeline.duration ? 0 : next;
      });
      frameId = requestAnimationFrame(tick);
    };

    frameId = requestAnimationFrame(tick);
    return () => cancelAnimationFrame(frameId);
  }, [autoplay, config.timeline.duration, time]);

  const timelineTime = time ?? internalTime;
  const evaluatedConfig = useMemo(
    () => evaluateTimeline(config, config.timeline, timelineTime),
    [config, timelineTime],
  );

  return <Scene config={evaluatedConfig} editorMode={editorMode} />;
}
