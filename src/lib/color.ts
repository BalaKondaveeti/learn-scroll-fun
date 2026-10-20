// Turns a chapter's base color into vivid, full-bleed gradients that always carry white text.
// Lightness is chosen per hue so white text meets a minimum contrast ratio: yellows and greens
// get darker, blues and violets can stay brighter.

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

function hslToRgb(h: number, s: number, l: number): [number, number, number] {
  s /= 100
  l /= 100
  const k = (n: number) => (n + h / 30) % 12
  const a = s * Math.min(l, 1 - l)
  const f = (n: number) => l - a * Math.max(-1, Math.min(k(n) - 3, Math.min(9 - k(n), 1)))
  return [f(0), f(8), f(4)]
}

function contrastWithWhite(h: number, s: number, l: number) {
  const lin = (c: number) => (c <= 0.03928 ? c / 12.92 : ((c + 0.055) / 1.055) ** 2.4)
  const [r, g, b] = hslToRgb(h, s, l).map(lin)
  return 1.05 / (0.2126 * r + 0.7152 * g + 0.0722 * b + 0.05)
}

// The brightest lightness (8..60) at which white text still reaches `target` contrast.
function lightnessFor(h: number, s: number, target: number) {
  let lo = 8
  let hi = 60
  for (let i = 0; i < 16; i++) {
    const mid = (lo + hi) / 2
    if (contrastWithWhite(h, s, mid) >= target) lo = mid
    else hi = mid
  }
  return Math.round(lo * 10) / 10
}

const hsl = (h: number, s: number, l: number, a = 1) => `hsl(${Math.round(h)} ${Math.round(s)}% ${l}% / ${a})`

export const alpha = (hex: string, a: number) =>
  `${hex}${Math.round(Math.max(0, Math.min(1, a)) * 255).toString(16).padStart(2, '0')}`

// `variant` shifts the hue a little so neighbouring cards feel distinct but related.
// `large` is for surfaces that only carry big, bold titles (tiles, thumbnails), which need
// less contrast than paragraphs (3:1 instead of 4.5:1), so they can stay brighter.
export function vivid(hex: string, variant = 0, large = false) {
  const k = large ? 0.68 : 1
  const { h, s } = hexToHsl(hex)
  const sat = Math.min(88, Math.max(60, s))
  const shift = [0, 12, -12, 6, -6][((variant % 5) + 5) % 5]
  const h1 = (h + shift + 360) % 360
  // Rotate toward lower hues: amber goes to orange-red, red to pink, green to emerald.
  // Rotating upward sends warm colors toward olive, which looks muddy.
  const h2 = (h1 - 30 + 360) % 360
  const h3 = (h1 - 10 + 360) % 360
  return [
    `radial-gradient(90% 55% at 12% 6%, ${hsl(h3, sat, lightnessFor(h3, sat, 4.8 * k), 0.9)} 0%, transparent 62%)`,
    `radial-gradient(110% 70% at 100% 100%, ${hsl(h2, sat, lightnessFor(h2, sat, 9 * k))} 0%, transparent 64%)`,
    `linear-gradient(165deg, ${hsl(h1, sat, lightnessFor(h1, sat, 5.6 * k))} 0%, ${hsl(h2, sat - 6, lightnessFor(h2, sat - 6, 11 * k))} 100%)`,
  ].join(', ')
}

// A deeper version behind the quiz and review.
export function deep(hex: string) {
  const { h, s } = hexToHsl(hex)
  const sat = Math.min(82, Math.max(55, s))
  const h2 = (h - 35 + 360) % 360
  return [
    `radial-gradient(100% 55% at 50% 0%, ${hsl(h, sat, lightnessFor(h, sat, 6), 0.95)} 0%, transparent 70%)`,
    `linear-gradient(180deg, ${hsl(h, sat, lightnessFor(h, sat, 8.5))} 0%, ${hsl(h2, sat - 10, lightnessFor(h2, sat - 10, 15))} 100%)`,
  ].join(', ')
}
