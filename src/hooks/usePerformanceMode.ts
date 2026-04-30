export type PerformanceMode = "high" | "medium" | "low";

export function usePerformanceMode(): PerformanceMode {
  const cores = navigator.hardwareConcurrency ?? 4;
  if (cores >= 8) return "high";
  if (cores >= 4) return "medium";
  return "low";
}
