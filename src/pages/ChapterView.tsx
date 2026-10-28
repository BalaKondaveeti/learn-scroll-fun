import { useEffect, useState } from 'react'
import { useLocation, useParams } from 'react-router-dom'
import { ErrorNotice, IconLink, Page, Spinner } from '../components/Bits'
import { Confirm } from '../components/Confirm'
import { PartTile } from '../components/PartTile'
import { ProgressRing } from '../components/ProgressRing'
import { vivid } from '../lib/color'
import { useUserId } from '../lib/authContext'
import { getChapter, getParts, getProgress, resetChapterProgress } from '../lib/data'
import { forgetVisits, markChapterVisited } from '../lib/recent'
import type { Part } from '../lib/types'
import { useAsync } from '../lib/useAsync'
import Reels from './Reels'

// Handles both /c/:chapterSlug (top-level parts) and /c/:chapterSlug/p/:partSlug
// (a parent part's sub-parts, or a leaf part's cards).
export default function ChapterView() {
  const { chapterSlug = '', partSlug } = useParams()
  const cameFrom = (useLocation().state as { from?: string } | null)?.from
  const { data, error, reload } = useAsync(async () => {
    const chapter = await getChapter(chapterSlug)
    const [parts, progress] = await Promise.all([getParts(chapter.id), getProgress()])
    return { chapter, parts, progress }
  }, [chapterSlug, partSlug])
  const userId = useUserId()
  const [confirming, setConfirming] = useState(false)
  const chapterId = data?.chapter.id
  useEffect(() => {
    if (chapterId) markChapterVisited(chapterId)
  }, [chapterId])

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
  const backTo = current ? (parent ? partPath(parent) : `/c/${chapter.slug}`) : cameFrom === '/completed' ? '/completed' : '/'
  const children = childrenOf(current?.id ?? null)

  if (current && children.length === 0) {
    return <Reels key={current.id} chapter={chapter} part={current} backTo={backTo} />
  }

  const node = progress.get(current?.id ?? chapter.id)
  const heading = current ?? chapter
  const variant = current ? current.sort_order + 1 : 0

  return (
    <Page>
      <section className="pt-safe relative overflow-hidden text-white" style={{ background: vivid(chapter.color, variant) }}>
        <div aria-hidden className="scrim absolute inset-0" />
        <div className="relative px-4 pt-3 pb-7">
          <div className="flex items-center justify-between">
            <IconLink to={backTo} label="Back" />
            <ProgressRing value={node?.progress ?? 0} size={42} />
          </div>
          <span className="mt-8 block text-[56px] leading-none" aria-hidden>{heading.emoji}</span>
          {current && <p className="mt-4 text-[15px] font-semibold text-white/80">{parent ? parent.title : chapter.title}</p>}
          <h1 className={`font-display text-[40px] leading-[1] font-extrabold tracking-[-0.035em] text-balance ${current ? 'mt-1' : 'mt-5'}`}>{heading.title}</h1>
          {heading.description && <p className="mt-3 text-[17px] leading-snug text-white">{heading.description}</p>}
          {node && node.leaf_total > 0 && <p className="mt-4 text-[14px] font-medium text-white/90">{node.leaf_done} of {node.leaf_total} finished</p>}
        </div>
      </section>
      <div className="flex flex-col gap-1 px-2 pt-3 pb-6">
        {children.map((p, i) => (
          <PartTile key={p.id} part={p} to={partPath(p)} color={chapter.color} variant={i} node={progress.get(p.id)} childCount={childrenOf(p.id).length} />
        ))}
      </div>
      {!current && (progress.get(chapter.id)?.progress ?? 0) > 0 && (
        <div className="px-4 pb-14">
          <button onClick={() => setConfirming(true)} className="w-full rounded-2xl bg-[var(--raised)] px-5 py-3.5 text-[16px] font-semibold text-rose-500 active:scale-[0.98]">
            Reset this chapter’s progress
          </button>
        </div>
      )}
      {confirming && (
        <Confirm
          title={`Reset ${chapter.title}?`}
          message={`All parts in ${chapter.title} go back to the start, and their quiz scores and missed questions are cleared. This can’t be undone.`}
          confirmLabel="Reset chapter"
          onConfirm={async () => {
            await resetChapterProgress(userId, chapter.id)
            forgetVisits(chapter.id)
            reload()
          }}
          onClose={() => setConfirming(false)}
        />
      )}
    </Page>
  )
}
