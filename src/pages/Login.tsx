import { useState, type FormEvent } from 'react'
import { Navigate, useLocation } from 'react-router-dom'
import { useAuth } from '../lib/authContext'
import { sb } from '../lib/supabase'

type Mode = 'signin' | 'signup' | 'magic'

export default function Login() {
  const { session, ready } = useAuth()
  const location = useLocation()
  const [mode, setMode] = useState<Mode>('signin')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<{ kind: 'error' | 'info'; text: string } | null>(null)

  if (ready && session) {
    const from = (location.state as { from?: string } | null)?.from
    return <Navigate to={from && from !== '/login' ? from : '/'} replace />
  }

  async function submit(e: FormEvent) {
    e.preventDefault()
    setBusy(true)
    setMessage(null)
    const auth = sb().auth
    const redirect = `${window.location.origin}${import.meta.env.BASE_URL}`
    try {
      if (mode === 'signin') {
        const { error } = await auth.signInWithPassword({ email, password })
        if (error) throw error
      } else if (mode === 'signup') {
        const { data, error } = await auth.signUp({ email, password, options: { emailRedirectTo: redirect } })
        if (error) throw error
        if (!data.session) setMessage({ kind: 'info', text: 'Check your email to confirm your account, then sign in.' })
      } else {
        const { error } = await auth.signInWithOtp({ email, options: { emailRedirectTo: redirect, shouldCreateUser: false } })
        if (error) throw error
        setMessage({ kind: 'info', text: `Sign-in link sent to ${email}. Open it on this device.` })
      }
    } catch (err) {
      setMessage({ kind: 'error', text: (err as Error).message })
    } finally {
      setBusy(false)
    }
  }

  const field =
    'w-full rounded-2xl border border-[var(--line)] bg-[var(--surface)] px-4 py-3.5 text-[17px] outline-none focus:border-[var(--ink)]'

  return (
    <main className="pt-safe pb-safe relative mx-auto flex min-h-dvh w-full max-w-md flex-col justify-center overflow-hidden px-6">
      <div aria-hidden className="pointer-events-none absolute inset-x-0 top-0 -z-10 h-[55dvh]" style={{ background: 'radial-gradient(90% 70% at 30% 0%, #ff8a6566 0%, transparent 60%), radial-gradient(80% 60% at 90% 10%, #7c6cff55 0%, transparent 65%)' }} />
      <img src={`${import.meta.env.BASE_URL}icon.svg`} alt="" className="h-16 w-16 rounded-2xl" />
      <h1 className="font-display mt-6 text-[44px] leading-[0.95] font-extrabold tracking-tight">
        One idea
        <br />
        at a time.
      </h1>
      <p className="mt-3 text-lg text-[var(--muted)]">Short cards, then a quick quiz. Your progress follows you.</p>

      <form onSubmit={submit} className="mt-8 flex flex-col gap-3">
        <input className={field} type="email" autoComplete="email" inputMode="email" placeholder="Email" required value={email} onChange={(e) => setEmail(e.target.value)} />
        {mode !== 'magic' && (
          <input
            className={field}
            type="password"
            autoComplete={mode === 'signup' ? 'new-password' : 'current-password'}
            placeholder="Password"
            required
            minLength={6}
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />
        )}
        <button disabled={busy} className="mt-1 rounded-2xl bg-[var(--ink)] px-5 py-4 text-lg font-bold text-[var(--bg)] transition active:scale-[0.98] disabled:opacity-60">
          {busy ? 'One moment…' : mode === 'signin' ? 'Sign in' : mode === 'signup' ? 'Create account' : 'Email me a link'}
        </button>
      </form>

      {message && (
        <p role="status" className={`mt-4 text-[15px] ${message.kind === 'error' ? 'text-rose-400' : 'text-[var(--muted)]'}`}>
          {message.text}
        </p>
      )}

      <div className="mt-6 flex flex-wrap gap-x-5 gap-y-2 text-[15px] text-[var(--muted)]">
        {mode !== 'signin' && <button onClick={() => setMode('signin')} className="underline underline-offset-4">Sign in with password</button>}
        {mode !== 'magic' && <button onClick={() => setMode('magic')} className="underline underline-offset-4">Email me a sign-in link</button>}
        {mode !== 'signup' && <button onClick={() => setMode('signup')} className="underline underline-offset-4">Create an account</button>}
      </div>
    </main>
  )
}
