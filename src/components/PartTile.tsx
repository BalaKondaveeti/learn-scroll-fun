import { Link } from 'react-router-dom'
import { vivid } from '../lib/color'
import { useFromHere } from '../lib/nav'
import type { Part, ProgressNode } from '../lib/types'
import { Check, ChevronRight } from './Icons'

type Props = { part: Part; to: string; color: string; variant: number; node?: ProgressNode; childCount: number }

export function PartTile({ part, to, color, variant, node, childCount }: Props) {
  const from = useFromHere()
  const progress = node?.progress ?? 0
  const done = node?.completed ?? false
  const score = childCount === 0 && node?.best_score != null && node.total_questions ? `${node.best_score}/${node.total_questions}` : null
  const status = score ?? (childCount > 0 ? `${childCount} parts` : progress > 0 ? 'Started' : 'New')
  return (
    <Link to={to} state={from} className="flex items-center gap-3.5 rounded-2xl px-2 py-2.5 transition active:scale-[0.98] active:bg-[var(--raised)]">
      <div className="relative grid h-[68px] w-[56px] shrink-0 place-items-center overflow-hidden rounded-[14px] text-[26px]" style={{ background: vivid(color, variant, true) }} aria-hidden>
        {part.emoji}
        {progress > 0 && (
          <div className="absolute inset-x-0 bottom-0 h-[3px] bg-black/25">
            <div className="h-full bg-white" style={{ width: `${Math.round(progress * 100)}%` }} />
          </div>
        )}
      </div>
      <div className="min-w-0 flex-1">
        <h3 className="truncate text-[17px] font-semibold tracking-[-0.01em]">{part.title}</h3>
        {part.description && <p className="mt-0.5 line-clamp-2 text-[14px] leading-snug text-[var(--muted)]">{part.description}</p>}
      </div>
      <div className="flex shrink-0 items-center gap-1.5">
        {done ? (
          <span className="flex items-center gap-1 rounded-full px-2.5 py-1 text-[13px] font-semibold text-white" style={{ background: vivid(color, variant, true) }}>
            <Check size={13} /> {score ?? 'Done'}
          </span>
        ) : (
          <span className="rounded-full bg-[var(--raised)] px-2.5 py-1 text-[13px] font-semibold text-[var(--muted)]">{status}</span>
        )}
        <span className="text-[var(--muted)]"><ChevronRight size={16} /></span>
      </div>
    </Link>
  )
}
