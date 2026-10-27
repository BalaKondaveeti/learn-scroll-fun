import { useState, type ReactNode } from 'react'
import type { Question } from '../lib/types'
import { Check, Close } from './Icons'

// Designed to sit on full-bleed color: everything is white or translucent white.
type Props = {
  questions: Question[]
  best?: number | null
  onAnswer: (question: Question, correct: boolean) => void
  onFinish: (score: number, total: number) => void
  onExit: () => void
  exitLabel?: string
}

export function Quiz({ questions, best, onAnswer, onFinish, onExit, exitLabel = 'Back to parts' }: Props) {
  const [index, setIndex] = useState(0)
  const [picked, setPicked] = useState<number | null>(null)
  const [score, setScore] = useState(0)
  const [finished, setFinished] = useState(false)
  const total = questions.length
  const q = questions[index]

  function pick(i: number) {
    if (picked !== null) return
    const correct = i === q.correct_index
    setPicked(i)
    if (correct) setScore((s) => s + 1)
    onAnswer(q, correct)
    navigator.vibrate?.(correct ? 12 : [20, 40, 20])
  }

  function next() {
    if (index + 1 < total) {
      setIndex(index + 1)
      setPicked(null)
    } else {
      setFinished(true)
      onFinish(score, total)
    }
  }

  function retry() {
    setIndex(0)
    setPicked(null)
    setScore(0)
    setFinished(false)
  }

  const primary = 'w-full rounded-full bg-white px-5 py-4 text-[17px] font-semibold text-black transition active:scale-[0.97]'
  const secondary = 'w-full rounded-full bg-white/15 px-5 py-4 text-[17px] font-semibold text-white backdrop-blur-md transition active:scale-[0.97]'

  if (finished) {
    const bestShown = Math.max(best ?? 0, score)
    return (
      <div className="relative flex w-full flex-col items-center text-center text-white">
        {score >= total * 0.6 && <Confetti big={score === total} />}
        <p className="text-[15px] font-semibold text-white/75">Quiz complete</p>
        <p className="font-display mt-2 text-[96px] leading-none font-extrabold tracking-[-0.04em] tabular-nums animate-[pop_500ms_ease-out]">
          {score}<span className="text-white/45">/{total}</span>
        </p>
        <p className="mt-4 text-[19px] font-medium">
          {score === total ? 'Every one right.' : score >= total * 0.6 ? 'Solid. Retry to lock in the rest.' : 'Worth another pass.'}
        </p>
        <p className="mt-1 text-[15px] text-white/70">Best {bestShown}/{total}</p>
        <div className="mt-10 flex w-full flex-col gap-3">
          <button onClick={retry} className={primary}>Retry quiz</button>
          <button onClick={onExit} className={secondary}>{exitLabel}</button>
        </div>
      </div>
    )
  }

  const revealed = picked !== null
  return (
    <div className="w-full text-white">
      <div className="flex gap-1.5" aria-label={`Question ${index + 1} of ${total}`}>
        {questions.map((_, i) => (
          <span key={i} className={`h-1.5 flex-1 rounded-full ${i < index || (i === index && revealed) ? 'bg-white' : i === index ? 'bg-white/55' : 'bg-white/20'}`} />
        ))}
      </div>
      <p className="mt-6 text-[15px] font-semibold text-white/70">Question {index + 1} of {total}</p>
      <h2 key={q.id} className="font-display mt-2 text-[28px] leading-[1.12] font-bold tracking-[-0.02em] animate-[rise_350ms_ease-out]">{q.question}</h2>
      <div className="mt-6 flex flex-col gap-2.5">
        {q.options.map((option, i) => {
          const isCorrect = i === q.correct_index
          const isPicked = i === picked
          let look = 'bg-black/20 text-white ring-1 ring-white/35 backdrop-blur-md'
          let mark: ReactNode = String.fromCharCode(65 + i)
          if (revealed && isCorrect) {
            look = `bg-white text-black ${isPicked ? 'animate-[pop_420ms_ease-out]' : ''}`
            mark = <span className="text-emerald-600"><Check /></span>
          } else if (revealed && isPicked) {
            look = 'bg-rose-500/85 text-white ring-1 ring-rose-200/40 animate-[shake_380ms_ease-in-out]'
            mark = <Close size={15} />
          } else if (revealed) {
            look = 'bg-black/15 text-white/60'
          }
          return (
            <button key={i} data-option={i} onClick={() => pick(i)} disabled={revealed}
              className={`relative flex items-center gap-3 rounded-2xl px-4 py-3.5 text-left text-[17px] leading-snug font-medium transition active:scale-[0.98] ${look}`}>
              <span className="grid h-7 w-7 shrink-0 place-items-center rounded-full bg-current/10 text-[13px] font-bold">{mark}</span>
              <span>{option}</span>
              {revealed && isCorrect && isPicked && <Sparkle />}
            </button>
          )
        })}
      </div>
      {revealed && (
        <div className="mt-5 animate-[rise_300ms_ease-out]">
          <p className="text-[17px] font-bold">{picked === q.correct_index ? 'Correct!' : 'Not quite.'}</p>
          {q.explanation && <p className="mt-1 text-[17px] leading-relaxed text-white">{q.explanation}</p>}
          <button onClick={next} className={`mt-5 ${primary}`}>{index + 1 < total ? 'Next question' : 'See score'}</button>
        </div>
      )}
    </div>
  )
}

function Sparkle() {
  return (
    <span aria-hidden className="pointer-events-none absolute top-1/2 right-6">
      {Array.from({ length: 8 }, (_, i) => (
        <span key={i} className="absolute h-1.5 w-1.5 rounded-full bg-emerald-500 animate-[burst_650ms_ease-out_forwards]" style={{ ['--a' as string]: `${i * 45}deg` }} />
      ))}
    </span>
  )
}

const CONFETTI_COLORS = ['#ffd166', '#ff6b8b', '#a855f7', '#5eead4', '#ffffff', '#60a5fa']

// A one-off burst from behind the score. Positions are seeded so every render is the same.
function Confetti({ big }: { big: boolean }) {
  const n = big ? 60 : 36
  return (
    <div aria-hidden className="pointer-events-none absolute top-28 left-1/2 z-10 h-0 w-0">
      {Array.from({ length: n }, (_, i) => {
        const angle = (i / n) * Math.PI * 2 + ((i * 37) % 10) / 10
        const dist = 130 + ((i * 53) % 110) * (big ? 1.3 : 1)
        const x = Math.cos(angle) * dist
        const y = Math.sin(angle) * dist * 0.6 + 260
        return (
          <span
            key={i}
            className="absolute block rounded-[2px]"
            style={{
              width: i % 3 ? 9 : 13,
              height: i % 3 ? 15 : 8,
              background: CONFETTI_COLORS[i % CONFETTI_COLORS.length],
              animation: `confetti ${1700 + ((i * 29) % 700)}ms cubic-bezier(.2,.6,.4,1) ${120 + (i % 6) * 30}ms both`,
              ['--x' as string]: `${x}px`,
              ['--y' as string]: `${y}px`,
              ['--r' as string]: `${(i % 2 ? 1 : -1) * (180 + ((i * 41) % 360))}deg`,
            }}
          />
        )
      })}
    </div>
  )
}
