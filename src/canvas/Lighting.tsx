import type { SceneConfig } from "../types/scene";

type LightingProps = {
  config: SceneConfig["lighting"];
};

export function Lighting({ config }: LightingProps) {
  return (
    <>
      <ambientLight intensity={0.35} />
      <directionalLight color={config.keyColor} intensity={config.keyIntensity} position={[2.2, 3.4, 4]} />
      <pointLight color={config.rimColor} intensity={config.rimIntensity} position={[-2.5, 1.2, -2.5]} />
      <pointLight color={config.accentColor} intensity={config.accentIntensity} position={[2.8, 0.8, -1.2]} />
    </>
  );
}
