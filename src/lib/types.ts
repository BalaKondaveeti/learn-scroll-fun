export type Chapter = {
  id: string
  slug: string
  title: string
  description: string
  emoji: string
  color: string
  sort_order: number
}

export type Part = {
  id: string
  chapter_id: string
  parent_part_id: string | null
  slug: string
  title: string
  description: string
  emoji: string
  sort_order: number
}

export type CardKind = 'concept' | 'case_study' | 'number' | 'what_would_you_do' | 'fact'

export type Card = {
  id: string
  part_id: string
  sort_order: number
  kind: CardKind
  title: string
  body: string
  deep_dive: string | null
  video_url: string | null
}

export type Question = {
  id: string
  part_id: string
  sort_order: number
  question: string
  options: string[]
  correct_index: number
  explanation: string
}

export type PartProgress = {
  user_id: string
  part_id: string
  last_card_index: number
  cards_completed: boolean
  best_score: number | null
  last_score: number | null
  total_questions: number | null
  attempts: number
  completed_at: string | null
}

// One row of the ls_progress() RPC: a leaf part, a parent part, or a chapter.
export type ProgressNode = {
  node_type: 'part' | 'chapter'
  node_id: string
  chapter_id: string
  leaf_total: number
  leaf_done: number
  progress: number
  best_score: number | null
  last_score: number | null
  total_questions: number | null
  attempts: number | null
  last_card_index: number | null
  cards_completed: boolean | null
  completed: boolean | null
}
