import type { ButtonHTMLAttributes, PropsWithChildren } from "react";

type NeonButtonProps = PropsWithChildren<ButtonHTMLAttributes<HTMLButtonElement>>;

export function NeonButton({ children, ...props }: NeonButtonProps) {
  return (
    <button className="neon-button" type="button" {...props}>
      {children}
    </button>
  );
}
