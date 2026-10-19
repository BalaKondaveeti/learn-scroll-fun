import { Link } from 'react-router-dom'
import { alpha } from '../lib/color'
import type { Part, ProgressNode } from '../lib/types'

type Props = { part: Part; to: string; color: string; node?: ProgressNode; childCount: number }

export function PartTile({ part, to, color, node, childCount }: Props) {
  const progress = node?.progress ?? 0
  const done = node?.completed ?? false
  const hasScore = childCount === 0 && node?.best_score != null && node.total_questions
  return (
    <Link
      to={to}
      className="group relative block overflow-hidden rounded-[22px] border border-[var(--line)] bg-[var(--surface)] p-4 transition active:scale-[0.98]"
    >
      <div className="flex items-start gap-4">
        <div
          className="grid h-12 w-12 shrink-0 place-items-center rounded-2xl text-2xl"
          style={{ background: alpha(color, 0.18) }}
          aria-hidden
        >
          {part.emoji}
        </div>
        <div className="min-w-0 flex-1">
          <div className="flex items-center gap-2">
            <h3 className="font-display text-lg leading-tight font-bold">{part.title}</h3>
            {done && (
              <span
                className="inline-flex h-5 w-5 shrink-0 items-center justify-center rounded-full text-[11px] text-white"
                style={{ background: color }}
                aria-label="Completed"
              >
                ✓
              </span>
            )}
          </div>
          {part.description && <p className="mt-1 text-[15px] leading-snug text-[var(--muted)]">{part.description}</p>}
          <div className="mt-3 flex items-center gap-3 text-sm">
            <div className="h-1.5 flex-1 overflow-hidden rounded-full bg-[var(--line)]">
              <div
                className="h-full rounded-full transition-[width] duration-700"
                style={{ width: `${Math.round(progress * 100)}%`, background: color }}
              />
            </div>
            <span className="shrink-0 font-bold tabular-nums text-[var(--muted)]">
              {hasScore ? (
                <span style={{ color }}>
                  {node!.best_score}/{node!.total_questions}
                </span>
              ) : childCount > 0 ? (
                `${node?.leaf_done ?? 0}/${node?.leaf_total ?? childCount} parts`
              ) : progress > 0 ? (
                'In progress'
              ) : (
                'New'
              )}
            </span>
          </div>
        </div>
      </div>
    </Link>
  )
}
