import { useAnimations, useGLTF } from "@react-three/drei";
import { useFrame } from "@react-three/fiber";
import { Suspense, useEffect, useRef } from "react";
import type { Group } from "three";
import type { SceneConfig } from "../types/scene";

type MainCharacterProps = {
  config: SceneConfig["character"];
};

export function MainCharacter({ config }: MainCharacterProps) {
  const group = useRef<Group>(null);

  useFrame(({ clock }, delta) => {
    if (!group.current) return;

    if (config.animation === "float") {
      group.current.position.y = config.position[1] + Math.sin(clock.elapsedTime * config.animationSpeed) * 0.045;
    }

    if (config.animation === "turn" || config.autoRotate) {
      group.current.rotation.y += delta * config.animationSpeed * 0.65;
    }
  });

  return (
    <group ref={group} position={config.position} rotation={config.rotation} scale={config.scale}>
      {config.modelUrl ? (
        <Suspense fallback={<CharacterPlaceholder />}>
          <LoadedCharacter config={config} />
        </Suspense>
      ) : (
        <CharacterPlaceholder />
      )}
    </group>
  );
}

function CharacterPlaceholder() {
  return (
    <>
      <mesh>
        <capsuleGeometry args={[0.55, 1.45, 10, 24]} />
        <meshStandardMaterial color="#e8f6ff" roughness={0.42} metalness={0.08} />
      </mesh>
      <mesh position={[0, 1.08, 0]}>
        <sphereGeometry args={[0.48, 32, 32]} />
        <meshStandardMaterial color="#fff0f8" roughness={0.5} />
      </mesh>
      <mesh position={[0, 1.1, -0.03]} scale={[1.1, 1.05, 1]}>
        <sphereGeometry args={[0.51, 32, 32]} />
        <meshBasicMaterial color="#111827" wireframe transparent opacity={0.25} />
      </mesh>
    </>
  );
}

function LoadedCharacter({ config }: MainCharacterProps) {
  const model = useRef<Group>(null);
  const gltf = useGLTF(config.modelUrl!);
  const { actions, names } = useAnimations(gltf.animations, model);

  useEffect(() => {
    const clipName = config.animationClip ?? names[0];
    const action = clipName ? actions[clipName] : undefined;
    if (!action) return undefined;

    action.reset().fadeIn(0.2).play();
    action.timeScale = config.animationSpeed;

    return () => {
      action.fadeOut(0.2);
    };
  }, [actions, config.animationClip, config.animationSpeed, names]);

  return <primitive ref={model} object={gltf.scene} />;
}
