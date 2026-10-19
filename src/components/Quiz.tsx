import { useState, type CSSProperties } from 'react'
import { alpha } from '../lib/color'
import type { Question } from '../lib/types'

type Props = {
  questions: Question[]
  color: string
  best?: number | null
  onAnswer: (question: Question, correct: boolean) => void
  onFinish: (score: number, total: number) => void
  onExit: () => void
  exitLabel?: string
}

export function Quiz({ questions, color, best, onAnswer, onFinish, onExit, exitLabel = 'Back to parts' }: Props) {
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

  if (finished) {
    const perfect = score === total
    const bestShown = Math.max(best ?? 0, score)
    return (
      <div className="flex flex-col items-center text-center">
        <p className="text-[var(--muted)]">Your score</p>
        <p className="font-display mt-1 text-7xl font-extrabold tabular-nums animate-[pop_500ms_ease-out]" style={{ color }}>
          {score}/{total}
        </p>
        <p className="mt-3 text-lg">
          {perfect ? 'Every one right.' : score >= total * 0.6 ? 'Solid. Retry to lock in the rest.' : 'Worth another pass.'}
        </p>
        <p className="mt-1 text-sm text-[var(--muted)]">
          Best: {bestShown}/{total}
        </p>
        <div className="mt-8 flex w-full flex-col gap-3">
          <button onClick={retry} className="rounded-2xl px-5 py-4 text-lg font-bold text-white active:scale-[0.98]" style={{ background: color }}>
            Retry quiz
          </button>
          <button onClick={onExit} className="rounded-2xl border border-[var(--line)] px-5 py-4 text-lg font-bold active:scale-[0.98]">
            {exitLabel}
          </button>
        </div>
      </div>
    )
  }

  return (
    <div>
      <div className="flex items-center justify-between text-sm text-[var(--muted)]">
        <span>
          Question {index + 1} of {total}
        </span>
        <span className="tabular-nums">{score} right</span>
      </div>
      <h2 key={q.id} className="font-display mt-3 text-[26px] leading-tight font-bold animate-[rise_350ms_ease-out]">
        {q.question}
      </h2>
      <div className="mt-6 flex flex-col gap-3" role="list">
        {q.options.map((option, i) => {
          const isCorrect = i === q.correct_index
          const isPicked = i === picked
          const revealed = picked !== null
          let style: CSSProperties = {}
          let cls = 'border-[var(--line)] bg-[var(--surface)]'
          if (revealed && isCorrect) {
            style = { borderColor: '#22c55e', background: alpha('#22c55e', 0.16) }
            cls = isPicked ? 'animate-[pop_420ms_ease-out]' : ''
          } else if (revealed && isPicked) {
            style = { borderColor: '#f43f5e', background: alpha('#f43f5e', 0.14) }
            cls = 'animate-[shake_380ms_ease-in-out]'
          } else if (revealed) {
            cls = 'border-[var(--line)] bg-[var(--surface)] opacity-55'
          }
          return (
            <button
              key={i}
              role="listitem"
              onClick={() => pick(i)}
              disabled={revealed}
              className={`relative flex items-center gap-3 rounded-2xl border-2 px-4 py-3.5 text-left text-[17px] leading-snug transition active:scale-[0.98] ${cls}`}
              style={style}
            >
              <span className="grid h-7 w-7 shrink-0 place-items-center rounded-full border border-current/30 text-sm font-bold">
                {revealed && isCorrect ? '✓' : revealed && isPicked ? '✕' : String.fromCharCode(65 + i)}
              </span>
              <span>{option}</span>
              {revealed && isCorrect && isPicked && <Sparkle />}
            </button>
          )
        })}
      </div>
      {picked !== null && (
        <div className="mt-5 animate-[rise_300ms_ease-out]">
          <p className="font-bold">{picked === q.correct_index ? 'Correct.' : 'Not quite.'}</p>
          {q.explanation && <p className="mt-1 text-[var(--muted)]">{q.explanation}</p>}
          <button onClick={next} className="mt-5 w-full rounded-2xl px-5 py-4 text-lg font-bold text-white active:scale-[0.98]" style={{ background: color }}>
            {index + 1 < total ? 'Next question' : 'See score'}
          </button>
        </div>
      )}
    </div>
  )
}

function Sparkle() {
  return (
    <span aria-hidden className="pointer-events-none absolute top-1/2 right-5">
      {Array.from({ length: 6 }, (_, i) => (
        <span
          key={i}
          className="absolute h-1.5 w-1.5 rounded-full bg-[#22c55e] animate-[burst_600ms_ease-out_forwards]"
          style={{ ['--a' as string]: `${i * 60}deg` }}
        />
      ))}
    </span>
  )
}
