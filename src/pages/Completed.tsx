import { ChapterRow } from '../components/ChapterRow'
import { ErrorNotice, IconLink, Page, Spinner } from '../components/Bits'
import { getChapterActivity, getChapters, getProgress } from '../lib/data'
import { useFromHere } from '../lib/nav'
import { byLastTouched, isChapterDone, mergeTouched } from '../lib/progress'
import { getLocalVisits } from '../lib/recent'
import { useAsync } from '../lib/useAsync'

// Chapters where every part is finished. They stay open for rereading or retaking quizzes.
export default function Completed() {
  const from = useFromHere()
  const { data, error, reload } = useAsync(() => Promise.all([getChapters(), getProgress(), getChapterActivity().catch(() => new Map<string, number>())]), [])
  const [chapters, progress, serverTouched] = data ?? [[], new Map(), new Map<string, number>()]
  // Most recently touched first, same as Home.
  const done = byLastTouched(chapters.filter((c) => isChapterDone(progress.get(c.id))), mergeTouched(serverTouched, getLocalVisits()))

  return (
    <Page>
      <header className="pt-safe sticky top-0 z-10 bg-[var(--bg)]/85 backdrop-blur-xl">
        <div className="flex items-center gap-3 px-4 py-3">
          <IconLink to="/" label="Back" variant="plain" />
          <h1 className="text-[22px] font-bold tracking-[-0.02em]">Completed</h1>
        </div>
      </header>
      {error && <ErrorNotice error={error} onRetry={reload} />}
      {!data && !error && <Spinner />}
      {data && done.length === 0 && (
        <p className="px-5 pt-10 text-center text-[17px] text-[var(--muted)]">Finish every part of a chapter and it moves here.</p>
      )}
      {data && done.length > 0 && (
        <div className="px-4 pb-12">
          <p className="px-1 pt-2 pb-3 text-[15px] text-[var(--muted)]">
            {done.length} of {chapters.length} chapters finished. Open one to reread it or retake a quiz.
          </p>
          <div className="flex flex-col gap-1">
            {done.map((c) => <ChapterRow key={c.id} chapter={c} node={progress.get(c.id)} from={from} done />)}
          </div>
        </div>
      )}
    </Page>
  )
}
