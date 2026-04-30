import type { TimelineConfig } from "../types/scene";

type TimelinePanelProps = {
  currentTime: number;
  isPlaying: boolean;
  timeline: TimelineConfig;
  onChangeTime: (time: number) => void;
  onScrubTime: (time: number) => void;
  onTogglePlay: () => void;
  onUpdateTimeline: (timeline: TimelineConfig) => void;
};

export function TimelinePanel({
  currentTime,
  isPlaying,
  timeline,
  onChangeTime,
  onScrubTime,
  onTogglePlay,
  onUpdateTimeline,
}: TimelinePanelProps) {
  const clearTrack = (trackId: string) => {
    onUpdateTimeline({
      ...timeline,
      tracks: timeline.tracks.filter((track) => track.id !== trackId),
    });
  };

  const updateTrackInterpolation = (trackId: string, interpolation: TimelineConfig["tracks"][number]["interpolation"]) => {
    onUpdateTimeline({
      ...timeline,
      tracks: timeline.tracks.map((track) =>
        track.id === trackId
          ? {
              ...track,
              interpolation,
            }
          : track,
      ),
    });
  };

  const updateTrackBezier = (
    trackId: string,
    key: "x1" | "y1" | "x2" | "y2",
    value: number,
  ) => {
    onUpdateTimeline({
      ...timeline,
      tracks: timeline.tracks.map((track) =>
        track.id === trackId
          ? {
              ...track,
              bezier: {
                x1: track.bezier?.x1 ?? 0.25,
                y1: track.bezier?.y1 ?? 0.1,
                x2: track.bezier?.x2 ?? 0.25,
                y2: track.bezier?.y2 ?? 1,
                [key]: value,
              },
            }
          : track,
      ),
    });
  };

  return (
    <section className="timeline-panel">
      <div className="timeline-controls">
        <button type="button" onClick={onTogglePlay}>
          {isPlaying ? "Pause" : "Play"}
        </button>
        <span>{currentTime.toFixed(2)}s</span>
        <label className="timeline-duration">
          Duration
          <input
            min={1}
            step={0.5}
            type="number"
            value={timeline.duration}
            onChange={(event) => {
              const duration = Math.max(1, Number(event.target.value));
              onUpdateTimeline({ ...timeline, duration });
              onChangeTime(Math.min(currentTime, duration));
            }}
          />
        </label>
        <input
          max={timeline.duration}
          min={0}
          step={0.01}
          type="range"
          value={currentTime}
          onChange={(event) => onScrubTime(Number(event.target.value))}
        />
      </div>

      <div className="timeline-tracks">
        {timeline.tracks.length === 0 ? (
          <div className="timeline-empty">No keyframes yet.</div>
        ) : (
          timeline.tracks.map((track) => (
            <div className="timeline-track" key={track.id}>
              <button type="button" onClick={() => clearTrack(track.id)}>
                Clear
              </button>
              <span>{track.label}</span>
              <select
                value={track.interpolation ?? "linear"}
                onChange={(event) =>
                  updateTrackInterpolation(
                    track.id,
                    event.target.value as TimelineConfig["tracks"][number]["interpolation"],
                  )
                }
              >
                <option value="constant">Constant</option>
                <option value="linear">Linear</option>
                <option value="smoothstep">Smooth</option>
                <option value="bezier">Bezier</option>
              </select>
              <div className="timeline-keyframes">
                {track.keyframes.map((keyframe) => (
                  <i
                    key={`${track.id}-${keyframe.time}`}
                    style={{ left: `${(keyframe.time / timeline.duration) * 100}%` }}
                    title={`${keyframe.time}s`}
                  />
                ))}
              </div>
              {track.interpolation === "bezier" ? (
                <div className="bezier-controls">
                  {(["x1", "y1", "x2", "y2"] as const).map((key) => (
                    <label key={key}>
                      {key}
                      <input
                        max={1}
                        min={0}
                        step={0.01}
                        type="number"
                        value={track.bezier?.[key] ?? (key === "y2" ? 1 : 0.25)}
                        onChange={(event) => updateTrackBezier(track.id, key, Number(event.target.value))}
                      />
                    </label>
                  ))}
                </div>
              ) : null}
            </div>
          ))
        )}
      </div>
    </section>
  );
}
