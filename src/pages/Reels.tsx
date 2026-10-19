import { useEffect, useRef, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { BackButton, ErrorNotice, Spinner } from '../components/Bits'
import { Markdown } from '../components/Markdown'
import { Quiz } from '../components/Quiz'
import { alpha, glow } from '../lib/color'
import { useUserId } from '../lib/authContext'
import { getCards, getPartProgress, getQuestions, logAttempt, saveCardPosition, saveQuizResult } from '../lib/data'
import type { Card, CardKind, Chapter, Part, PartProgress } from '../lib/types'
import { useAsync } from '../lib/useAsync'

const KIND_LABEL: Record<CardKind, string> = {
  concept: 'Idea',
  case_study: 'Case study',
  number: 'By the numbers',
  what_would_you_do: 'What would you do?',
  fact: 'Fact',
}

type Props = { chapter: Chapter; part: Part; backTo: string }

export default function Reels({ chapter, part, backTo }: Props) {
  const userId = useUserId()
  const navigate = useNavigate()
  const { data, error, reload } = useAsync(
    () => Promise.all([getCards(part.id), getQuestions(part.id), getPartProgress(part.id)]),
    [part.id],
  )
  const scroller = useRef<HTMLDivElement>(null)
  const [index, setIndex] = useState(0)
  const [progress, setProgress] = useState<PartProgress | null>(null)
  const restored = useRef(false)
  const saveTimer = useRef<number | undefined>(undefined)

  const cards = data?.[0] ?? []
  const questions = data?.[1] ?? []
  const pages = cards.length + 1 // cards, then the quiz (or finish) page

  // Restore the saved position once content has loaded.
  useEffect(() => {
    if (!data || restored.current) return
    restored.current = true
    const saved = data[2]
    setProgress(saved)
    const start = Math.min(saved?.last_card_index ?? 0, pages - 1)
    if (start > 0) {
      requestAnimationFrame(() => {
        const el = scroller.current?.children[start] as HTMLElement | undefined
        el?.scrollIntoView({ behavior: 'instant' as ScrollBehavior })
      })
    }
    setIndex(start)
  }, [data, pages])

  // Track which page is on screen.
  useEffect(() => {
    const root = scroller.current
    if (!root || !data) return
    const observer = new IntersectionObserver(
      (entries) => {
        for (const entry of entries) {
          if (entry.isIntersecting) setIndex(Number((entry.target as HTMLElement).dataset.index))
        }
      },
      { root, threshold: 0.6 },
    )
    Array.from(root.children).forEach((child) => observer.observe(child))
    return () => observer.disconnect()
  }, [data])

  // Save position as you scroll (debounced). Reaching the end marks the cards done.
  useEffect(() => {
    if (!data || !restored.current) return
    window.clearTimeout(saveTimer.current)
    saveTimer.current = window.setTimeout(() => {
      const atEnd = index >= cards.length
      const extra: { cards_completed?: boolean; completed_at?: string } = {}
      if (atEnd) extra.cards_completed = true
      if (atEnd && questions.length === 0 && !progress?.completed_at) extra.completed_at = new Date().toISOString()
      if (index === (progress?.last_card_index ?? -1) && !extra.cards_completed) return
      saveCardPosition(userId, part.id, index, extra)
        .then(() => setProgress((p) => ({ ...(p ?? emptyProgress(userId, part.id)), last_card_index: index, ...extra })))
        .catch(() => {
          /* position saving is best effort; the quiz result is what matters */
        })
    }, 500)
    return () => window.clearTimeout(saveTimer.current)
  }, [index, data, cards.length, questions.length, part.id, userId, progress?.completed_at, progress?.last_card_index])

  if (error) return <ErrorNotice error={error} onRetry={reload} />

  return (
    <div className="fixed inset-0 bg-[var(--bg)]">
      <div aria-hidden className="pointer-events-none absolute inset-0" style={{ background: glow(chapter.color) }} />

      <header className="pt-safe absolute inset-x-0 top-0 z-20">
        <div className="mx-auto flex max-w-xl items-center gap-3 px-4 pt-3">
          <BackButton to={backTo} label="Close" />
          <div className="min-w-0 flex-1">
            <p className="truncate text-[15px] font-bold">{part.title}</p>
            <div className="mt-1.5 flex gap-1" aria-label={`Page ${index + 1} of ${pages}`}>
              {Array.from({ length: pages }, (_, i) => (
                <span
                  key={i}
                  className="h-1 flex-1 rounded-full transition-colors duration-300"
                  style={{ background: i <= index ? chapter.color : 'var(--line)' }}
                />
              ))}
            </div>
          </div>
        </div>
      </header>

      {!data ? (
        <div className="grid h-full place-items-center"><Spinner /></div>
      ) : (
        <div ref={scroller} className="no-scrollbar relative h-full snap-y snap-mandatory overflow-y-auto overscroll-contain">
          {cards.map((card, i) => (
            <section key={card.id} data-index={i} className="flex h-dvh snap-start snap-always items-center justify-center px-4 pt-[calc(env(safe-area-inset-top)+64px)] pb-[calc(env(safe-area-inset-bottom)+24px)]">
              <CardView card={card} color={chapter.color} first={i === 0} />
            </section>
          ))}
          <section data-index={cards.length} className="flex h-dvh snap-start snap-always items-center justify-center px-4 pt-[calc(env(safe-area-inset-top)+64px)] pb-[calc(env(safe-area-inset-bottom)+24px)]">
            <div className="no-scrollbar max-h-full w-full max-w-xl overflow-y-auto rounded-[30px] border border-[var(--line)] bg-[var(--surface)] p-6">
              {questions.length > 0 ? (
                <Quiz
                  questions={questions}
                  color={chapter.color}
                  best={progress?.best_score}
                  onAnswer={(q, correct) => void logAttempt(userId, q.id, correct).catch(() => {})}
                  onFinish={async (score, total) => {
                    try {
                      setProgress(await saveQuizResult(userId, part.id, score, total, progress))
                    } catch {
                      /* score still shown; it will save on the next attempt */
                    }
                  }}
                  onExit={() => navigate(backTo)}
                />
              ) : (
                <div className="text-center">
                  <p className="text-5xl" aria-hidden>{part.emoji}</p>
                  <h2 className="font-display mt-4 text-3xl font-bold">That's this part.</h2>
                  <p className="mt-2 text-[var(--muted)]">More cards and a quiz are coming here.</p>
                  <button onClick={() => navigate(backTo)} className="mt-6 w-full rounded-2xl px-5 py-4 text-lg font-bold text-white" style={{ background: chapter.color }}>
                    Back to parts
                  </button>
                </div>
              )}
            </div>
          </section>
        </div>
      )}
    </div>
  )
}

function CardView({ card, color, first }: { card: Card; color: string; first: boolean }) {
  const [open, setOpen] = useState(false)
  const isNumber = card.kind === 'number'
  return (
    <article
      className="no-scrollbar relative flex max-h-full w-full max-w-xl flex-col overflow-y-auto rounded-[30px] border border-[var(--line)] bg-[var(--surface)] p-6"
      style={{ boxShadow: `0 30px 80px -40px ${alpha(color, 0.7)}` }}
    >
      <span className="self-start rounded-full px-3 py-1 text-[13px] font-bold" style={{ background: alpha(color, 0.18), color: `color-mix(in srgb, ${color} 70%, var(--ink))` }}>
        {KIND_LABEL[card.kind]}
      </span>
      <h2 className={`font-display mt-4 font-extrabold tracking-tight ${isNumber ? 'text-[44px] leading-[0.98]' : 'text-[30px] leading-[1.05]'}`} style={isNumber ? { color } : undefined}>
        {card.title}
      </h2>
      <div className="mt-4 text-[19px] leading-[1.55] text-[var(--ink)]/90">
        <Markdown>{card.body}</Markdown>
      </div>

      {open && card.deep_dive && (
        <div className="mt-5 animate-[rise_300ms_ease-out] border-l-[3px] pl-4 text-[17px] leading-[1.6] text-[var(--muted)]" style={{ borderColor: color }}>
          <Markdown>{card.deep_dive}</Markdown>
        </div>
      )}

      {(card.deep_dive || card.video_url) && (
        <div className="mt-6 flex flex-wrap gap-2">
          {card.deep_dive && (
            <button onClick={() => setOpen(!open)} className="rounded-full border border-[var(--line)] px-4 py-2 text-[15px] font-bold active:scale-95">
              {open ? 'Show less' : card.kind === 'what_would_you_do' ? 'See what happened' : 'Go deeper'}
            </button>
          )}
          {card.video_url && (
            <a href={card.video_url} target="_blank" rel="noreferrer" className="rounded-full px-4 py-2 text-[15px] font-bold text-white active:scale-95" style={{ background: color }}>
              ▶ Watch
            </a>
          )}
        </div>
      )}

      {first && <p className="mt-6 text-center text-sm text-[var(--muted)] animate-pulse">Swipe up for the next card</p>}
    </article>
  )
}

function emptyProgress(userId: string, partId: string): PartProgress {
  return {
    user_id: userId,
    part_id: partId,
    last_card_index: 0,
    cards_completed: false,
    best_score: null,
    last_score: null,
    total_questions: null,
    attempts: 0,
    completed_at: null,
  }
}
