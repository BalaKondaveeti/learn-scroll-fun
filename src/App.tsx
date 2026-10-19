import { HashRouter, Route, Routes } from 'react-router-dom'

function Placeholder() {
  return (
    <main className="pt-safe pb-safe flex min-h-dvh flex-col justify-center px-6">
      <h1 className="font-display text-4xl font-extrabold">learn-scroll-fun</h1>
      <p className="mt-3 text-lg text-[var(--muted)]">Short cards, one idea each. Setting things up.</p>
    </main>
  )
}

export default function App() {
  return (
    <HashRouter>
      <Routes>
        <Route path="*" element={<Placeholder />} />
      </Routes>
    </HashRouter>
  )
}
