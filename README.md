# Scroll to Learn

Scroll to Learn is a reels-style learning app (repo: learn-scroll-fun). Pick a chapter, open a part, swipe through short cards (one idea each), then take a quick quiz. Progress and scores are saved to your Supabase account.

Live: https://balakondaveeti.github.io/learn-scroll-fun/

Built with Vite, React, TypeScript and Tailwind CSS, with Supabase for auth and data, deployed to GitHub Pages.

## Setup

```sh
npm install
cp .env.example .env.local   # then fill in the two VITE_ values
npm run dev                  # http://localhost:5173/learn-scroll-fun/
```

`.env.local` needs:

```
VITE_SUPABASE_URL=https://<project>.supabase.co
VITE_SUPABASE_PUBLISHABLE_KEY=sb_publishable_...
```

Both are public by design; the data is protected by Row Level Security. `.env` and `.env.*` are gitignored.

### Database

Run `supabase/migrations/001_init.sql` once in the Supabase dashboard (**SQL Editor**, **New query**, paste, **Run**). It only creates `ls_`-prefixed tables and functions and is safe to run again. It sets up:

- Content tables: `ls_chapters`, `ls_parts` (nestable through `parent_part_id`), `ls_cards`, `ls_questions`. Signed-in users can read them; nobody can write to them from the app.
- Per-user tables: `ls_part_progress` and `ls_question_attempts`. Each user can only see and change their own rows.
- `ls_progress()`: one call that returns progress for every part, parent part and chapter.
- `ls_review_questions(p_limit)`: questions whose most recent answer was wrong, for the Review screen.

### Auth

Sign in with email and password, or with a magic link. For magic links and sign-up confirmation emails to come back to this app, add `https://balakondaveeti.github.io/learn-scroll-fun/**` under **Authentication**, **URL Configuration**, **Redirect URLs**. Until then, use email and password.

## Settings

The gear on Home opens Settings: light or dark theme, swipe up or sideways for cards, and progress resets (one chapter, or everything). A chapter can also be reset from the bottom of its own page. Resetting deletes the user's own rows in `ls_part_progress` and `ls_question_attempts`; content is never touched.

## Deploy

Every push to `main` runs `.github/workflows/deploy.yml`: lint, validate content, check the generated SQL is up to date, build, and publish to GitHub Pages. The Supabase URL and publishable key come from the repository variables `VITE_SUPABASE_URL` and `VITE_SUPABASE_PUBLISHABLE_KEY` (**Settings**, **Secrets and variables**, **Actions**, **Variables**).

## Adding content

Content lives as JSON in `content/`, one file per chapter. See [CONTENT_GUIDE.md](CONTENT_GUIDE.md) for the format, card kinds, length limits, tone rules and a complete example.

```sh
npm run content:validate   # check every file in content/
npm run content:sql        # regenerate supabase/content/*.sql
```

Then paste the generated `supabase/content/<file>.sql` (or `_all.sql` for everything) into the Supabase SQL Editor and run it. Re-running is safe: rows are matched by slug and position, so nothing is duplicated.

### Adding content from any AI chat

[CONTENT_PROMPT.md](CONTENT_PROMPT.md) is a starter message for a separate AI chat. Paste the whole file as the first message, then send it topics ("New chapter: Cooking", "Flesh out cars / exhaust", "New part in Mind: Habits"). It replies with one SQL block to paste into the SQL Editor, plus a short query to check what was added. Its SQL is safe to re-run, puts new parts at the end of their list, and stops with an error if a chapter or part slug is wrong.

Content added this way lives only in the database, not in `content/`. After you've used the chat on a chapter, don't re-run that chapter's old file from `supabase/content/` (or `_all.sql`), because it would put the original stub versions back.

## Scripts

| Command | What it does |
| --- | --- |
| `npm run dev` | Local dev server |
| `npm run build` | Type-check and build to `dist/` |
| `npm run lint` | oxlint |
| `npm run content:validate` | Validate content JSON |
| `npm run content:sql` | Generate paste-ready SQL from content JSON |
| `npm run check:secrets` | Scan unpushed commits for GitHub tokens |

## Project layout

```
content/                 chapter JSON (source of truth for content)
scripts/                 content schema, SQL generator, secret scan
supabase/migrations/     schema
supabase/content/        generated content SQL
src/lib/                 Supabase client, auth, data access
src/components/          cards, quiz, tiles, progress ring
src/pages/               Login, Home, ChapterView, Reels, Review, Settings
```
