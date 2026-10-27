import { ErrorNotice, IconLink, Spinner } from '../components/Bits'
import { Quiz } from '../components/Quiz'
import { useUserId } from '../lib/authContext'
import { deep } from '../lib/color'
import { getReviewQuestions, logAttempt } from '../lib/data'
import { useGoBack } from '../lib/nav'
import { useAsync } from '../lib/useAsync'

// Questions whose latest answer was wrong. Answering one correctly here drops it from the list.
export default function Review() {
  const userId = useUserId()
  const goBack = useGoBack('/')
  const { data, error, reload } = useAsync(() => getReviewQuestions(10), [])

  return (
    <div className="fixed inset-0 overflow-y-auto text-white" style={{ background: deep('#f43f5e') }}>
      <div className="pt-safe pb-safe mx-auto flex min-h-full max-w-xl flex-col px-5">
        <header className="flex items-center gap-3 pt-3">
          <IconLink to="/" label="Back" />
          <div className="leading-tight">
            <p className="text-[17px] font-semibold">Review</p>
            <p className="text-[13px] text-white/75">Questions you missed before</p>
          </div>
        </header>
        <div className="flex flex-1 items-center py-8">
          {error && <ErrorNotice error={error} onRetry={reload} />}
          {!data && !error && <div className="w-full"><Spinner light /></div>}
          {data && data.length === 0 && <p className="w-full text-center text-[19px] text-white/85">Nothing to review. Missed questions show up here after a quiz.</p>}
          {data && data.length > 0 && (
            <Quiz questions={data} onAnswer={(q, correct) => void logAttempt(userId, q.id, correct).catch(() => {})} onFinish={() => {}} onExit={goBack} exitLabel="Back home" />
          )}
        </div>
      </div>
    </div>
  )
}
