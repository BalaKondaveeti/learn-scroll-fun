import { useState } from 'react'
import { Link } from 'react-router-dom'
import { ErrorNotice, Page, Spinner } from '../components/Bits'
import { ChevronRight, LogOut, Moon, Repeat, Sun } from '../components/Icons'
import { vivid } from '../lib/color'
import { getChapters, getProgress, getReviewQuestions } from '../lib/data'
import { sb } from '../lib/supabase'
import { applyTheme, getTheme, type Theme } from '../lib/theme'
import { useAsync } from '../lib/useAsync'

export default function Home() {
  const { data, error, loading, reload } = useAsync(() => Promise.all([getChapters(), getProgress(), getReviewQuestions(50)]), [])
  const [theme, setTheme] = useState<Theme>(getTheme)

  function toggleTheme() {
    const next = theme === 'dark' ? 'light' : 'dark'
    applyTheme(next)
    setTheme(next)
  }

  const [chapters, progress, review] = data ?? [[], new Map(), []]
  const overall = chapters.length ? chapters.reduce((sum, c) => sum + (progress.get(c.id)?.progress ?? 0), 0) / chapters.length : 0
  const iconBtn = 'grid h-10 w-10 place-items-center rounded-full bg-[var(--raised)] text-[var(--ink)] transition active:scale-90'

  return (
    <Page>
      <header className="pt-safe sticky top-0 z-10 bg-[var(--bg)]/85 backdrop-blur-xl">
        <div className="flex items-center justify-between px-4 py-3">
          <span className="font-display text-[22px] font-extrabold tracking-[-0.03em]">learn-scroll-fun</span>
          <div className="flex gap-2">
            <button onClick={toggleTheme} aria-label={theme === 'dark' ? 'Switch to light mode' : 'Switch to dark mode'} className={iconBtn}>
              {theme === 'dark' ? <Sun /> : <Moon />}
            </button>
            <button onClick={() => sb().auth.signOut()} aria-label="Sign out" className={iconBtn}><LogOut /></button>
          </div>
        </div>
      </header>

      {error && <ErrorNotice error={error} onRetry={reload} />}
      {loading && !data && <Spinner />}

      {data && (
        <div className="px-4 pb-10">
          <div className="flex items-end justify-between pt-3 pb-4">
            <h1 className="font-display text-[28px] leading-tight font-bold tracking-[-0.025em]">Pick a chapter</h1>
            {chapters.length > 0 && <span className="pb-1 text-[15px] font-medium text-[var(--muted)] tabular-nums">{Math.round(overall * 100)}% done</span>}
          </div>

          {review.length > 0 && (
            <Link to="/review" className="mb-4 flex items-center gap-3 rounded-2xl p-3 pr-4 text-white transition active:scale-[0.98]" style={{ background: vivid('#f43f5e', 2) }}>
              <span className="grid h-11 w-11 place-items-center rounded-full bg-white/20"><Repeat /></span>
              <span className="flex-1 leading-tight">
                <span className="block text-[17px] font-semibold">Review</span>
                <span className="block text-[14px] text-white/85">{review.length} question{review.length === 1 ? '' : 's'} you missed</span>
              </span>
              <ChevronRight />
            </Link>
          )}

          {chapters.length === 0 ? (
            <p className="py-10 text-[var(--muted)]">No chapters yet. Run supabase/content/_all.sql in the Supabase SQL editor to add the starter content.</p>
          ) : (
            <div className="grid grid-cols-2 gap-2.5">
              {chapters.map((c, i) => {
                const p = progress.get(c.id)
                const pct = Math.round((p?.progress ?? 0) * 100)
                const wide = i === 0
                return (
                  <Link key={c.id} to={`/c/${c.slug}`}
                    className={`relative overflow-hidden rounded-[22px] text-white transition active:scale-[0.97] ${wide ? 'col-span-2 aspect-[16/10]' : 'aspect-[3/4]'}`}
                    style={{ background: vivid(c.color, i) }}>
                    <div aria-hidden className="scrim absolute inset-0" />
                    <span className={`absolute top-3.5 left-3.5 ${wide ? 'text-[52px]' : 'text-[44px]'}`} aria-hidden>{c.emoji}</span>
                    {pct > 0 && <span className="absolute top-3.5 right-3.5 rounded-full bg-black/25 px-2.5 py-1 text-[12px] font-semibold backdrop-blur-md tabular-nums">{pct}%</span>}
                    <div className="absolute inset-x-3.5 bottom-4">
                      <h2 className={`font-display leading-[1.02] font-extrabold tracking-[-0.03em] text-balance ${wide ? 'text-[30px]' : 'text-[21px]'}`}>{c.title}</h2>
                      {wide && c.description && <p className="mt-1.5 line-clamp-2 max-w-[90%] text-[15px] leading-snug text-white/85">{c.description}</p>}
                      <p className="mt-1 text-[13px] font-medium text-white/75">{p?.leaf_total ?? 0} parts</p>
                    </div>
                    <div className="absolute inset-x-0 bottom-0 h-[3px] bg-white/20"><div className="h-full bg-white transition-[width] duration-700" style={{ width: `${pct}%` }} /></div>
                  </Link>
                )
              })}
            </div>
          )}
        </div>
      )}
    </Page>
  )
}
