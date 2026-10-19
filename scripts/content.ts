// npm run content:validate [-- files...]   check content files, write nothing
// npm run content:sql      [-- files...]   write paste-ready SQL to supabase/content/
// With no files, every content/*.json is used.
import { mkdirSync, readFileSync, readdirSync, writeFileSync } from 'node:fs'
import { basename, join } from 'node:path'
import { contentFileSchema, type ContentFile, type PartInput } from './content-schema.ts'

const [command, ...args] = process.argv.slice(2)
const files = args.length
  ? args
  : readdirSync('content')
      .filter((f) => f.endsWith('.json'))
      .sort()
      .map((f) => join('content', f))

function load(file: string): ContentFile | null {
  let raw: unknown
  try {
    raw = JSON.parse(readFileSync(file, 'utf8'))
  } catch (e) {
    console.error(`✗ ${file}: not valid JSON (${(e as Error).message})`)
    return null
  }
  const result = contentFileSchema.safeParse(raw)
  if (!result.success) {
    console.error(`✗ ${file}`)
    for (const issue of result.error.issues) console.error(`   ${issue.path.join('.') || '(root)'}: ${issue.message}`)
    return null
  }
  return result.data
}

const q = (s: string | undefined | null) => (s == null ? 'null' : `'${s.replace(/'/g, "''")}'`)

function partRef(chapter: string, part: string) {
  return `(select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = ${q(chapter)} and p.slug = ${q(part)})`
}

function toSql(file: ContentFile, source: string) {
  const ch = file.chapter
  const out: string[] = [
    `-- Generated from ${source} by "npm run content:sql". Safe to run more than once.`,
    `-- Paste into Supabase: SQL Editor > New query > Run.`,
    'begin;',
    '',
    `insert into public.ls_chapters (slug, title, description, emoji, color, sort_order)`,
    `values (${q(ch.slug)}, ${q(ch.title)}, ${q(ch.description ?? '')}, ${q(ch.emoji)}, ${q(ch.color)}, ${ch.sort_order ?? 0})`,
    `on conflict (slug) do update set title = excluded.title, description = excluded.description,`,
    `  emoji = excluded.emoji, color = excluded.color, sort_order = excluded.sort_order;`,
  ]

  const walk = (parts: PartInput[], parent: string | null) => {
    parts.forEach((p, i) => {
      const parentSql = parent ? partRef(ch.slug, parent) : 'null'
      out.push(
        '',
        `-- part: ${p.slug}`,
        `insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)`,
        `select c.id, ${parentSql}, ${q(p.slug)}, ${q(p.title)}, ${q(p.description ?? '')}, ${q(p.emoji ?? '📄')}, ${i}`,
        `from public.ls_chapters c where c.slug = ${q(ch.slug)}`,
        `on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,`,
        `  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;`,
      )
      const ref = partRef(ch.slug, p.slug)
      const cards = p.cards ?? []
      if (cards.length) {
        out.push(
          `insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)`,
          `select ${ref}, v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values`,
          cards
            .map(
              (c, j) =>
                `  (${j}, ${q(c.kind)}, ${q(c.title)}, ${q(c.body)}, ${q(c.deep_dive)}::text, ${q(c.video_url)}::text)`,
            )
            .join(',\n'),
          `) as v(sort_order, kind, title, body, deep_dive, video_url)`,
          `on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,`,
          `  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;`,
        )
      }
      out.push(`delete from public.ls_cards where part_id = ${ref} and sort_order >= ${cards.length};`)
      const qs = p.questions ?? []
      if (qs.length) {
        out.push(
          `insert into public.ls_questions (part_id, sort_order, question, options, correct_index, explanation)`,
          `select ${ref}, v.sort_order, v.question, v.options, v.correct_index, v.explanation from (values`,
          qs
            .map(
              (x, j) =>
                `  (${j}, ${q(x.question)}, ${q(JSON.stringify(x.options))}::jsonb, ${x.correct_index}, ${q(x.explanation)})`,
            )
            .join(',\n'),
          `) as v(sort_order, question, options, correct_index, explanation)`,
          `on conflict (part_id, sort_order) do update set question = excluded.question, options = excluded.options,`,
          `  correct_index = excluded.correct_index, explanation = excluded.explanation;`,
        )
      }
      out.push(`delete from public.ls_questions where part_id = ${ref} and sort_order >= ${qs.length};`)
      if (p.parts) walk(p.parts, p.slug)
    })
  }
  walk(file.parts, null)
  out.push('', 'commit;', '')
  return out.join('\n')
}

function count(parts: PartInput[]): { parts: number; cards: number; questions: number } {
  return parts.reduce(
    (acc, p) => {
      const sub = count(p.parts ?? [])
      return {
        parts: acc.parts + 1 + sub.parts,
        cards: acc.cards + (p.cards?.length ?? 0) + sub.cards,
        questions: acc.questions + (p.questions?.length ?? 0) + sub.questions,
      }
    },
    { parts: 0, cards: 0, questions: 0 },
  )
}

if (command !== 'validate' && command !== 'sql') {
  console.error('Usage: content.ts validate|sql [files...]')
  process.exit(2)
}

let failed = false
const chunks: string[] = []
for (const file of files) {
  const data = load(file)
  if (!data) {
    failed = true
    continue
  }
  const n = count(data.parts)
  console.log(`✓ ${file}: ${data.chapter.slug}, ${n.parts} parts, ${n.cards} cards, ${n.questions} questions`)
  if (command === 'sql') {
    const sql = toSql(data, file)
    mkdirSync('supabase/content', { recursive: true })
    const target = join('supabase/content', basename(file).replace(/\.json$/, '.sql'))
    writeFileSync(target, sql)
    chunks.push(sql)
    console.log(`  wrote ${target}`)
  }
}
if (failed) process.exit(1)
if (command === 'sql' && args.length === 0) {
  writeFileSync('supabase/content/_all.sql', chunks.join('\n'))
  console.log('  wrote supabase/content/_all.sql (every chapter in one paste)')
}
