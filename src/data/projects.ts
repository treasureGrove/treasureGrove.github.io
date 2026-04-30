export type ProjectCase = {
  title: string;
  type: string;
  engine: "WebGL" | "Unity" | "Unreal" | "Blender" | "Maya" | "Houdini";
  keywords: string[];
};

export const projects: ProjectCase[] = [];
