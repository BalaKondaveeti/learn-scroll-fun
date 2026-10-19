import { z } from 'zod'

// Source of truth for content files in /content. See CONTENT_GUIDE.md.

const slug = z
  .string()
  .regex(/^[a-z0-9]+(-[a-z0-9]+)*$/, 'use lowercase words joined by hyphens, e.g. "natural-rubber"')
const color = z.string().regex(/^#[0-9a-fA-F]{6}$/, 'use a 6-digit hex color like "#10b981"')

const wordCount = (s: string) => s.trim().split(/\s+/).filter(Boolean).length

export const cardKinds = ['concept', 'case_study', 'number', 'what_would_you_do', 'fact'] as const

export const cardSchema = z.strictObject({
  kind: z.enum(cardKinds),
  title: z.string().min(2).max(80),
  body: z.string().min(10).refine((s) => wordCount(s) <= 90, 'body must be about 80 words or fewer'),
  deep_dive: z
    .string()
    .refine((s) => wordCount(s) <= 220, 'deep_dive must be 220 words or fewer')
    .optional(),
  video_url: z.url({ protocol: /^https$/ }).optional(),
})

export const questionSchema = z
  .strictObject({
    question: z.string().min(5).max(220),
    options: z.array(z.string().min(1).max(120)).length(4, 'each question needs exactly 4 options'),
    correct_index: z.number().int().min(0).max(3),
    explanation: z.string().min(5).max(400),
  })
  .refine((q) => new Set(q.options.map((o) => o.toLowerCase())).size === 4, 'options must be distinct')

export type PartInput = {
  slug: string
  title: string
  description?: string
  emoji?: string
  cards?: z.infer<typeof cardSchema>[]
  questions?: z.infer<typeof questionSchema>[]
  parts?: PartInput[]
}

export const partSchema: z.ZodType<PartInput> = z.lazy(() =>
  z
    .strictObject({
      slug,
      title: z.string().min(2).max(60),
      description: z.string().max(160).optional(),
      emoji: z.string().min(1).max(8).optional(),
      cards: z.array(cardSchema).max(15).optional(),
      questions: z.array(questionSchema).max(10).optional(),
      parts: z.array(partSchema).optional(),
    })
    .superRefine((p, ctx) => {
      const hasChildren = (p.parts?.length ?? 0) > 0
      const hasCards = (p.cards?.length ?? 0) > 0
      if (hasChildren && (hasCards || (p.questions?.length ?? 0) > 0)) {
        ctx.addIssue({ code: 'custom', message: 'a part has either sub-parts or cards/questions, not both' })
      }
      if (!hasChildren && !hasCards) {
        ctx.addIssue({ code: 'custom', message: 'a leaf part needs at least one card' })
      }
      const n = p.questions?.length ?? 0
      if (n > 0 && (n < 5 || n > 8)) {
        ctx.addIssue({ code: 'custom', message: 'a quiz has 5 to 8 questions (or none for a stub)' })
      }
    }),
)

export const contentFileSchema = z
  .strictObject({
    chapter: z.strictObject({
      slug,
      title: z.string().min(2).max(40),
      description: z.string().max(200).optional(),
      emoji: z.string().min(1).max(8),
      color,
      sort_order: z.number().int().optional(),
    }),
    parts: z.array(partSchema).min(1),
  })
  .superRefine((file, ctx) => {
    const seen = new Set<string>()
    const walk = (parts: PartInput[]) => {
      for (const p of parts) {
        if (seen.has(p.slug)) ctx.addIssue({ code: 'custom', message: `part slug "${p.slug}" is used twice in this chapter` })
        seen.add(p.slug)
        if (p.parts) walk(p.parts)
      }
    }
    walk(file.parts)
  })

export type ContentFile = z.infer<typeof contentFileSchema>
