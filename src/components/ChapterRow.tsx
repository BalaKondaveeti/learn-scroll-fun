import { Link } from 'react-router-dom'
import { vivid } from '../lib/color'
import type { Chapter, ProgressNode } from '../lib/types'
import { Check, ChevronRight } from './Icons'

// A compact chapter line: colored thumbnail, title, and either a progress bar or a "Done" badge.
export function ChapterRow({ chapter: c, node, from, done = false }: { chapter: Chapter; node?: ProgressNode; from: { from?: string }; done?: boolean }) {
  const pct = Math.round((node?.progress ?? 0) * 100)
  return (
    <Link to={`/c/${c.slug}`} state={from} className="flex items-center gap-3.5 rounded-2xl px-1.5 py-2 transition active:scale-[0.98] active:bg-[var(--raised)]">
      <span className="relative grid h-14 w-14 shrink-0 place-items-center overflow-hidden rounded-[16px] text-[28px]" style={{ background: vivid(c.color, c.sort_order, true) }} aria-hidden>
        {c.emoji}
      </span>
      <span className="min-w-0 flex-1">
        <span className="block truncate text-[17px] font-semibold tracking-[-0.01em]">{c.title}</span>
        {done ? (
          <span className="mt-1 flex items-center gap-1.5 text-[13px] font-medium text-[var(--muted)]">
            <span className="grid h-4 w-4 place-items-center rounded-full text-white" style={{ background: vivid(c.color, c.sort_order, true) }}><Check size={10} /></span>
            All {node?.leaf_total ?? 0} parts done
          </span>
        ) : (
        <span className="mt-1.5 flex items-center gap-2.5">
          <span className="h-1.5 flex-1 overflow-hidden rounded-full bg-[var(--raised)]">
            <span className="block h-full rounded-full transition-[width] duration-700" style={{ width: `${pct}%`, background: c.color }} />
          </span>
          <span className="shrink-0 text-[13px] font-medium text-[var(--muted)] tabular-nums">
            {pct > 0 ? `${pct}%` : `${node?.leaf_total ?? 0} parts`}
          </span>
        </span>
        )}
      </span>
      <span className="text-[var(--muted)]"><ChevronRight size={16} /></span>
    </Link>
  )
}
