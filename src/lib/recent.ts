// Remembers when each chapter was last opened on this device, so ordering reacts as soon as
// you open one, even before any card progress has been saved to the server.
const KEY = 'ls.chapterVisits'
const OLD_KEY = 'ls.lastChapter'

type Visits = Record<string, number>

function read(): Visits {
  try {
    const v = JSON.parse(localStorage.getItem(KEY) ?? 'null')
    if (v && typeof v === 'object') return v as Visits
    // Carry over the single "last chapter" saved by the previous version.
    const old = JSON.parse(localStorage.getItem(OLD_KEY) ?? 'null')
    return old && typeof old.chapterId === 'string' && typeof old.at === 'number' ? { [old.chapterId]: old.at } : {}
  } catch {
    return {}
  }
}

export function markChapterVisited(chapterId: string) {
  try {
    localStorage.setItem(KEY, JSON.stringify({ ...read(), [chapterId]: Date.now() }))
  } catch {
    /* ignore */
  }
}

export function getLocalVisits(): Visits {
  return read()
}

export function forgetVisits(chapterId?: string) {
  try {
    if (chapterId) {
      const v = read()
      delete v[chapterId]
      localStorage.setItem(KEY, JSON.stringify(v))
    } else {
      localStorage.removeItem(KEY)
    }
    localStorage.removeItem(OLD_KEY)
  } catch {
    /* ignore */
  }
}
