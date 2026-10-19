import type { ReactNode } from 'react'
import { Link } from 'react-router-dom'

export function BackButton({ to, label = 'Back' }: { to: string; label?: string }) {
  return (
    <Link
      to={to}
      aria-label={label}
      className="grid h-10 w-10 place-items-center rounded-full bg-[var(--surface)]/80 text-xl backdrop-blur transition active:scale-95"
    >
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round">
        <path d="M15 18l-6-6 6-6" />
      </svg>
    </Link>
  )
}

export function Spinner() {
  return (
    <div className="grid min-h-[40dvh] place-items-center" role="status" aria-label="Loading">
      <div className="h-8 w-8 animate-spin rounded-full border-[3px] border-[var(--line)] border-t-[var(--ink)]" />
    </div>
  )
}

export function ErrorNotice({ error, onRetry }: { error: Error; onRetry?: () => void }) {
  const missingSchema = /ls_|function|relation/.test(error.message) && /does not exist|not find/.test(error.message)
  return (
    <div className="mx-5 my-8 rounded-3xl border border-red-400/40 bg-red-500/10 p-5">
      <p className="font-bold">Couldn't load this.</p>
      <p className="mt-1 break-words text-[var(--muted)]">
        {missingSchema ? 'The database tables are missing. Run supabase/migrations/001_init.sql in the Supabase SQL editor.' : error.message}
      </p>
      {onRetry && (
        <button onClick={onRetry} className="mt-4 rounded-full bg-[var(--ink)] px-5 py-2 font-bold text-[var(--bg)] active:scale-95">
          Try again
        </button>
      )}
    </div>
  )
}

export function Page({ children }: { children: ReactNode }) {
  return <main className="pt-safe pb-safe mx-auto min-h-dvh w-full max-w-xl">{children}</main>
}
