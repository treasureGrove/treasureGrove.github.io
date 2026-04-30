import { useState } from "react";

export function useTransitionState() {
  const [target, setTarget] = useState<string | null>(null);
  return { target, setTarget };
}
