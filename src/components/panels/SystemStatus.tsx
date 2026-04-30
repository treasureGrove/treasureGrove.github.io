import { useExperienceStore } from "../../state/useExperienceStore";

export function SystemStatus() {
  const soundEnabled = useExperienceStore((state) => state.soundEnabled);
  const toggleSound = useExperienceStore((state) => state.toggleSound);

  return (
    <div className="status-panel" aria-label="System status">
      <button className="status-button" type="button" onClick={toggleSound}>
        SOUND {soundEnabled ? "ON" : "OFF"}
      </button>
      <span>FPS --</span>
      <span>SYSTEM READY</span>
    </div>
  );
}
