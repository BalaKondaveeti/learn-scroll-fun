import { useState, type ReactNode } from 'react'
import { ErrorNotice, IconLink, Page, Spinner } from '../components/Bits'
import { Confirm } from '../components/Confirm'
import { useAuth, useUserId } from '../lib/authContext'
import { vivid } from '../lib/color'
import { getChapters, getProgress, resetAllProgress, resetChapterProgress } from '../lib/data'
import { getHomeLayout, getScrollDirection, saveHomeLayout, saveScrollDirection, type HomeLayout, type ScrollDirection } from '../lib/prefs'
import { forgetVisits } from '../lib/recent'
import { sb } from '../lib/supabase'
import { applyTheme, getTheme, type Theme } from '../lib/theme'
import type { Chapter } from '../lib/types'
import { useAsync } from '../lib/useAsync'

type Pending = { kind: 'all' } | { kind: 'chapter'; chapter: Chapter }

export default function Settings() {
  const userId = useUserId()
  const email = useAuth().session?.user.email
  const { data, error, reload } = useAsync(() => Promise.all([getChapters(), getProgress()]), [])
  const [theme, setTheme] = useState<Theme>(getTheme)
  const [direction, setDirection] = useState<ScrollDirection>(getScrollDirection)
  const [layout, setLayout] = useState<HomeLayout>(getHomeLayout)
  const [pending, setPending] = useState<Pending | null>(null)
  const [notice, setNotice] = useState<string | null>(null)

  const [chapters, progress] = data ?? [[], new Map()]
  const anyProgress = chapters.some((c) => (progress.get(c.id)?.progress ?? 0) > 0)

  return (
    <Page>
      <header className="pt-safe sticky top-0 z-10 bg-[var(--bg)]/85 backdrop-blur-xl">
        <div className="flex items-center gap-3 px-4 py-3">
          <IconLink to="/" label="Back" variant="plain" />
          <h1 className="text-[22px] font-bold tracking-[-0.02em]">Settings</h1>
        </div>
      </header>

      <div className="px-4 pb-12">
        {notice && <p role="status" className="mt-2 rounded-2xl bg-[var(--raised)] px-4 py-3 text-[15px]">{notice}</p>}

        <Section title="Appearance">
          <Segmented
            value={theme}
            options={[{ value: 'dark', label: 'Dark' }, { value: 'light', label: 'Light' }]}
            onChange={(t) => { applyTheme(t); setTheme(t) }}
          />
        </Section>

        <Section title="Home" hint="How chapters show below the top one. You can also switch this on Home.">
          <Segmented
            value={layout}
            options={[{ value: 'list', label: 'List' }, { value: 'tiles', label: 'Tiles' }]}
            onChange={(l) => { saveHomeLayout(l); setLayout(l) }}
          />
        </Section>

        <Section title="Cards" hint="How you move from one card to the next.">
          <Segmented
            value={direction}
            options={[{ value: 'vertical', label: 'Swipe up' }, { value: 'horizontal', label: 'Swipe sideways' }]}
            onChange={(d) => { saveScrollDirection(d); setDirection(d) }}
          />
        </Section>

        <Section title="Progress" hint="Resetting clears saved positions, quiz scores and missed questions. Content isn't affected.">
          {error && <ErrorNotice error={error} onRetry={reload} />}
          {!data && !error && <Spinner />}
          {data && (
            <div className="overflow-hidden rounded-2xl bg-[var(--raised)]">
              {chapters.map((c, i) => {
                const pct = Math.round((progress.get(c.id)?.progress ?? 0) * 100)
                return (
                  <div key={c.id} className={`flex items-center gap-3 px-3.5 py-3 ${i ? 'border-t border-[var(--line)]' : ''}`}>
                    <span className="grid h-10 w-10 shrink-0 place-items-center rounded-xl text-xl" style={{ background: vivid(c.color, c.sort_order, true) }} aria-hidden>{c.emoji}</span>
                    <span className="min-w-0 flex-1">
                      <span className="block truncate text-[16px] font-semibold">{c.title}</span>
                      <span className="block text-[14px] text-[var(--muted)] tabular-nums">{pct}% done</span>
                    </span>
                    <button
                      onClick={() => setPending({ kind: 'chapter', chapter: c })}
                      disabled={pct === 0}
                      className="rounded-full bg-[var(--bg)] px-4 py-2 text-[14px] font-semibold text-rose-500 active:scale-95 disabled:text-[var(--muted)] disabled:opacity-50"
                    >
                      Reset
                    </button>
                  </div>
                )
              })}
            </div>
          )}
          <button
            onClick={() => setPending({ kind: 'all' })}
            disabled={!anyProgress}
            className="mt-3 w-full rounded-2xl bg-rose-600 px-5 py-4 text-[17px] font-semibold text-white active:scale-[0.98] disabled:opacity-40"
          >
            Reset all progress
          </button>
        </Section>

        <Section title="Account">
          <div className="flex items-center justify-between gap-3 rounded-2xl bg-[var(--raised)] px-4 py-3.5">
            <span className="min-w-0 truncate text-[16px] text-[var(--muted)]">{email ?? 'Signed in'}</span>
            <button onClick={() => sb().auth.signOut()} className="shrink-0 rounded-full bg-[var(--bg)] px-4 py-2 text-[14px] font-semibold active:scale-95">Sign out</button>
          </div>
        </Section>
      </div>

      {pending && (
        <Confirm
          title={pending.kind === 'all' ? 'Reset all progress?' : `Reset ${pending.chapter.title}?`}
          message={
            pending.kind === 'all'
              ? 'Every chapter goes back to 0%. Quiz scores and your review list are cleared. This can’t be undone.'
              : `All parts in ${pending.chapter.title} go back to the start, and their quiz scores and missed questions are cleared. This can’t be undone.`
          }
          confirmLabel={pending.kind === 'all' ? 'Reset everything' : 'Reset chapter'}
          onConfirm={async () => {
            if (pending.kind === 'all') {
              await resetAllProgress(userId)
              forgetVisits()
              setNotice('All progress reset.')
            } else {
              await resetChapterProgress(userId, pending.chapter.id)
              forgetVisits(pending.chapter.id)
              setNotice(`${pending.chapter.title} reset.`)
            }
            reload()
          }}
          onClose={() => setPending(null)}
        />
      )}
    </Page>
  )
}

function Section({ title, hint, children }: { title: string; hint?: string; children: ReactNode }) {
  return (
    <section className="mt-7">
      <h2 className="px-1 text-[13px] font-semibold tracking-[0.02em] text-[var(--muted)] uppercase">{title}</h2>
      <div className="mt-2">{children}</div>
      {hint && <p className="mt-2 px-1 text-[13px] leading-snug text-[var(--muted)]">{hint}</p>}
    </section>
  )
}

function Segmented<T extends string>({ value, options, onChange }: { value: T; options: { value: T; label: string }[]; onChange: (v: T) => void }) {
  return (
    <div className="grid rounded-2xl bg-[var(--raised)] p-1" style={{ gridTemplateColumns: `repeat(${options.length}, 1fr)` }} role="radiogroup">
      {options.map((o) => (
        <button key={o.value} role="radio" aria-checked={value === o.value} onClick={() => onChange(o.value)}
          className={`rounded-xl px-3 py-2.5 text-[15px] font-semibold transition ${value === o.value ? 'bg-[var(--bg)] text-[var(--ink)] shadow-sm' : 'text-[var(--muted)]'}`}>
          {o.label}
        </button>
      ))}
    </div>
  )
}
