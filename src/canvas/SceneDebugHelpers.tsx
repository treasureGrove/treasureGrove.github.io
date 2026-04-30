import type { SceneConfig } from "../types/scene";

type SceneDebugHelpersProps = {
  config: SceneConfig["debug"];
};

export function SceneDebugHelpers({ config }: SceneDebugHelpersProps) {
  return (
    <>
      {config.showGrid ? <gridHelper args={[8, 16, "#36d9ff", "#163246"]} /> : null}
      {config.showAxes ? <axesHelper args={[2]} /> : null}
    </>
  );
}
