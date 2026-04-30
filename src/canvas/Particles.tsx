import { Points, PointMaterial } from "@react-three/drei";
import { useMemo } from "react";
import type { SceneConfig } from "../types/scene";

type OrbitParticlesProps = {
  config: SceneConfig["effects"];
};

export function OrbitParticles({ config }: OrbitParticlesProps) {
  const positions = useMemo(() => {
    const result = new Float32Array(config.particleCount * 3);
    for (let i = 0; i < result.length; i += 3) {
      const radius = 1.8 + Math.random() * 2.6;
      const angle = Math.random() * Math.PI * 2;
      result[i] = Math.cos(angle) * radius;
      result[i + 1] = Math.random() * 3.2 - 1.1;
      result[i + 2] = Math.sin(angle) * radius - 0.8;
    }
    return result;
  }, [config.particleCount]);

  return (
    <Points positions={positions} stride={3}>
      <PointMaterial color={config.particleColor} size={0.025} transparent opacity={0.74} />
    </Points>
  );
}
