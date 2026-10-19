-- learn-scroll-fun schema. Safe to run more than once.
-- Creates only ls_-prefixed objects; touches nothing else in the project.

-- ---------------------------------------------------------------------------
-- Content tables (written only by the import script via the service role key)
-- ---------------------------------------------------------------------------

create table if not exists public.ls_chapters (
  id          uuid primary key default gen_random_uuid(),
  slug        text not null unique check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
  title       text not null,
  description text not null default '',
  emoji       text not null default '📘',
  color       text not null default '#7c6cff' check (color ~ '^#[0-9a-fA-F]{6}$'),
  sort_order  int  not null default 0,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create table if not exists public.ls_parts (
  id             uuid primary key default gen_random_uuid(),
  chapter_id     uuid not null references public.ls_chapters(id) on delete cascade,
  parent_part_id uuid references public.ls_parts(id) on delete cascade,
  slug           text not null check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
  title          text not null,
  description    text not null default '',
  emoji          text not null default '📄',
  sort_order     int  not null default 0,
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now(),
  unique (chapter_id, slug),
  check (parent_part_id is null or parent_part_id <> id)
);

create table if not exists public.ls_cards (
  id         uuid primary key default gen_random_uuid(),
  part_id    uuid not null references public.ls_parts(id) on delete cascade,
  sort_order int  not null,
  kind       text not null check (kind in ('concept', 'case_study', 'number', 'what_would_you_do', 'fact')),
  title      text not null,
  body       text not null,
  deep_dive  text,
  video_url  text check (video_url is null or video_url ~ '^https://'),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (part_id, sort_order)
);

create table if not exists public.ls_questions (
  id            uuid primary key default gen_random_uuid(),
  part_id       uuid not null references public.ls_parts(id) on delete cascade,
  sort_order    int  not null,
  question      text not null,
  options       jsonb not null check (jsonb_typeof(options) = 'array' and jsonb_array_length(options) between 2 and 6),
  correct_index int  not null,
  explanation   text not null default '',
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  unique (part_id, sort_order),
  check (correct_index >= 0 and correct_index < jsonb_array_length(options))
);

-- ---------------------------------------------------------------------------
-- Per-user tables
-- ---------------------------------------------------------------------------

create table if not exists public.ls_part_progress (
  user_id         uuid not null default auth.uid() references auth.users(id) on delete cascade,
  part_id         uuid not null references public.ls_parts(id) on delete cascade,
  last_card_index int  not null default 0 check (last_card_index >= 0),
  cards_completed boolean not null default false,
  best_score      int check (best_score >= 0),
  last_score      int check (last_score >= 0),
  total_questions int check (total_questions >= 0),
  attempts        int not null default 0 check (attempts >= 0),
  completed_at    timestamptz,
  updated_at      timestamptz not null default now(),
  primary key (user_id, part_id)
);

create table if not exists public.ls_question_attempts (
  id           bigint generated always as identity primary key,
  user_id      uuid not null default auth.uid() references auth.users(id) on delete cascade,
  question_id  uuid not null references public.ls_questions(id) on delete cascade,
  correct      boolean not null,
  attempted_at timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
-- Indexes on foreign keys (part_id on cards/questions is covered by the unique keys)
-- ---------------------------------------------------------------------------

create index if not exists ls_parts_chapter_id_idx      on public.ls_parts (chapter_id);
create index if not exists ls_parts_parent_part_id_idx  on public.ls_parts (parent_part_id);
create index if not exists ls_part_progress_part_id_idx on public.ls_part_progress (part_id);
create index if not exists ls_question_attempts_user_question_idx
  on public.ls_question_attempts (user_id, question_id, attempted_at desc);
create index if not exists ls_question_attempts_question_id_idx on public.ls_question_attempts (question_id);

-- ---------------------------------------------------------------------------
-- updated_at maintenance
-- ---------------------------------------------------------------------------

create or replace function public.ls_touch_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

do $$
declare t text;
begin
  foreach t in array array['ls_chapters', 'ls_parts', 'ls_cards', 'ls_questions', 'ls_part_progress'] loop
    execute format('drop trigger if exists %I on public.%I', t || '_touch', t);
    execute format(
      'create trigger %I before update on public.%I for each row execute function public.ls_touch_updated_at()',
      t || '_touch', t);
  end loop;
end;
$$;

-- ---------------------------------------------------------------------------
-- Row Level Security
-- ---------------------------------------------------------------------------

alter table public.ls_chapters          enable row level security;
alter table public.ls_parts             enable row level security;
alter table public.ls_cards             enable row level security;
alter table public.ls_questions         enable row level security;
alter table public.ls_part_progress     enable row level security;
alter table public.ls_question_attempts enable row level security;

-- Content: any signed-in user can read; nobody can write from the client.
drop policy if exists ls_chapters_read  on public.ls_chapters;
drop policy if exists ls_parts_read     on public.ls_parts;
drop policy if exists ls_cards_read     on public.ls_cards;
drop policy if exists ls_questions_read on public.ls_questions;

create policy ls_chapters_read  on public.ls_chapters  for select to authenticated using (true);
create policy ls_parts_read     on public.ls_parts     for select to authenticated using (true);
create policy ls_cards_read     on public.ls_cards     for select to authenticated using (true);
create policy ls_questions_read on public.ls_questions for select to authenticated using (true);

revoke insert, update, delete, truncate on public.ls_chapters, public.ls_parts, public.ls_cards, public.ls_questions
  from anon, authenticated;
revoke all on public.ls_chapters, public.ls_parts, public.ls_cards, public.ls_questions,
  public.ls_part_progress, public.ls_question_attempts from anon;

-- Progress and attempts: each user sees and edits only their own rows.
drop policy if exists ls_part_progress_select on public.ls_part_progress;
drop policy if exists ls_part_progress_insert on public.ls_part_progress;
drop policy if exists ls_part_progress_update on public.ls_part_progress;
drop policy if exists ls_part_progress_delete on public.ls_part_progress;

create policy ls_part_progress_select on public.ls_part_progress for select to authenticated
  using ((select auth.uid()) = user_id);
create policy ls_part_progress_insert on public.ls_part_progress for insert to authenticated
  with check ((select auth.uid()) = user_id);
create policy ls_part_progress_update on public.ls_part_progress for update to authenticated
  using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy ls_part_progress_delete on public.ls_part_progress for delete to authenticated
  using ((select auth.uid()) = user_id);

drop policy if exists ls_question_attempts_select on public.ls_question_attempts;
drop policy if exists ls_question_attempts_insert on public.ls_question_attempts;
drop policy if exists ls_question_attempts_update on public.ls_question_attempts;
drop policy if exists ls_question_attempts_delete on public.ls_question_attempts;

create policy ls_question_attempts_select on public.ls_question_attempts for select to authenticated
  using ((select auth.uid()) = user_id);
create policy ls_question_attempts_insert on public.ls_question_attempts for insert to authenticated
  with check ((select auth.uid()) = user_id);
create policy ls_question_attempts_update on public.ls_question_attempts for update to authenticated
  using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy ls_question_attempts_delete on public.ls_question_attempts for delete to authenticated
  using ((select auth.uid()) = user_id);

-- ---------------------------------------------------------------------------
-- ls_progress(): one call returns progress for every part (leaf and parent)
-- and every chapter for the signed-in user.
--   progress is 0..1: a leaf counts 1 when its quiz is done (or, with no quiz,
--   when its cards are finished), 0.5 when cards are finished, and a share of
--   0.5 while scrolling. Parents and chapters average their leaf parts.
-- ---------------------------------------------------------------------------

drop function if exists public.ls_progress();
create function public.ls_progress()
returns table (
  node_type       text,
  node_id         uuid,
  chapter_id      uuid,
  leaf_total      int,
  leaf_done       int,
  progress        numeric,
  best_score      int,
  last_score      int,
  total_questions int,
  attempts        int,
  last_card_index int,
  cards_completed boolean,
  completed       boolean
)
language sql
stable
security invoker
set search_path = ''
as $$
  with recursive
  leaves as (
    select p.id, p.chapter_id
    from public.ls_parts p
    where not exists (select 1 from public.ls_parts c where c.parent_part_id = p.id)
  ),
  card_counts as (
    select part_id, count(*)::int as n from public.ls_cards group by part_id
  ),
  leaf_state as (
    select
      l.id as part_id,
      l.chapter_id,
      pp.best_score,
      pp.last_score,
      pp.total_questions,
      coalesce(pp.attempts, 0) as attempts,
      coalesce(pp.last_card_index, 0) as last_card_index,
      coalesce(pp.cards_completed, false) as cards_completed,
      (pp.completed_at is not null) as completed,
      case
        when pp.completed_at is not null then 1.0
        when pp.cards_completed then 0.5
        when pp.user_id is not null then
          least(0.5, (pp.last_card_index + 1)::numeric / greatest(coalesce(cc.n, 1), 1) * 0.5)
        else 0.0
      end as progress
    from leaves l
    left join public.ls_part_progress pp on pp.part_id = l.id and pp.user_id = (select auth.uid())
    left join card_counts cc on cc.part_id = l.id
  ),
  ancestry (ancestor_id, leaf_id, depth) as (
    select id, id, 0 from leaves
    union all
    select p.parent_part_id, a.leaf_id, a.depth + 1
    from ancestry a
    join public.ls_parts p on p.id = a.ancestor_id
    where p.parent_part_id is not null and a.depth < 32
  )
  select 'part', ls.part_id, ls.chapter_id, 1, ls.completed::int, round(ls.progress, 4),
         ls.best_score, ls.last_score, ls.total_questions, ls.attempts,
         ls.last_card_index, ls.cards_completed, ls.completed
  from leaf_state ls
  union all
  select 'part', a.ancestor_id, p.chapter_id, count(*)::int,
         (count(*) filter (where ls.completed))::int, round(avg(ls.progress), 4),
         null, null, null, null, null, null, bool_and(ls.completed)
  from ancestry a
  join public.ls_parts p on p.id = a.ancestor_id
  join leaf_state ls on ls.part_id = a.leaf_id
  where a.ancestor_id <> a.leaf_id
  group by a.ancestor_id, p.chapter_id
  union all
  select 'chapter', c.id, c.id, count(ls.part_id)::int,
         (count(ls.part_id) filter (where ls.completed))::int, coalesce(round(avg(ls.progress), 4), 0),
         null, null, null, null, null, null, coalesce(bool_and(ls.completed), false)
  from public.ls_chapters c
  left join leaf_state ls on ls.chapter_id = c.id
  group by c.id;
$$;

-- ---------------------------------------------------------------------------
-- ls_review_questions(): questions whose most recent answer by this user was wrong.
-- ---------------------------------------------------------------------------

drop function if exists public.ls_review_questions(int);
create function public.ls_review_questions(p_limit int default 10)
returns setof public.ls_questions
language sql
stable
security invoker
set search_path = ''
as $$
  select q.*
  from public.ls_questions q
  join (
    select distinct on (question_id) question_id, correct
    from public.ls_question_attempts
    where user_id = (select auth.uid())
    order by question_id, attempted_at desc
  ) last_try on last_try.question_id = q.id and not last_try.correct
  order by random()
  limit greatest(least(p_limit, 50), 1);
$$;

revoke execute on function public.ls_progress() from public, anon;
revoke execute on function public.ls_review_questions(int) from public, anon;
grant execute on function public.ls_progress() to authenticated;
grant execute on function public.ls_review_questions(int) to authenticated;
