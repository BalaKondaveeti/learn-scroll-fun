import type { ProgressNode } from './types'

// A chapter counts as done when it has parts and every one of them is finished.
export function isChapterDone(node?: ProgressNode) {
  return !!node && node.leaf_total > 0 && node.leaf_done >= node.leaf_total
}

// Most recently touched first; untouched chapters keep their usual order after them.
export function byLastTouched<T extends { id: string; sort_order: number }>(chapters: T[], touched: Map<string, number>) {
  return [...chapters].sort((a, b) => (touched.get(b.id) ?? 0) - (touched.get(a.id) ?? 0) || a.sort_order - b.sort_order)
}

// Combine server activity with this device's chapter opens, keeping the newer time for each.
export function mergeTouched(server: Map<string, number>, local: Record<string, number>) {
  const out = new Map(server)
  for (const [id, at] of Object.entries(local)) if (at > (out.get(id) ?? 0)) out.set(id, at)
  return out
}
