import { Bloom, EffectComposer, Vignette } from "@react-three/postprocessing";
import type { SceneConfig } from "../types/scene";

type PostEffectsProps = {
  config: SceneConfig["effects"];
};

export function PostEffects({ config }: PostEffectsProps) {
  return (
    <EffectComposer multisampling={0}>
      <Bloom intensity={config.bloomIntensity} luminanceThreshold={0.2} mipmapBlur />
      <Vignette darkness={config.vignetteDarkness} offset={0.28} />
    </EffectComposer>
  );
}
