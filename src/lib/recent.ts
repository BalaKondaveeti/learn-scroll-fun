// Remembers the chapter opened most recently on this device, so Home can put it first
// even before any card progress has been saved.
const KEY = 'ls.lastChapter'

export function markChapterVisited(chapterId: string) {
  try {
    localStorage.setItem(KEY, JSON.stringify({ chapterId, at: Date.now() }))
  } catch {
    /* ignore */
  }
}

export function getLocalLastChapter(): { chapterId: string; at: number } | null {
  try {
    const v = JSON.parse(localStorage.getItem(KEY) ?? 'null')
    return v && typeof v.chapterId === 'string' && typeof v.at === 'number' ? v : null
  } catch {
    return null
  }
}

export function forgetLastChapter() {
  try {
    localStorage.removeItem(KEY)
  } catch {
    /* ignore */
  }
}
