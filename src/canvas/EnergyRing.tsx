import { useRef } from "react";
import { useFrame } from "@react-three/fiber";
import type { Mesh } from "three";
import { useExperienceStore } from "../state/useExperienceStore";
import type { SceneConfig } from "../types/scene";

type EnergyRingProps = {
  config: SceneConfig["effects"];
};

export function EnergyRing({ config }: EnergyRingProps) {
  const ring = useRef<Mesh>(null);
  const selectedModule = useExperienceStore((state) => state.selectedModule);

  useFrame((_, delta) => {
    if (ring.current) {
      ring.current.rotation.z += delta * (selectedModule ? config.energyRingSpeed * 2.7 : config.energyRingSpeed);
    }
  });

  return (
    <mesh ref={ring} position={[0, 0.75, -0.55]} rotation={[0.18, 0, 0]}>
      <torusGeometry args={[1.95, 0.012, 8, 180]} />
      <meshBasicMaterial color={config.energyRingColor} />
    </mesh>
  );
}
