import { create } from "zustand";
import type { SiteModuleId } from "../data/siteModules";

type ExperienceState = {
  selectedModule: SiteModuleId | null;
  transitionTarget: SiteModuleId | null;
  soundEnabled: boolean;
  setSelectedModule: (moduleId: SiteModuleId | null) => void;
  setTransitionTarget: (moduleId: SiteModuleId | null) => void;
  toggleSound: () => void;
};

export const useExperienceStore = create<ExperienceState>((set) => ({
  selectedModule: null,
  transitionTarget: null,
  soundEnabled: false,
  setSelectedModule: (moduleId) => set({ selectedModule: moduleId }),
  setTransitionTarget: (moduleId) => set({ transitionTarget: moduleId }),
  toggleSound: () => set((state) => ({ soundEnabled: !state.soundEnabled })),
}));
