export const siteModules = [
  { id: "shader", label: "LAB_01 / TOON SHADER" },
  { id: "vfx", label: "LAB_02 / VFX SYSTEM" },
  { id: "character", label: "LAB_03 / CHARACTER RENDER" },
  { id: "pipeline", label: "LAB_04 / PIPELINE TOOLS" },
  { id: "archive", label: "ARCHIVE / PROJECT CASES" },
  { id: "contact", label: "SIGNAL / CONTACT" },
] as const;

export type SiteModuleId = (typeof siteModules)[number]["id"];
