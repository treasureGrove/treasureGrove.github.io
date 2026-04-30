import { readTimelineValue } from "../engine/timeline/evaluateTimeline";
import type { SceneConfig, TimelineConfig, TimelineTrack } from "../types/scene";
import { timelineProperties } from "./timelineProperties";

export function addKeyframeToTimeline(
  config: SceneConfig,
  timeline: TimelineConfig,
  propertyPath: string,
  time: number,
): TimelineConfig {
  const property = timelineProperties.find((item) => item.path === propertyPath);
  const value = readTimelineValue(config, propertyPath);
  if (!property || value === undefined) return timeline;

  const existingTrack = timeline.tracks.find((track) => track.id === propertyPath);
  const nextTrack: TimelineTrack = existingTrack ?? {
    id: propertyPath,
    target: "scene",
    propertyPath,
    label: property.label,
    interpolation: "linear",
    bezier: { x1: 0.25, y1: 0.1, x2: 0.25, y2: 1 },
    keyframes: [],
  };

  const nextKeyframes = [
    ...nextTrack.keyframes.filter((keyframe) => Math.abs(keyframe.time - time) > 0.03),
    {
      time: Number(time.toFixed(2)),
      value,
    },
  ].sort((a, b) => a.time - b.time);

  const nextTracks = [
    ...timeline.tracks.filter((track) => track.id !== propertyPath),
    {
      ...nextTrack,
      keyframes: nextKeyframes,
    },
  ].sort((a, b) => a.label.localeCompare(b.label));

  return {
    ...timeline,
    tracks: nextTracks,
  };
}

export function formatTimelineValue(value: unknown) {
  if (Array.isArray(value)) {
    return `[${value.map((item) => Number(item).toFixed(2)).join(", ")}]`;
  }

  if (typeof value === "number") {
    return value.toFixed(2);
  }

  if (value === null) {
    return "null";
  }

  return String(value);
}
