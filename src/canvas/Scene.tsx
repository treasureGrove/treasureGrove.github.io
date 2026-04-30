import { Canvas } from "@react-three/fiber";
import { OrbitControls } from "@react-three/drei";
import type { SceneConfig } from "../types/scene";
import { CameraRig } from "./CameraRig";
import { EnergyRing } from "./EnergyRing";
import { FloatingPanels } from "./FloatingPanels";
import { Lighting } from "./Lighting";
import { MainCharacter } from "./MainCharacter";
import { OrbitParticles } from "./Particles";
import { PostEffects } from "./PostEffects";
import { SceneDebugHelpers } from "./SceneDebugHelpers";

type SceneProps = {
  config: SceneConfig;
  editorMode?: boolean;
};

export function Scene({ config, editorMode = false }: SceneProps) {
  return (
    <Canvas camera={{ position: config.camera.position, fov: config.camera.fov }} dpr={[1, 1.75]}>
      <color attach="background" args={["#03040a"]} />
      <CameraRig enabled={!editorMode} target={config.camera.target}>
        <Lighting config={config.lighting} />
        <EnergyRing config={config.effects} />
        <MainCharacter config={config.character} />
        <OrbitParticles config={config.effects} />
        <FloatingPanels />
        <SceneDebugHelpers config={config.debug} />
        <PostEffects config={config.effects} />
      </CameraRig>
      {editorMode ? <OrbitControls makeDefault target={config.camera.target} /> : null}
    </Canvas>
  );
}
