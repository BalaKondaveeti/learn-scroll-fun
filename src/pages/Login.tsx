import { useState, type FormEvent } from 'react'
import { Navigate, useLocation } from 'react-router-dom'
import { useAuth } from '../lib/authContext'
import { vivid } from '../lib/color'
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
    'w-full rounded-2xl bg-white/15 px-4 py-3.5 text-[17px] text-white placeholder:text-white/65 ring-1 ring-white/25 outline-none backdrop-blur-md focus:ring-2 focus:ring-white'
  const link = 'font-semibold text-white/85 underline decoration-white/40 underline-offset-4'

  return (
    <main className="pt-safe pb-safe fixed inset-0 overflow-y-auto text-white"
      style={{ background: `${vivid('#d946ef', 0)}, ${vivid('#8b5cf6', 3)}`, backgroundSize: '200% 200%', animation: 'drift 14s ease-in-out infinite alternate' }}>
      <div aria-hidden className="scrim pointer-events-none absolute inset-0" />
      <div className="relative mx-auto flex min-h-full w-full max-w-md flex-col justify-end px-6 pt-16 pb-10">
        <div className="flex items-center gap-3">
          <img src={`${import.meta.env.BASE_URL}icon.svg?v=2`} alt="" className="h-14 w-14 rounded-2xl shadow-lg" />
          <span className="text-[20px] font-bold tracking-[-0.02em]">Scroll to Learn</span>
        </div>
        <h1 className="font-display mt-6 text-[48px] leading-[0.95] font-extrabold tracking-[-0.045em]">
          One idea
          <br />
          at a time.
        </h1>
        <p className="mt-3 text-[18px] text-white/85">Swipe through short cards, then take a quick quiz.</p>

        <form onSubmit={submit} className="mt-8 flex flex-col gap-2.5">
          <input className={field} type="email" autoComplete="email" inputMode="email" placeholder="Email" required value={email} onChange={(e) => setEmail(e.target.value)} />
          {mode !== 'magic' && (
            <input className={field} type="password" autoComplete={mode === 'signup' ? 'new-password' : 'current-password'} placeholder="Password" required minLength={6}
              value={password} onChange={(e) => setPassword(e.target.value)} />
          )}
          <button disabled={busy} className="mt-1.5 rounded-full bg-white px-5 py-4 text-[17px] font-semibold text-black transition active:scale-[0.97] disabled:opacity-60">
            {busy ? 'One moment…' : mode === 'signin' ? 'Sign in' : mode === 'signup' ? 'Create account' : 'Email me a link'}
          </button>
        </form>

        {message && (
          <p role="status" className={`mt-4 rounded-2xl px-4 py-3 text-[15px] ${message.kind === 'error' ? 'bg-rose-950/50' : 'bg-black/25'}`}>{message.text}</p>
        )}

        <div className="mt-6 flex flex-wrap gap-x-5 gap-y-2 text-[15px]">
          {mode !== 'signin' && <button onClick={() => setMode('signin')} className={link}>Sign in with password</button>}
          {mode !== 'magic' && <button onClick={() => setMode('magic')} className={link}>Email me a sign-in link</button>}
          {mode !== 'signup' && <button onClick={() => setMode('signup')} className={link}>Create an account</button>}
        </div>
      </div>
    </main>
  )
}
