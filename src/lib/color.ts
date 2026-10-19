// Chapter colors are 6-digit hex; these helpers add alpha for soft gradients.
export const alpha = (hex: string, a: number) =>
  `${hex}${Math.round(Math.max(0, Math.min(1, a)) * 255).toString(16).padStart(2, '0')}`

export const softGradient = (hex: string) =>
  `linear-gradient(150deg, ${alpha(hex, 0.32)} 0%, ${alpha(hex, 0.1)} 55%, ${alpha(hex, 0.04)} 100%)`

export const glow = (hex: string) =>
  `radial-gradient(120% 60% at 50% -10%, ${alpha(hex, 0.45)} 0%, ${alpha(hex, 0)} 70%)`
