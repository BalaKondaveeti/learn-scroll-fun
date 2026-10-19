import { useEffect, useState, type ReactNode } from 'react'
import { Navigate, Outlet, useLocation } from 'react-router-dom'
import { AuthContext, useAuth, type AuthState } from './authContext'
import { sb } from './supabase'

export function AuthProvider({ children }: { children: ReactNode }) {
  const [state, setState] = useState<AuthState>({ session: null, ready: false })
  useEffect(() => {
    const client = sb()
    client.auth.getSession().then(({ data }) => setState({ session: data.session, ready: true }))
    const { data } = client.auth.onAuthStateChange((_event, session) => setState({ session, ready: true }))
    return () => data.subscription.unsubscribe()
  }, [])
  return <AuthContext.Provider value={state}>{children}</AuthContext.Provider>
}

export function RequireAuth() {
  const { session, ready } = useAuth()
  const location = useLocation()
  if (!ready) return null
  if (!session) return <Navigate to="/login" replace state={{ from: location.pathname }} />
  return <Outlet />
}
