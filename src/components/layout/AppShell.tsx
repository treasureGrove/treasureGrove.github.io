import type { PropsWithChildren } from "react";
import { SystemStatus } from "../panels/SystemStatus";

export function AppShell({ children }: PropsWithChildren) {
  return (
    <main className="app-shell">
      {children}
      <div className="hud-layer">
        <div className="top-bar">
          <div>
            <div className="brand">NEON TOON ORBIT</div>
            <div className="tagline">
              Realtime Character Rendering / VFX / Shader / Pipeline
            </div>
          </div>
          <SystemStatus />
        </div>
      </div>
    </main>
  );
}
