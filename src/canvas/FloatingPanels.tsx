import { useExperienceStore } from "../state/useExperienceStore";

export function FloatingPanels() {
  const selectedModule = useExperienceStore((state) => state.selectedModule);
  const shaderOpacity = selectedModule === "shader" ? 0.36 : 0.18;
  const vfxOpacity = selectedModule === "vfx" ? 0.36 : 0.18;

  return (
    <group>
      <mesh position={[-1.9, 1.35, -0.25]} rotation={[0, 0.32, 0]}>
        <planeGeometry args={[0.92, 0.28]} />
        <meshBasicMaterial color="#36d9ff" transparent opacity={shaderOpacity} />
      </mesh>
      <mesh position={[1.85, 0.45, -0.18]} rotation={[0, -0.28, 0]}>
        <planeGeometry args={[1.05, 0.28]} />
        <meshBasicMaterial color="#ff4fd8" transparent opacity={vfxOpacity} />
      </mesh>
    </group>
  );
}
