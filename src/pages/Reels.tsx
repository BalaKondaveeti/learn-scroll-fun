import { useEffect, useLayoutEffect, useRef, useState } from 'react'
import { ErrorNotice, IconLink, Spinner } from '../components/Bits'
import { ArrowsHorizontal, ArrowsVertical, Book, ChevronUp, Play } from '../components/Icons'
import { Markdown } from '../components/Markdown'
import { Quiz } from '../components/Quiz'
import { useUserId } from '../lib/authContext'
import { deep, vivid } from '../lib/color'
import { getCards, getPartProgress, getQuestions, logAttempt, saveCardPosition, saveQuizResult } from '../lib/data'
import type { Card, CardKind, Chapter, Part, PartProgress } from '../lib/types'
import { getScrollDirection, saveScrollDirection, type ScrollDirection } from '../lib/prefs'
import { useGoBack } from '../lib/nav'
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
  const goBack = useGoBack(backTo)
  const { data, error, reload } = useAsync(
    () => Promise.all([getCards(part.id), getQuestions(part.id), getPartProgress(part.id)]),
    [part.id],
  )
  const scroller = useRef<HTMLDivElement>(null)
  const [index, setIndex] = useState(0)
  const [progress, setProgress] = useState<PartProgress | null>(null)
  const [sheet, setSheet] = useState<Card | null>(null)
  const [direction, setDirection] = useState<ScrollDirection>(getScrollDirection)
  const horizontal = direction === 'horizontal'
  const keepIndex = useRef<number | null>(null)
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
      requestAnimationFrame(() => scrollToPage(scroller.current, start, getScrollDirection()))
    }
    setIndex(start)
  }, [data, pages])

  // Switching direction re-lays out the pages; jump back to the same card before the browser paints.
  useLayoutEffect(() => {
    if (keepIndex.current === null) return
    scrollToPage(scroller.current, keepIndex.current, direction)
    keepIndex.current = null
  }, [direction])

  function toggleDirection() {
    keepIndex.current = index
    const next: ScrollDirection = horizontal ? 'vertical' : 'horizontal'
    saveScrollDirection(next)
    setDirection(next)
  }

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

  const onQuiz = data && index >= cards.length
  const page = horizontal ? 'h-full w-full shrink-0' : 'h-full'

  return (
    <div className="fixed inset-0 overflow-hidden bg-black text-white">
      {/* Story-style header: segments, then who/what, then close. */}
      <header className="pt-safe pointer-events-none absolute inset-x-0 top-0 z-20">
        <div className="mx-auto max-w-xl px-3 pt-2">
          <div className="flex gap-1" aria-label={`Page ${index + 1} of ${pages}`}>
            {Array.from({ length: pages }, (_, i) => (
              <span key={i} className="h-[3px] flex-1 overflow-hidden rounded-full bg-white/30">
                <span className="block h-full rounded-full bg-white transition-[width] duration-300" style={{ width: i <= index ? '100%' : '0%' }} />
              </span>
            ))}
          </div>
          <div className="pointer-events-auto mt-3 flex items-center gap-2.5">
            <span className="grid h-9 w-9 shrink-0 place-items-center rounded-full text-lg ring-2 ring-white/80" style={{ background: vivid(chapter.color, 1) }} aria-hidden>
              {part.emoji}
            </span>
            <div className="min-w-0 flex-1 leading-tight">
              <p className="truncate text-[15px] font-semibold">{part.title}</p>
              <p className="truncate text-[13px] text-white/85">{chapter.title}</p>
            </div>
            <button
              onClick={toggleDirection}
              aria-label={horizontal ? 'Switch to vertical scrolling' : 'Switch to horizontal scrolling'}
              className="grid h-10 w-10 shrink-0 place-items-center rounded-full bg-black/25 text-white backdrop-blur-md transition active:scale-90"
            >
              {horizontal ? <ArrowsHorizontal /> : <ArrowsVertical />}
            </button>
            <IconLink to={backTo} label="Close" icon="close" />
          </div>
        </div>
      </header>

      {!data ? (
        <div className="grid h-full place-items-center" style={{ background: vivid(chapter.color) }}><Spinner light /></div>
      ) : (
        <div
          ref={scroller}
          className={`no-scrollbar h-full overscroll-contain ${horizontal ? 'flex snap-x snap-mandatory overflow-x-auto overflow-y-hidden' : 'snap-y snap-mandatory overflow-y-auto'}`}
        >
          {cards.map((card, i) => (
            <section key={card.id} data-index={i} className={`relative snap-start snap-always ${page}`} style={{ background: vivid(chapter.color, i) }}>
              <div aria-hidden className="scrim absolute inset-0" />
              <CardView card={card} onDeeper={() => setSheet(card)} />
            </section>
          ))}
          <section data-index={cards.length} className={`relative snap-start snap-always ${page}`} style={{ background: deep(chapter.color) }}>
            <div className="no-scrollbar relative mx-auto flex h-full max-w-xl items-center overflow-y-auto px-5 pt-[calc(env(safe-area-inset-top)+92px)] pb-[calc(env(safe-area-inset-bottom)+28px)]">
              {questions.length > 0 ? (
                <Quiz
                  questions={questions}
                  best={progress?.best_score}
                  onAnswer={(q, correct) => void logAttempt(userId, q.id, correct).catch(() => {})}
                  onFinish={async (score, total) => {
                    try {
                      setProgress(await saveQuizResult(userId, part.id, score, total, progress))
                    } catch {
                      /* score still shown; it saves again on the next attempt */
                    }
                  }}
                  onExit={goBack}
                />
              ) : (
                <div className="w-full text-center">
                  <p className="text-6xl" aria-hidden>{part.emoji}</p>
                  <h2 className="font-display mt-5 text-[34px] font-extrabold tracking-[-0.03em]">That's this part.</h2>
                  <p className="mt-2 text-[17px] text-white/80">More cards and a quiz are coming here.</p>
                  <button onClick={goBack} className="mt-8 w-full rounded-full bg-white px-5 py-4 text-[17px] font-semibold text-black active:scale-[0.97]">
                    Back to parts
                  </button>
                </div>
              )}
            </div>
          </section>
        </div>
      )}

      {!onQuiz && data && index === 0 && (
        <div aria-hidden className="pb-safe pointer-events-none absolute inset-x-0 bottom-3 z-10 flex flex-col items-center text-[13px] font-semibold text-white/85">
          <span className={horizontal ? '-rotate-90' : ''}>
            <span className="block animate-[nudge_1.6s_ease-in-out_infinite]"><ChevronUp /></span>
          </span>
          {horizontal ? 'Swipe left' : 'Swipe up'}
        </div>
      )}

      {sheet && <DeepDive card={sheet} onClose={() => setSheet(null)} />}
    </div>
  )
}

function CardView({ card, onDeeper }: { card: Card; onDeeper: () => void }) {
  const isNumber = card.kind === 'number'
  const rail = card.deep_dive || card.video_url
  return (
    <div className="relative mx-auto flex h-full max-w-xl flex-col justify-center px-5 pt-[calc(env(safe-area-inset-top)+96px)] pb-[calc(env(safe-area-inset-bottom)+64px)]">
      <div className={`no-scrollbar max-h-full overflow-y-auto ${rail ? 'pr-16' : ''}`}>
        <span className="inline-block rounded-full bg-white/18 px-3 py-1 text-[13px] font-semibold backdrop-blur-md">{KIND_LABEL[card.kind]}</span>
        <h2 className={`font-display mt-4 font-extrabold text-balance [text-shadow:0_2px_20px_rgb(0_0_0/0.2)] ${isNumber ? 'text-[54px] leading-[0.95] tracking-[-0.045em]' : 'text-[34px] leading-[1.05] tracking-[-0.03em]'}`}>
          {card.title}
        </h2>
        <div className="mt-4 text-[20px] leading-[1.5] font-medium text-white [text-shadow:0_1px_2px_rgb(0_0_0/0.25),0_2px_18px_rgb(0_0_0/0.22)]">
          <Markdown>{card.body}</Markdown>
        </div>
      </div>

      {rail && (
        <div className="absolute right-3 bottom-[calc(env(safe-area-inset-bottom)+72px)] flex flex-col items-center gap-5">
          {card.deep_dive && (
            <button onClick={onDeeper} className="flex flex-col items-center gap-1 text-[12px] font-semibold active:scale-90">
              <span className="grid h-12 w-12 place-items-center rounded-full bg-black/25 backdrop-blur-md"><Book size={22} /></span>
              {card.kind === 'what_would_you_do' ? 'Answer' : 'Deeper'}
            </button>
          )}
          {card.video_url && (
            <a href={card.video_url} target="_blank" rel="noreferrer" className="flex flex-col items-center gap-1 text-[12px] font-semibold active:scale-90">
              <span className="grid h-12 w-12 place-items-center rounded-full bg-black/25 backdrop-blur-md"><Play size={22} /></span>
              Watch
            </a>
          )}
        </div>
      )}
    </div>
  )
}

function DeepDive({ card, onClose }: { card: Card; onClose: () => void }) {
  useEffect(() => {
    const onKey = (e: KeyboardEvent) => e.key === 'Escape' && onClose()
    window.addEventListener('keydown', onKey)
    return () => window.removeEventListener('keydown', onKey)
  }, [onClose])
  return (
    <div className="absolute inset-0 z-30 flex flex-col justify-end" role="dialog" aria-modal="true" aria-label={card.title}>
      <button aria-label="Close" onClick={onClose} className="absolute inset-0 bg-black/45 animate-[rise_200ms_ease-out]" />
      <div className="pb-safe relative max-h-[72dvh] overflow-y-auto rounded-t-[28px] bg-[#141416] text-white animate-[sheet_280ms_cubic-bezier(.2,.9,.3,1)]">
        <div className="sticky top-0 flex justify-center bg-[#141416] pt-2.5 pb-1"><span className="h-1.5 w-10 rounded-full bg-white/25" /></div>
        <div className="mx-auto max-w-xl px-6 pt-3 pb-8">
          <p className="text-[13px] font-semibold text-white/55">{card.kind === 'what_would_you_do' ? 'What happened' : 'Go deeper'}</p>
          <h3 className="font-display mt-1 text-[24px] leading-tight font-bold tracking-[-0.02em]">{card.title}</h3>
          <div className="mt-4 text-[18px] leading-[1.6] text-white/92"><Markdown>{card.deep_dive ?? ''}</Markdown></div>
          <button onClick={onClose} className="mt-7 w-full rounded-full bg-white px-5 py-3.5 text-[16px] font-semibold text-black active:scale-[0.97]">Got it</button>
        </div>
      </div>
    </div>
  )
}

function scrollToPage(el: HTMLElement | null, index: number, direction: ScrollDirection) {
  const target = el?.children[index] as HTMLElement | undefined
  if (!el || !target) return
  const instant = 'instant' as ScrollBehavior
  if (direction === 'horizontal') el.scrollTo({ left: target.offsetLeft, top: 0, behavior: instant })
  else el.scrollTo({ top: target.offsetTop, left: 0, behavior: instant })
}

function emptyProgress(userId: string, partId: string): PartProgress {
  return { user_id: userId, part_id: partId, last_card_index: 0, cards_completed: false, best_score: null, last_score: null, total_questions: null, attempts: 0, completed_at: null }
}
