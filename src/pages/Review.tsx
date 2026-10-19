import { useNavigate } from 'react-router-dom'
import { BackButton, ErrorNotice, Page, Spinner } from '../components/Bits'
import { Quiz } from '../components/Quiz'
import { useUserId } from '../lib/authContext'
import { getReviewQuestions, logAttempt } from '../lib/data'
import { useAsync } from '../lib/useAsync'

// Questions whose latest answer was wrong. Answering one correctly here drops it from the list.
export default function Review() {
  const userId = useUserId()
  const navigate = useNavigate()
  const { data, error, reload } = useAsync(() => getReviewQuestions(10), [])
  const color = '#f59e0b'

  return (
    <Page>
      <header className="flex items-center gap-3 px-5 pt-4">
        <BackButton to="/" />
        <h1 className="font-display text-2xl font-bold">Review</h1>
      </header>
      {error && <ErrorNotice error={error} onRetry={reload} />}
      {!data && !error && <Spinner />}
      {data && data.length === 0 && (
        <p className="px-5 pt-10 text-lg text-[var(--muted)]">Nothing to review. Missed questions will show up here after a quiz.</p>
      )}
      {data && data.length > 0 && (
        <div className="px-5 pt-6 pb-10">
          <p className="mb-5 text-[var(--muted)]">A mix of questions you got wrong before.</p>
          <div className="rounded-[30px] border border-[var(--line)] bg-[var(--surface)] p-6">
            <Quiz
              questions={data}
              color={color}
              onAnswer={(q, correct) => void logAttempt(userId, q.id, correct).catch(() => {})}
              onFinish={() => {}}
              onExit={() => navigate('/')}
              exitLabel="Back home"
            />
          </div>
        </div>
      )}
    </Page>
  )
}
