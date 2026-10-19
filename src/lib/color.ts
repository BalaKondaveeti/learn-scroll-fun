// Turns a chapter's base color into vivid, full-bleed gradients that still carry white text.

function hexToHsl(hex: string) {
  const n = parseInt(hex.slice(1), 16)
  const r = ((n >> 16) & 255) / 255
  const g = ((n >> 8) & 255) / 255
  const b = (n & 255) / 255
  const max = Math.max(r, g, b)
  const min = Math.min(r, g, b)
  const l = (max + min) / 2
  if (max === min) return { h: 0, s: 0, l: l * 100 }
  const d = max - min
  const s = l > 0.5 ? d / (2 - max - min) : d / (max + min)
  const h = max === r ? (g - b) / d + (g < b ? 6 : 0) : max === g ? (b - r) / d + 2 : (r - g) / d + 4
  return { h: h * 60, s: s * 100, l: l * 100 }
}

export const alpha = (hex: string, a: number) =>
  `${hex}${Math.round(Math.max(0, Math.min(1, a)) * 255).toString(16).padStart(2, '0')}`

// `variant` shifts the hue a little so neighbouring cards feel distinct but related.
export function vivid(hex: string, variant = 0) {
  const { h, s } = hexToHsl(hex)
  const sat = Math.round(Math.min(92, Math.max(62, s)))
  const shift = [0, 12, -12, 6, -6][((variant % 5) + 5) % 5]
  const h1 = Math.round((h + shift + 360) % 360)
  // Rotate toward lower hues: amber goes to orange-red, red to pink, green to emerald, blue to indigo-cyan.
  // Rotating upward sends warm colors toward olive, which looks muddy.
  const h2 = Math.round((h1 - 30 + 360) % 360)
  const h3 = Math.round((h1 - 10 + 360) % 360)
  return [
    `radial-gradient(90% 60% at 12% 8%, hsl(${h3} ${sat}% 54% / 0.85) 0%, transparent 62%)`,
    `radial-gradient(110% 70% at 100% 100%, hsl(${h2} ${sat}% 40%) 0%, transparent 64%)`,
    `linear-gradient(165deg, hsl(${h1} ${sat}% 42%) 0%, hsl(${h2} ${sat - 6}% 24%) 100%)`,
  ].join(', ')
}

// A deeper version for the color behind text-heavy screens like the quiz.
export function deep(hex: string) {
  const { h, s } = hexToHsl(hex)
  const sat = Math.round(Math.min(85, Math.max(55, s)))
  const h1 = Math.round(h)
  const h2 = Math.round((h - 35 + 360) % 360)
  return [
    `radial-gradient(100% 55% at 50% 0%, hsl(${h1} ${sat}% 45% / 0.95) 0%, transparent 70%)`,
    `linear-gradient(180deg, hsl(${h1} ${sat}% 30%) 0%, hsl(${h2} ${sat - 10}% 14%) 100%)`,
  ].join(', ')
}
