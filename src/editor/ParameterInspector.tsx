import { readTimelineValue } from "../engine/timeline/evaluateTimeline";
import type { SceneConfig, TimelineConfig, TimelineValue, Vec3 } from "../types/scene";
import { addKeyframeToTimeline } from "./keyframeTools";
import { timelineProperties } from "./timelineProperties";

type ParameterInspectorProps = {
  currentTime: number;
  editConfig: SceneConfig;
  isPlaying: boolean;
  previewConfig: SceneConfig;
  timeline: TimelineConfig;
  onChangeConfig: (propertyPath: string, value: TimelineValue) => void;
  onUpdateTimeline: (timeline: TimelineConfig) => void;
};

const groups = [
  { label: "Character", prefix: "character." },
  { label: "Camera", prefix: "camera." },
  { label: "Lighting", prefix: "lighting." },
  { label: "Effects", prefix: "effects." },
  { label: "Debug", prefix: "debug." },
];

function isColorPath(path: string) {
  return path.toLowerCase().includes("color");
}

function numberRange(path: string, value: number) {
  if (path.includes("rotation")) return { min: -Math.PI, max: Math.PI, step: 0.01 };
  if (path.includes("scale")) return { min: 0.01, max: 5, step: 0.01 };
  if (path.includes("fov")) return { min: 10, max: 90, step: 1 };
  if (path.includes("particleCount")) return { min: 0, max: 3000, step: 1 };
  if (path.toLowerCase().includes("intensity")) return { min: 0, max: 10, step: 0.01 };
  if (path.toLowerCase().includes("speed")) return { min: 0, max: 5, step: 0.01 };
  if (path.toLowerCase().includes("darkness")) return { min: 0, max: 1, step: 0.01 };
  const span = Math.max(4, Math.abs(value) * 2);
  return { min: -span, max: span, step: 0.01 };
}

function isVec3(value: TimelineValue | undefined): value is Vec3 {
  return Array.isArray(value) && value.length === 3;
}

function labelText(groupLabel: string, label: string) {
  return label.replace(`${groupLabel} `, "");
}

export function ParameterInspector({
  currentTime,
  editConfig,
  isPlaying,
  previewConfig,
  timeline,
  onChangeConfig,
  onUpdateTimeline,
}: ParameterInspectorProps) {
  const visibleConfig = isPlaying ? previewConfig : editConfig;
  const keySourceConfig = isPlaying ? previewConfig : editConfig;

  const keyProperty = (propertyPath: string) => {
    onUpdateTimeline(addKeyframeToTimeline(keySourceConfig, timeline, propertyPath, currentTime));
  };

  const isKeyed = (propertyPath: string) =>
    timeline.tracks.some((track) =>
      track.propertyPath === propertyPath
      && track.keyframes.some((keyframe) => Math.abs(keyframe.time - currentTime) <= 0.03),
    );

  return (
    <aside className="parameter-inspector">
      <header>
        <strong>{isPlaying ? "Playback Parameters" : "Edit Parameters"}</strong>
        <span>{currentTime.toFixed(2)}s</span>
      </header>
      <div className="parameter-groups">
        {groups.map((group) => (
          <section key={group.prefix}>
            <h2>{group.label}</h2>
            {timelineProperties
              .filter((property) => property.path.startsWith(group.prefix))
              .map((property) => {
                const value = readTimelineValue(visibleConfig, property.path);
                const disabled = isPlaying;

                return (
                  <div className="parameter-row" key={property.path}>
                    <span>{labelText(group.label, property.label)}</span>
                    <ParameterInput
                      disabled={disabled}
                      path={property.path}
                      value={value}
                      onChange={(nextValue) => onChangeConfig(property.path, nextValue)}
                    />
                    <button
                      className={isKeyed(property.path) ? "is-keyed" : ""}
                      type="button"
                      title={`Key ${property.label}`}
                      onClick={() => keyProperty(property.path)}
                    >
                      K
                    </button>
                  </div>
                );
              })}
          </section>
        ))}
      </div>
    </aside>
  );
}

function ParameterInput({
  disabled,
  path,
  value,
  onChange,
}: {
  disabled: boolean;
  path: string;
  value: TimelineValue | undefined;
  onChange: (value: TimelineValue) => void;
}) {
  if (isVec3(value)) {
    return (
      <div className="vec3-input">
        {value.map((item, index) => (
          <input
            disabled={disabled}
            key={index}
            step={0.01}
            type="number"
            value={Number(item.toFixed(3))}
            onChange={(event) => {
              const next = [...value] as Vec3;
              next[index] = Number(event.target.value);
              onChange(next);
            }}
          />
        ))}
      </div>
    );
  }

  if (typeof value === "number") {
    const range = numberRange(path, value);
    return (
      <div className="number-input">
        <input
          disabled={disabled}
          max={range.max}
          min={range.min}
          step={range.step}
          type="range"
          value={value}
          onChange={(event) => onChange(Number(event.target.value))}
        />
        <input
          disabled={disabled}
          step={range.step}
          type="number"
          value={Number(value.toFixed(3))}
          onChange={(event) => onChange(Number(event.target.value))}
        />
      </div>
    );
  }

  if (typeof value === "boolean") {
    return (
      <input
        checked={value}
        disabled={disabled}
        type="checkbox"
        onChange={(event) => onChange(event.target.checked)}
      />
    );
  }

  if (path === "character.animation") {
    return (
      <select disabled={disabled} value={String(value)} onChange={(event) => onChange(event.target.value)}>
        <option value="idle">idle</option>
        <option value="float">float</option>
        <option value="turn">turn</option>
      </select>
    );
  }

  if (typeof value === "string" && isColorPath(path)) {
    return (
      <input disabled={disabled} type="color" value={value} onChange={(event) => onChange(event.target.value)} />
    );
  }

  return (
    <input
      disabled={disabled}
      placeholder="null"
      type="text"
      value={value ?? ""}
      onChange={(event) => onChange(event.target.value || null)}
    />
  );
}
