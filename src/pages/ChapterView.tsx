import { useParams } from 'react-router-dom'
import { BackButton, ErrorNotice, Page, Spinner } from '../components/Bits'
import { PartTile } from '../components/PartTile'
import { ProgressRing } from '../components/ProgressRing'
import { glow } from '../lib/color'
import { getChapter, getParts, getProgress } from '../lib/data'
import type { Part } from '../lib/types'
import { useAsync } from '../lib/useAsync'
import Reels from './Reels'

// Handles both /c/:chapterSlug (top-level parts) and /c/:chapterSlug/p/:partSlug
// (a parent part's sub-parts, or a leaf part's cards).
export default function ChapterView() {
  const { chapterSlug = '', partSlug } = useParams()
  const { data, error, reload } = useAsync(async () => {
    const chapter = await getChapter(chapterSlug)
    const [parts, progress] = await Promise.all([getParts(chapter.id), getProgress()])
    return { chapter, parts, progress }
  }, [chapterSlug, partSlug])

  if (error) return <Page><ErrorNotice error={error} onRetry={reload} /></Page>
  if (!data) return <Page><Spinner /></Page>

  const { chapter, parts, progress } = data
  const bySlug = new Map(parts.map((p) => [p.slug, p]))
  const byId = new Map(parts.map((p) => [p.id, p]))
  const childrenOf = (id: string | null) => parts.filter((p) => p.parent_part_id === id)
  const partPath = (p: Part) => `/c/${chapter.slug}/p/${p.slug}`

  const current = partSlug ? bySlug.get(partSlug) : undefined
  if (partSlug && !current) return <Page><ErrorNotice error={new Error(`No part called "${partSlug}"`)} /></Page>

  const parent = current?.parent_part_id ? byId.get(current.parent_part_id) : undefined
  const backTo = current ? (parent ? partPath(parent) : `/c/${chapter.slug}`) : '/'
  const children = childrenOf(current?.id ?? null)

  if (current && children.length === 0) {
    return <Reels key={current.id} chapter={chapter} part={current} backTo={backTo} />
  }

  const node = progress.get(current?.id ?? chapter.id)
  const heading = current ?? chapter

  return (
    <Page>
      <div aria-hidden className="pointer-events-none fixed inset-x-0 top-0 -z-10 h-[60dvh]" style={{ background: glow(chapter.color) }} />
      <header className="sticky top-0 z-10 flex items-center justify-between px-5 pt-4 pb-2">
        <BackButton to={backTo} />
        <ProgressRing value={node?.progress ?? 0} color={chapter.color} size={40} />
      </header>
      <section className="px-5 pt-4 pb-6">
        <span className="text-5xl" aria-hidden>{heading.emoji}</span>
        {current && <p className="mt-4 text-[15px] text-[var(--muted)]">{parent ? parent.title : chapter.title}</p>}
        <h1 className={`font-display text-[38px] leading-[1.02] font-extrabold tracking-tight ${current ? 'mt-1' : 'mt-4'}`}>{heading.title}</h1>
        {heading.description && <p className="mt-3 text-lg leading-snug text-[var(--muted)]">{heading.description}</p>}
        {node && node.leaf_total > 0 && (
          <p className="mt-3 text-sm text-[var(--muted)]">
            {node.leaf_done} of {node.leaf_total} parts finished
          </p>
        )}
      </section>
      <div className="flex flex-col gap-3 px-5 pb-12">
        {children.map((p) => (
          <PartTile key={p.id} part={p} to={partPath(p)} color={chapter.color} node={progress.get(p.id)} childCount={childrenOf(p.id).length} />
        ))}
      </div>
    </Page>
  )
}
