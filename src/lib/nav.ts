import { useCallback } from 'react'
import { useLocation, useNavigate } from 'react-router-dom'

// Forward links record where they came from in history state, so back buttons can
// step back through history instead of pushing the parent page as a new entry.
// Without that, finishing a lesson and tapping "Back" left the lesson behind the
// parent page, and the phone's swipe-back gesture reopened it.
export type FromState = { from?: string }

export function useFromHere(): FromState {
  return { from: useLocation().pathname }
}

export function useGoBack(fallback: string) {
  const navigate = useNavigate()
  const location = useLocation()
  const from = (location.state as FromState | null)?.from
  return useCallback(() => {
    if (from === fallback) navigate(-1)
    else navigate(fallback, { replace: true })
  }, [from, fallback, navigate])
}
