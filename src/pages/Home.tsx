import { useState, type ReactNode } from 'react'
import { Link } from 'react-router-dom'
import { ErrorNotice, Page, Spinner } from '../components/Bits'
import { ChevronRight, Gear, GridIcon, ListIcon, Repeat } from '../components/Icons'
import { vivid } from '../lib/color'
import { getChapters, getLastActiveChapter, getProgress, getReviewQuestions } from '../lib/data'
import { useFromHere } from '../lib/nav'
import { getHomeLayout, saveHomeLayout, type HomeLayout } from '../lib/prefs'
import { getLocalLastChapter } from '../lib/recent'
import type { Chapter, ProgressNode } from '../lib/types'
import { useAsync } from '../lib/useAsync'

// The chapter used most recently goes first (and gets the big tile); the rest keep their order.
function orderChapters(chapters: Chapter[], lastId: string | null) {
  const last = lastId ? chapters.find((c) => c.id === lastId) : undefined
  return last ? [last, ...chapters.filter((c) => c !== last)] : chapters
}

export default function Home() {
  const { data, error, loading, reload } = useAsync(
    () => Promise.all([getChapters(), getProgress(), getReviewQuestions(50), getLastActiveChapter().catch(() => null)]),
    [],
  )

  const from = useFromHere()
  const [layout, setLayout] = useState<HomeLayout>(getHomeLayout)
  const chooseLayout = (l: HomeLayout) => {
    saveHomeLayout(l)
    setLayout(l)
  }
  const [chapters, progress, review, serverLast] = data ?? [[], new Map(), [], null]
  const localLast = getLocalLastChapter()
  const last = [serverLast, localLast].filter((x) => x && chapters.some((c) => c.id === x.chapterId)).sort((a, b) => b!.at - a!.at)[0]
  const ordered = orderChapters(chapters, last?.chapterId ?? null)
  const overall = chapters.length ? chapters.reduce((sum, c) => sum + (progress.get(c.id)?.progress ?? 0), 0) / chapters.length : 0

  return (
    <Page>
      <header className="pt-safe sticky top-0 z-10 bg-[var(--bg)]/85 backdrop-blur-xl">
        <div className="flex items-center justify-between px-4 py-3">
          <span className="font-display text-[23px] font-extrabold tracking-[-0.03em]">Scroll to Learn</span>
          <Link to="/settings" state={from} aria-label="Settings" className="grid h-10 w-10 place-items-center rounded-full bg-[var(--raised)] text-[var(--ink)] transition active:scale-90">
            <Gear />
          </Link>
        </div>
      </header>

      {error && <ErrorNotice error={error} onRetry={reload} />}
      {loading && !data && <Spinner />}

      {data && (
        <div className="px-4 pb-10">
          <div className="flex items-end justify-between gap-3 pt-3 pb-4">
            <div>
              <h1 className="font-display text-[28px] leading-tight font-bold tracking-[-0.025em]">{last ? 'Keep going' : 'Pick a chapter'}</h1>
              {chapters.length > 0 && <p className="mt-0.5 text-[15px] font-medium text-[var(--muted)] tabular-nums">{Math.round(overall * 100)}% through everything</p>}
            </div>
            {chapters.length > 1 && <LayoutSwitch value={layout} onChange={chooseLayout} />}
          </div>

          {review.length > 0 && (
            <Link to="/review" state={from} className="mb-4 flex items-center gap-3 rounded-2xl p-3 pr-4 text-white transition active:scale-[0.98]" style={{ background: vivid('#f43f5e', 2) }}>
              <span className="grid h-11 w-11 place-items-center rounded-full bg-white/20"><Repeat /></span>
              <span className="flex-1 leading-tight">
                <span className="block text-[17px] font-semibold">Review</span>
                <span className="block text-[14px] text-white/90">{review.length} question{review.length === 1 ? '' : 's'} you missed</span>
              </span>
              <ChevronRight />
            </Link>
          )}

          {chapters.length === 0 ? (
            <p className="py-10 text-[var(--muted)]">No chapters yet. Run supabase/content/_all.sql in the Supabase SQL editor to add the starter content.</p>
          ) : (
            <>
            <div className="grid grid-cols-2 gap-2.5">
              {(layout === 'list' ? ordered.slice(0, 1) : ordered).map((c, i) => {
                const p = progress.get(c.id)
                const pct = Math.round((p?.progress ?? 0) * 100)
                const wide = i === 0
                const isLast = c.id === last?.chapterId
                return (
                  <Link key={c.id} to={`/c/${c.slug}`} state={from}
                    className={`relative overflow-hidden rounded-[22px] text-white transition active:scale-[0.97] ${wide ? 'col-span-2 aspect-[16/10]' : 'aspect-[3/4]'}`}
                    style={{ background: vivid(c.color, c.sort_order, true) }}>
                    <div aria-hidden className="scrim absolute inset-0" />
                    <span className={`absolute top-3.5 left-3.5 ${wide ? 'text-[52px]' : 'text-[44px]'}`} aria-hidden>{c.emoji}</span>
                    <div className="absolute top-3.5 right-3.5 flex gap-1.5">
                      {isLast && <span className="rounded-full bg-white px-2.5 py-1 text-[12px] font-bold text-black">Continue</span>}
                      {pct > 0 && <span className="rounded-full bg-black/30 px-2.5 py-1 text-[12px] font-semibold backdrop-blur-md tabular-nums">{pct}%</span>}
                    </div>
                    <div className="absolute inset-x-3.5 bottom-4 [text-shadow:0_1px_14px_rgb(0_0_0/0.25)]">
                      <h2 className={`font-display leading-[1.02] font-extrabold tracking-[-0.03em] text-balance ${wide ? 'text-[30px]' : 'text-[21px]'}`}>{c.title}</h2>
                      {wide && c.description && <p className="mt-1.5 line-clamp-2 max-w-[92%] text-[15px] leading-snug text-white">{c.description}</p>}
                      <p className="mt-1 text-[13px] font-medium text-white/85">{p?.leaf_total ?? 0} parts</p>
                    </div>
                    <div className="absolute inset-x-0 bottom-0 h-[3px] bg-white/20"><div className="h-full bg-white transition-[width] duration-700" style={{ width: `${pct}%` }} /></div>
                  </Link>
                )
              })}
            </div>
            {layout === 'list' && ordered.length > 1 && (
              <div className="mt-3 flex flex-col gap-1">
                {ordered.slice(1).map((c) => (
                  <ChapterRow key={c.id} chapter={c} node={progress.get(c.id)} from={from} />
                ))}
              </div>
            )}
            </>
          )}
        </div>
      )}
    </Page>
  )
}

function LayoutSwitch({ value, onChange }: { value: HomeLayout; onChange: (l: HomeLayout) => void }) {
  const btn = (l: HomeLayout, label: string, icon: ReactNode) => (
    <button
      type="button"
      role="radio"
      aria-checked={value === l}
      aria-label={label}
      onClick={() => onChange(l)}
      className={`grid h-8 w-9 place-items-center rounded-[10px] transition ${value === l ? 'bg-[var(--bg)] text-[var(--ink)] shadow-sm' : 'text-[var(--muted)]'}`}
    >
      {icon}
    </button>
  )
  return (
    <div role="radiogroup" aria-label="Chapter layout" className="mb-1 flex shrink-0 rounded-xl bg-[var(--raised)] p-1">
      {btn('list', 'Show chapters as a list', <ListIcon />)}
      {btn('tiles', 'Show chapters as tiles', <GridIcon />)}
    </div>
  )
}

function ChapterRow({ chapter: c, node, from }: { chapter: Chapter; node?: ProgressNode; from: { from?: string } }) {
  const pct = Math.round((node?.progress ?? 0) * 100)
  return (
    <Link to={`/c/${c.slug}`} state={from} className="flex items-center gap-3.5 rounded-2xl px-1.5 py-2 transition active:scale-[0.98] active:bg-[var(--raised)]">
      <span className="relative grid h-14 w-14 shrink-0 place-items-center overflow-hidden rounded-[16px] text-[28px]" style={{ background: vivid(c.color, c.sort_order, true) }} aria-hidden>
        {c.emoji}
      </span>
      <span className="min-w-0 flex-1">
        <span className="block truncate text-[17px] font-semibold tracking-[-0.01em]">{c.title}</span>
        <span className="mt-1.5 flex items-center gap-2.5">
          <span className="h-1.5 flex-1 overflow-hidden rounded-full bg-[var(--raised)]">
            <span className="block h-full rounded-full transition-[width] duration-700" style={{ width: `${pct}%`, background: c.color }} />
          </span>
          <span className="shrink-0 text-[13px] font-medium text-[var(--muted)] tabular-nums">
            {pct > 0 ? `${pct}%` : `${node?.leaf_total ?? 0} parts`}
          </span>
        </span>
      </span>
      <span className="text-[var(--muted)]"><ChevronRight size={16} /></span>
    </Link>
  )
}
