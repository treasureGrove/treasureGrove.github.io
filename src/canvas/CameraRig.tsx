import { useFrame } from "@react-three/fiber";
import { useRef, type PropsWithChildren } from "react";
import { Group } from "three";
import { useMouseParallax } from "../hooks/useMouseParallax";
import type { Vec3 } from "../types/scene";

type CameraRigProps = PropsWithChildren<{
  enabled?: boolean;
  target: Vec3;
}>;

export function CameraRig({ children, enabled = true, target }: CameraRigProps) {
  const rig = useRef<Group>(null);
  const pointer = useMouseParallax();

  useFrame(({ camera }) => {
    if (enabled && rig.current) {
      rig.current.rotation.y += (pointer.x * 0.12 - rig.current.rotation.y) * 0.08;
      rig.current.rotation.x += (-pointer.y * 0.08 - rig.current.rotation.x) * 0.08;
    }
    camera.lookAt(...target);
  });

  return <group ref={rig}>{children}</group>;
}
