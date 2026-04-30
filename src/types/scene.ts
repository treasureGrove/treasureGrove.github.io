export type Vec3 = [number, number, number];

export type TimelineValue = number | boolean | string | null | Vec3;

export type TimelineInterpolation = "constant" | "linear" | "smoothstep" | "bezier";

export type BezierCurve = {
  x1: number;
  y1: number;
  x2: number;
  y2: number;
};

export type TimelineKeyframe = {
  time: number;
  value: TimelineValue;
};

export type TimelineTrack = {
  id: string;
  target: string;
  propertyPath: string;
  label: string;
  interpolation: TimelineInterpolation;
  bezier?: BezierCurve;
  keyframes: TimelineKeyframe[];
};

export type TimelineConfig = {
  duration: number;
  tracks: TimelineTrack[];
};

export type SceneConfig = {
  character: {
    modelUrl: string | null;
    animationClip: string | null;
    position: Vec3;
    rotation: Vec3;
    scale: number;
    animation: "idle" | "float" | "turn";
    animationSpeed: number;
    autoRotate: boolean;
  };
  camera: {
    position: Vec3;
    fov: number;
    target: Vec3;
  };
  lighting: {
    keyColor: string;
    keyIntensity: number;
    rimColor: string;
    rimIntensity: number;
    accentColor: string;
    accentIntensity: number;
  };
  effects: {
    energyRingColor: string;
    energyRingSpeed: number;
    particleColor: string;
    particleCount: number;
    bloomIntensity: number;
    vignetteDarkness: number;
  };
  debug: {
    showGrid: boolean;
    showAxes: boolean;
    showHelpers: boolean;
  };
  timeline: TimelineConfig;
};
