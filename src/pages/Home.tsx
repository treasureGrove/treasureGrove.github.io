import { ModuleDock } from "../components/navigation/ModuleDock";
import { defaultSceneConfig } from "../data/scenes/defaultScene";
import { TimelineScene } from "../engine/runtime/TimelineScene";

export function Home() {
  return (
    <>
      <div className="scene-layer">
        <TimelineScene config={defaultSceneConfig} autoplay />
      </div>
      <div className="hud-layer" aria-hidden="false">
        <div />
        <ModuleDock />
        <div className="bottom-bar">
          <div className="tagline">SCROLL TO INITIALIZE ORBIT CAMERA</div>
          <div className="tagline">INITIALIZING TOON RENDER CORE...</div>
        </div>
      </div>
    </>
  );
}
