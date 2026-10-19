import { sb } from './supabase'
import type { Card, Chapter, Part, PartProgress, ProgressNode, Question } from './types'

// Content rarely changes, so it's cached for the session. Progress is always fetched fresh.
const cache = new Map<string, Promise<unknown>>()
function cached<T>(key: string, load: () => Promise<T>): Promise<T> {
  if (!cache.has(key)) {
    const p = load()
    p.catch(() => cache.delete(key))
    cache.set(key, p)
  }
  return cache.get(key) as Promise<T>
}

function unwrap<T>({ data, error }: { data: T | null; error: { message: string } | null }): T {
  if (error) throw new Error(error.message)
  return data as T
}

export const getChapters = () =>
  cached('chapters', async () =>
    unwrap<Chapter[]>(await sb().from('ls_chapters').select('*').order('sort_order').order('title')),
  )

export async function getChapter(slug: string) {
  const chapter = (await getChapters()).find((c) => c.slug === slug)
  if (!chapter) throw new Error(`No chapter called "${slug}"`)
  return chapter
}

export const getParts = (chapterId: string) =>
  cached(`parts:${chapterId}`, async () =>
    unwrap<Part[]>(
      await sb().from('ls_parts').select('*').eq('chapter_id', chapterId).order('sort_order').order('title'),
    ),
  )

export const getCards = (partId: string) =>
  cached(`cards:${partId}`, async () =>
    unwrap<Card[]>(await sb().from('ls_cards').select('*').eq('part_id', partId).order('sort_order')),
  )

export const getQuestions = (partId: string) =>
  cached(`questions:${partId}`, async () =>
    unwrap<Question[]>(await sb().from('ls_questions').select('*').eq('part_id', partId).order('sort_order')),
  )

export async function getProgress(): Promise<Map<string, ProgressNode>> {
  const rows = unwrap<ProgressNode[]>(await sb().rpc('ls_progress'))
  return new Map(rows.map((r) => [r.node_id, { ...r, progress: Number(r.progress) }]))
}

export async function getPartProgress(partId: string): Promise<PartProgress | null> {
  return unwrap<PartProgress | null>(
    await sb().from('ls_part_progress').select('*').eq('part_id', partId).maybeSingle(),
  )
}

export async function saveCardPosition(
  userId: string,
  partId: string,
  lastCardIndex: number,
  extra: { cards_completed?: boolean; completed_at?: string } = {},
) {
  unwrap(
    await sb()
      .from('ls_part_progress')
      .upsert({ user_id: userId, part_id: partId, last_card_index: lastCardIndex, ...extra }, { onConflict: 'user_id,part_id' }),
  )
}

export async function saveQuizResult(
  userId: string,
  partId: string,
  score: number,
  total: number,
  prev: PartProgress | null,
): Promise<PartProgress> {
  const row = {
    user_id: userId,
    part_id: partId,
    last_score: score,
    best_score: Math.max(prev?.best_score ?? 0, score),
    total_questions: total,
    attempts: (prev?.attempts ?? 0) + 1,
    cards_completed: true,
    completed_at: prev?.completed_at ?? new Date().toISOString(),
  }
  return unwrap<PartProgress>(
    await sb().from('ls_part_progress').upsert(row, { onConflict: 'user_id,part_id' }).select().single(),
  )
}

export async function logAttempt(userId: string, questionId: string, correct: boolean) {
  unwrap(await sb().from('ls_question_attempts').insert({ user_id: userId, question_id: questionId, correct }))
}

export async function getReviewQuestions(limit = 10) {
  return unwrap<Question[]>(await sb().rpc('ls_review_questions', { p_limit: limit }))
}
