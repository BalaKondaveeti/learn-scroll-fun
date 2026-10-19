type Props = { value: number; color?: string; track?: string; size?: number; stroke?: number; label?: boolean }

export function ProgressRing({ value, color = '#fff', track = 'rgb(255 255 255 / 0.25)', size = 44, stroke = 3.5, label = true }: Props) {
  const r = (size - stroke) / 2
  const c = 2 * Math.PI * r
  const pct = Math.round(Math.max(0, Math.min(1, value)) * 100)
  return (
    <div className="relative grid shrink-0 place-items-center" style={{ width: size, height: size }} aria-label={`${pct}% complete`}>
      <svg width={size} height={size} className="-rotate-90">
        <circle cx={size / 2} cy={size / 2} r={r} fill="none" stroke={track} strokeWidth={stroke} />
        <circle cx={size / 2} cy={size / 2} r={r} fill="none" stroke={color} strokeWidth={stroke} strokeLinecap="round"
          strokeDasharray={c} strokeDashoffset={c * (1 - pct / 100)} className="transition-[stroke-dashoffset] duration-700 ease-out" />
      </svg>
      {label && <span className="absolute text-[11px] font-semibold tabular-nums">{pct}%</span>}
    </div>
  )
}
