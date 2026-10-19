import type { Session } from '@supabase/supabase-js'
import { createContext, useContext } from 'react'

export type AuthState = { session: Session | null; ready: boolean }
export const AuthContext = createContext<AuthState>({ session: null, ready: false })

export const useAuth = () => useContext(AuthContext)

export function useUserId() {
  const id = useAuth().session?.user.id
  if (!id) throw new Error('Not signed in')
  return id
}
