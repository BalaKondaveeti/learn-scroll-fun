import { useState } from 'react'
import { Link } from 'react-router-dom'
import { ErrorNotice, Page, Spinner } from '../components/Bits'
import { ProgressRing } from '../components/ProgressRing'
import { softGradient } from '../lib/color'
import { getChapters, getProgress, getReviewQuestions } from '../lib/data'
import { sb } from '../lib/supabase'
import { applyTheme, getTheme, type Theme } from '../lib/theme'
import { useAsync } from '../lib/useAsync'

export default function Home() {
  const { data, error, loading, reload } = useAsync(
    () => Promise.all([getChapters(), getProgress(), getReviewQuestions(50)]),
    [],
  )
  const [theme, setTheme] = useState<Theme>(getTheme)

  function toggleTheme() {
    const next = theme === 'dark' ? 'light' : 'dark'
    applyTheme(next)
    setTheme(next)
  }

  const [chapters, progress, review] = data ?? [[], new Map(), []]
  const overall = chapters.length
    ? chapters.reduce((sum, c) => sum + (progress.get(c.id)?.progress ?? 0), 0) / chapters.length
    : 0

  return (
    <Page>
      <header className="flex items-center justify-between px-5 pt-5">
        <div className="flex items-center gap-2.5">
          <img src={`${import.meta.env.BASE_URL}icon.svg`} alt="" className="h-8 w-8 rounded-lg" />
          <span className="font-display text-lg font-bold">learn-scroll-fun</span>
        </div>
        <div className="flex gap-2">
          <button onClick={toggleTheme} aria-label={theme === 'dark' ? 'Switch to light mode' : 'Switch to dark mode'} className="grid h-10 w-10 place-items-center rounded-full bg-[var(--surface)] text-lg active:scale-95">
            {theme === 'dark' ? '☀️' : '🌙'}
          </button>
          <button onClick={() => sb().auth.signOut()} className="rounded-full bg-[var(--surface)] px-4 text-sm font-bold active:scale-95">
            Sign out
          </button>
        </div>
      </header>

      <section className="px-5 pt-8 pb-2">
        <h1 className="font-display text-[40px] leading-[1] font-extrabold tracking-tight">What do you want to learn today?</h1>
        {!loading && chapters.length > 0 && (
          <p className="mt-3 text-[var(--muted)]">
            {Math.round(overall * 100)}% through everything so far.
          </p>
        )}
      </section>

      {error && <ErrorNotice error={error} onRetry={reload} />}
      {loading && !data && <Spinner />}

      {data && (
        <>
          <div className="px-5 pt-4">
            {review.length > 0 ? (
              <Link to="/review" className="flex items-center gap-4 rounded-[22px] border border-[var(--line)] bg-[var(--surface)] p-4 active:scale-[0.98]">
                <span className="grid h-11 w-11 place-items-center rounded-2xl bg-amber-400/20 text-2xl" aria-hidden>🔁</span>
                <span className="flex-1">
                  <span className="block font-bold">Review</span>
                  <span className="block text-[15px] text-[var(--muted)]">
                    {review.length} question{review.length === 1 ? '' : 's'} you missed earlier
                  </span>
                </span>
                <span aria-hidden className="text-[var(--muted)]">›</span>
              </Link>
            ) : (
              <p className="rounded-[22px] border border-dashed border-[var(--line)] px-4 py-3 text-[15px] text-[var(--muted)]">
                Questions you miss in a quiz come back here for review.
              </p>
            )}
          </div>

          {chapters.length === 0 ? (
            <p className="px-5 py-10 text-[var(--muted)]">No chapters yet. Run the SQL in supabase/content/_all.sql to add the starter content.</p>
          ) : (
            <div className="grid grid-cols-2 gap-3 px-5 pt-5 pb-10">
              {chapters.map((c, i) => (
                <Link
                  key={c.id}
                  to={`/c/${c.slug}`}
                  className={`relative flex min-h-[168px] flex-col justify-between overflow-hidden rounded-[26px] border border-[var(--line)] p-4 transition active:scale-[0.97] ${i === 0 ? 'col-span-2 min-h-[150px]' : ''}`}
                  style={{ background: softGradient(c.color) }}
                >
                  <div className="flex items-start justify-between">
                    <span className="text-4xl" aria-hidden>{c.emoji}</span>
                    <ProgressRing value={progress.get(c.id)?.progress ?? 0} color={c.color} />
                  </div>
                  <div>
                    <h2 className="font-display text-xl leading-tight font-bold">{c.title}</h2>
                    {i === 0 && c.description && <p className="mt-1 text-[15px] text-[var(--muted)]">{c.description}</p>}
                  </div>
                </Link>
              ))}
            </div>
          )}
        </>
      )}
    </Page>
  )
}
