import { useEffect, useState } from 'react'

type Props = {
  title: string
  message: string
  confirmLabel: string
  onConfirm: () => Promise<void>
  onClose: () => void
}

// A bottom sheet for destructive actions, so a stray tap can't wipe progress.
export function Confirm({ title, message, confirmLabel, onConfirm, onClose }: Props) {
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState<string | null>(null)
  useEffect(() => {
    const onKey = (e: KeyboardEvent) => e.key === 'Escape' && !busy && onClose()
    window.addEventListener('keydown', onKey)
    return () => window.removeEventListener('keydown', onKey)
  }, [busy, onClose])

  async function go() {
    setBusy(true)
    setError(null)
    try {
      await onConfirm()
      onClose()
    } catch (e) {
      setError((e as Error).message)
      setBusy(false)
    }
  }

  return (
    <div className="fixed inset-0 z-40 flex flex-col justify-end" role="alertdialog" aria-modal="true" aria-label={title}>
      <button aria-label="Cancel" onClick={() => !busy && onClose()} className="absolute inset-0 bg-black/55 animate-[rise_200ms_ease-out]" />
      <div className="pb-safe relative mx-auto w-full max-w-xl rounded-t-[28px] bg-[var(--raised)] px-6 pt-6 pb-6 text-[var(--ink)] animate-[sheet_260ms_cubic-bezier(.2,.9,.3,1)]">
        <h2 className="text-[22px] font-bold tracking-[-0.02em]">{title}</h2>
        <p className="mt-2 text-[17px] leading-snug text-[var(--muted)]">{message}</p>
        {error && <p className="mt-3 text-[15px] text-rose-500">{error}</p>}
        <div className="mt-6 flex flex-col gap-2.5">
          <button onClick={go} disabled={busy} className="rounded-full bg-rose-600 px-5 py-4 text-[17px] font-semibold text-white active:scale-[0.97] disabled:opacity-60">
            {busy ? 'Resetting…' : confirmLabel}
          </button>
          <button onClick={onClose} disabled={busy} className="rounded-full bg-[var(--bg)] px-5 py-4 text-[17px] font-semibold active:scale-[0.97]">
            Cancel
          </button>
        </div>
      </div>
    </div>
  )
}
