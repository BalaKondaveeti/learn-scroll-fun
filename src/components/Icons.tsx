type P = { size?: number }
const base = (size: number) => ({ width: size, height: size, viewBox: '0 0 24 24', fill: 'none', stroke: 'currentColor', strokeWidth: 2.2, strokeLinecap: 'round' as const, strokeLinejoin: 'round' as const })

export const ChevronLeft = ({ size = 22 }: P) => <svg {...base(size)}><path d="M15 18l-6-6 6-6" /></svg>
export const ChevronRight = ({ size = 18 }: P) => <svg {...base(size)}><path d="M9 6l6 6-6 6" /></svg>
export const ChevronUp = ({ size = 22 }: P) => <svg {...base(size)}><path d="M6 15l6-6 6 6" /></svg>
export const Close = ({ size = 22 }: P) => <svg {...base(size)}><path d="M6 6l12 12M18 6L6 18" /></svg>
export const Book = ({ size = 26 }: P) => <svg {...base(size)}><path d="M4 5.5A2.5 2.5 0 0 1 6.5 3H20v15H6.5A2.5 2.5 0 0 0 4 20.5zM4 20.5A2.5 2.5 0 0 0 6.5 23H20v-5" /></svg>
export const Play = ({ size = 26 }: P) => <svg {...base(size)} fill="currentColor" stroke="none"><path d="M8 5.5v13a1 1 0 0 0 1.5.86l10.8-6.5a1 1 0 0 0 0-1.72L9.5 4.64A1 1 0 0 0 8 5.5z" /></svg>
export const Sun = ({ size = 20 }: P) => <svg {...base(size)}><circle cx="12" cy="12" r="4" /><path d="M12 2v2M12 20v2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M2 12h2M20 12h2M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4" /></svg>
export const Moon = ({ size = 20 }: P) => <svg {...base(size)}><path d="M21 12.8A9 9 0 1 1 11.2 3a7 7 0 0 0 9.8 9.8z" /></svg>
export const LogOut = ({ size = 20 }: P) => <svg {...base(size)}><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4M16 17l5-5-5-5M21 12H9" /></svg>
export const Check = ({ size = 16 }: P) => <svg {...base(size)} strokeWidth={3}><path d="M5 12.5l4.5 4.5L19 7.5" /></svg>
export const Repeat = ({ size = 22 }: P) => <svg {...base(size)}><path d="M17 2l4 4-4 4" /><path d="M3 11v-1a4 4 0 0 1 4-4h14M7 22l-4-4 4-4" /><path d="M21 13v1a4 4 0 0 1-4 4H3" /></svg>
export const ArrowsVertical = ({ size = 20 }: P) => <svg {...base(size)}><path d="M8 7l4-4 4 4M8 17l4 4 4-4M12 3v18" /></svg>
export const ArrowsHorizontal = ({ size = 20 }: P) => <svg {...base(size)}><path d="M7 8l-4 4 4 4M17 8l4 4-4 4M3 12h18" /></svg>
