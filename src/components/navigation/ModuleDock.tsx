import { siteModules } from "../../data/siteModules";
import { useExperienceStore } from "../../state/useExperienceStore";
import { NeonButton } from "../ui/NeonButton";

export function ModuleDock() {
  const setSelectedModule = useExperienceStore((state) => state.setSelectedModule);
  const setTransitionTarget = useExperienceStore((state) => state.setTransitionTarget);

  return (
    <nav className="module-dock" aria-label="Portfolio modules">
      {siteModules.map((module) => (
        <NeonButton
          key={module.id}
          onBlur={() => setSelectedModule(null)}
          onClick={() => setTransitionTarget(module.id)}
          onFocus={() => setSelectedModule(module.id)}
          onMouseEnter={() => setSelectedModule(module.id)}
          onMouseLeave={() => setSelectedModule(null)}
        >
          {module.label}
        </NeonButton>
      ))}
    </nav>
  );
}
