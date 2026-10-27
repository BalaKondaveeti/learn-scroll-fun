import type { ReactNode } from 'react'
import { useGoBack } from '../lib/nav'
import { ChevronLeft, Close } from './Icons'

// Goes back to `to` (the parent screen) by stepping back through history when possible.
// "glass" sits on full-bleed color; "plain" sits on the black/white app background.
export function IconLink({ to, label, variant = 'glass', icon = 'back' }: { to: string; label: string; variant?: 'glass' | 'plain'; icon?: 'back' | 'close' }) {
  const goBack = useGoBack(to)
  const look = variant === 'glass' ? 'bg-black/25 text-white backdrop-blur-md' : 'bg-[var(--raised)] text-[var(--ink)]'
  return (
    <button type="button" onClick={goBack} aria-label={label} className={`grid h-10 w-10 shrink-0 place-items-center rounded-full transition active:scale-90 ${look}`}>
      {icon === 'back' ? <ChevronLeft /> : <Close size={20} />}
    </button>
  )
}

export function Spinner({ light = false }: { light?: boolean }) {
  return (
    <div className="grid min-h-[40dvh] place-items-center" role="status" aria-label="Loading">
      <div className={`h-7 w-7 animate-spin rounded-full border-[3px] ${light ? 'border-white/30 border-t-white' : 'border-[var(--line)] border-t-[var(--ink)]'}`} />
    </div>
  )
}

export function ErrorNotice({ error, onRetry }: { error: Error; onRetry?: () => void }) {
  const missingSchema = /ls_|function|relation/.test(error.message) && /does not exist|not find/.test(error.message)
  return (
    <div className="mx-4 my-8 rounded-3xl bg-[var(--raised)] p-5">
      <p className="font-semibold">Couldn't load this.</p>
      <p className="mt-1 break-words text-[var(--muted)]">
        {missingSchema ? 'The database tables are missing. Run supabase/migrations/001_init.sql in the Supabase SQL editor.' : error.message}
      </p>
      {onRetry && (
        <button onClick={onRetry} className="mt-4 rounded-full bg-[var(--ink)] px-5 py-2.5 font-semibold text-[var(--bg)] active:scale-95">
          Try again
        </button>
      )}
    </div>
  )
}

export function Page({ children }: { children: ReactNode }) {
  return <main className="pb-safe mx-auto min-h-dvh w-full max-w-xl">{children}</main>
}
