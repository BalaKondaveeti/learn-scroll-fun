import { createClient, type SupabaseClient } from '@supabase/supabase-js'

// The URL and publishable key are public by design. Data is protected by
// Row Level Security on the ls_ tables, not by hiding the key.
const url = import.meta.env.VITE_SUPABASE_URL
const key = import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY

let client: SupabaseClient | null = null

export function sb(): SupabaseClient {
  if (!client) {
    if (!url || !key) throw new Error('Missing VITE_SUPABASE_URL or VITE_SUPABASE_PUBLISHABLE_KEY')
    client = createClient(url, key, {
      // PKCE puts the magic-link code in ?code=, which doesn't clash with HashRouter's #/ routes.
      auth: { flowType: 'pkce', persistSession: true, autoRefreshToken: true, detectSessionInUrl: true },
    })
  }
  return client
}
