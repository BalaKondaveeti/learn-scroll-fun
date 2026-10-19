// How cards advance: vertical (swipe up, like reels) or horizontal (swipe left, like stories).
export type ScrollDirection = 'vertical' | 'horizontal'
const KEY = 'ls.scroll'

export function getScrollDirection(): ScrollDirection {
  try {
    return localStorage.getItem(KEY) === 'horizontal' ? 'horizontal' : 'vertical'
  } catch {
    return 'vertical'
  }
}

export function saveScrollDirection(direction: ScrollDirection) {
  try {
    localStorage.setItem(KEY, direction)
  } catch {
    /* private mode: the choice just won't persist */
  }
}
