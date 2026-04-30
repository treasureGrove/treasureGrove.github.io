import type {
  BezierCurve,
  SceneConfig,
  TimelineConfig,
  TimelineInterpolation,
  TimelineKeyframe,
  TimelineValue,
} from "../../types/scene";

function cloneConfig(config: SceneConfig): SceneConfig {
  return structuredClone(config);
}

function getProperty(target: unknown, path: string): TimelineValue | undefined {
  return path.split(".").reduce<unknown>((current, key) => {
    if (current && typeof current === "object" && key in current) {
      return (current as Record<string, unknown>)[key];
    }
    return undefined;
  }, target) as TimelineValue | undefined;
}

function setProperty(target: unknown, path: string, value: TimelineValue) {
  const keys = path.split(".");
  const last = keys.pop();
  if (!last) return;

  const parent = keys.reduce<unknown>((current, key) => {
    if (current && typeof current === "object" && key in current) {
      return (current as Record<string, unknown>)[key];
    }
    return undefined;
  }, target);

  if (parent && typeof parent === "object") {
    (parent as Record<string, TimelineValue>)[last] = value;
  }
}

function easeInOut(t: number) {
  return t < 0.5 ? 2 * t * t : 1 - Math.pow(-2 * t + 2, 2) / 2;
}

function cubicBezierValue(t: number, p1: number, p2: number) {
  const inv = 1 - t;
  return 3 * inv * inv * t * p1 + 3 * inv * t * t * p2 + t * t * t;
}

function cubicBezierDerivative(t: number, p1: number, p2: number) {
  const inv = 1 - t;
  return 3 * inv * inv * p1 + 6 * inv * t * (p2 - p1) + 3 * t * t * (1 - p2);
}

function solveBezierT(x: number, curve: BezierCurve) {
  let t = x;
  for (let i = 0; i < 5; i += 1) {
    const currentX = cubicBezierValue(t, curve.x1, curve.x2) - x;
    const derivative = cubicBezierDerivative(t, curve.x1, curve.x2);
    if (Math.abs(derivative) < 0.0001) break;
    t = Math.min(1, Math.max(0, t - currentX / derivative));
  }
  return t;
}

function applyInterpolation(raw: number, interpolation: TimelineInterpolation, curve?: BezierCurve) {
  if (interpolation === "constant") return 0;
  if (interpolation === "smoothstep") return easeInOut(raw);
  if (interpolation === "bezier") {
    const bezier = curve ?? { x1: 0.25, y1: 0.1, x2: 0.25, y2: 1 };
    return cubicBezierValue(solveBezierT(raw, bezier), bezier.y1, bezier.y2);
  }
  return raw;
}

function mixNumber(a: number, b: number, t: number) {
  return a + (b - a) * t;
}

function isHexColor(value: TimelineValue): value is string {
  return typeof value === "string" && /^#[0-9a-fA-F]{6}$/.test(value);
}

function mixHexColor(a: string, b: string, t: number) {
  const ar = Number.parseInt(a.slice(1, 3), 16);
  const ag = Number.parseInt(a.slice(3, 5), 16);
  const ab = Number.parseInt(a.slice(5, 7), 16);
  const br = Number.parseInt(b.slice(1, 3), 16);
  const bg = Number.parseInt(b.slice(3, 5), 16);
  const bb = Number.parseInt(b.slice(5, 7), 16);

  const toHex = (value: number) => Math.round(value).toString(16).padStart(2, "0");
  return `#${toHex(mixNumber(ar, br, t))}${toHex(mixNumber(ag, bg, t))}${toHex(mixNumber(ab, bb, t))}`;
}

function mixValue(a: TimelineValue, b: TimelineValue, t: number): TimelineValue {
  if (typeof a === "number" && typeof b === "number") {
    return mixNumber(a, b, t);
  }

  if (Array.isArray(a) && Array.isArray(b)) {
    return [
      mixNumber(a[0], b[0], t),
      mixNumber(a[1], b[1], t),
      mixNumber(a[2], b[2], t),
    ];
  }

  if (isHexColor(a) && isHexColor(b)) {
    return mixHexColor(a, b, t);
  }

  return t < 1 ? a : b;
}

function sortKeyframes(keyframes: TimelineKeyframe[]) {
  return [...keyframes].sort((a, b) => a.time - b.time);
}

function evaluateKeyframes(
  keyframes: TimelineKeyframe[],
  time: number,
  interpolation: TimelineInterpolation,
  curve?: BezierCurve,
): TimelineValue | undefined {
  const sorted = sortKeyframes(keyframes);
  if (sorted.length === 0) return undefined;
  if (time <= sorted[0].time) return sorted[0].value;
  if (time >= sorted[sorted.length - 1].time) return sorted[sorted.length - 1].value;

  for (let i = 0; i < sorted.length - 1; i += 1) {
    const from = sorted[i];
    const to = sorted[i + 1];
    if (time >= from.time && time <= to.time) {
      const span = to.time - from.time;
      const raw = span <= 0 ? 1 : (time - from.time) / span;
      const t = applyInterpolation(raw, interpolation, curve);
      return mixValue(from.value, to.value, t);
    }
  }

  return undefined;
}

export function evaluateTimeline(config: SceneConfig, timeline: TimelineConfig, time: number): SceneConfig {
  const next = cloneConfig(config);

  for (const track of timeline.tracks) {
    const value = evaluateKeyframes(track.keyframes, time, track.interpolation ?? "linear", track.bezier);
    if (value !== undefined) {
      setProperty(next, track.propertyPath, value);
    }
  }

  return next;
}

export function readTimelineValue(config: SceneConfig, propertyPath: string): TimelineValue | undefined {
  return getProperty(config, propertyPath);
}
