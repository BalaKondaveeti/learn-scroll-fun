const KEY = 'ls.theme'
export type Theme = 'dark' | 'light'

export function getTheme(): Theme {
  try {
    return localStorage.getItem(KEY) === 'light' ? 'light' : 'dark'
  } catch {
    return 'dark'
  }
}

export function applyTheme(theme: Theme) {
  document.documentElement.classList.toggle('dark', theme === 'dark')
  document.querySelector('meta[name="theme-color"]')?.setAttribute('content', theme === 'dark' ? '#000000' : '#ffffff')
  try {
    localStorage.setItem(KEY, theme)
  } catch {
    /* private mode: theme just won't persist */
  }
}
