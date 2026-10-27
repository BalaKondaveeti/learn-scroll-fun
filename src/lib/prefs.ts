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

// How Home shows chapters below the big "continue" tile: a compact list (default) or a grid of tiles.
export type HomeLayout = 'list' | 'tiles'
const LAYOUT_KEY = 'ls.homeLayout'

export function getHomeLayout(): HomeLayout {
  try {
    return localStorage.getItem(LAYOUT_KEY) === 'tiles' ? 'tiles' : 'list'
  } catch {
    return 'list'
  }
}

export function saveHomeLayout(layout: HomeLayout) {
  try {
    localStorage.setItem(LAYOUT_KEY, layout)
  } catch {
    /* private mode: the choice just won't persist */
  }
}
