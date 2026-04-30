import type { SceneConfig, TimelineValue } from "../types/scene";

export function setSceneConfigValue(config: SceneConfig, propertyPath: string, value: TimelineValue): SceneConfig {
  const next = structuredClone(config);
  const keys = propertyPath.split(".");
  const last = keys.pop();
  if (!last) return next;

  const parent = keys.reduce<unknown>((current, key) => {
    if (current && typeof current === "object" && key in current) {
      return (current as Record<string, unknown>)[key];
    }
    return undefined;
  }, next);

  if (parent && typeof parent === "object") {
    (parent as Record<string, TimelineValue>)[last] = value;
  }

  return next;
}
