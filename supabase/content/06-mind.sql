-- Generated from content/06-mind.json by "npm run content:sql". Safe to run more than once.
-- Paste into Supabase: SQL Editor > New query > Run.
begin;

insert into public.ls_chapters (slug, title, description, emoji, color, sort_order)
values ('mind', 'Mind', 'Old philosophy and simple practices for a steadier head.', '🧘', '#14b8a6', 6)
on conflict (slug) do update set title = excluded.title, description = excluded.description,
  emoji = excluded.emoji, color = excluded.color, sort_order = excluded.sort_order;

-- part: stoicism-basics
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'stoicism-basics', 'Stoicism basics', 'A 2,300-year-old way of handling what life throws at you.', '🏺', 0
from public.ls_chapters c where c.slug = 'mind'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mind' and p.slug = 'stoicism-basics'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'fact', 'Named after a porch', 'Stoicism was founded by Zeno of Citium, who taught in Athens around 300 BCE.

He taught at the Stoa Poikile, the ''painted porch'', a colonnade on the edge of the city''s agora. His followers became known as Stoics, the people of the porch.', null::text, null::text),
  (1, 'concept', 'What''s up to you', 'The Stoic teacher Epictetus opens his handbook, the Enchiridion, by splitting the world in two: things that are up to us and things that aren''t.

Up to you: your judgments, choices and actions. Not up to you: your body, your reputation, other people, the weather. Put your energy into the first list.', null::text, null::text),
  (2, 'concept', 'It''s the story, not the event', 'Another idea from the Enchiridion: people aren''t disturbed by things, but by the opinions they form about those things.

A rejection email is just words on a screen. ''I''ll never get anywhere'' is a judgment you add. The Stoics thought you can learn to notice that judgment and question it.', null::text, null::text),
  (3, 'fact', 'From slave to teacher', 'Epictetus was born into slavery in the first century CE. After gaining his freedom, he taught philosophy and later ran a school in Nicopolis, in Greece.

He never wrote anything himself. His student Arrian recorded his lessons, which became the Discourses and the Enchiridion.', null::text, null::text),
  (4, 'fact', 'An emperor''s private notebook', 'Marcus Aurelius, Roman emperor from 161 to 180 CE, kept a journal of reminders to himself. He wrote it in Greek, not Latin, and never meant it to be published.

Today we call it Meditations. It''s full of notes on staying patient, doing your duty and remembering that life is short.', 'Meditations wasn''t written as a book with chapters. It''s a set of twelve loose ''books'' of short entries, many written while Marcus was on military campaigns. He often repeats the same lessons, which tells you he struggled with them too.'::text, null::text),
  (5, 'concept', 'Rehearse the bad day', 'Seneca and other Stoics recommended imagining in advance what could go wrong: losing a job, a plan falling apart, a delay.

The point isn''t to be gloomy. Picturing setbacks ahead of time takes away some of their shock, and it makes you more grateful for what you have right now.', null::text, null::text),
  (6, 'what_would_you_do', 'Stuck in traffic, late for a big meeting', 'You''re stuck in traffic and you''ll be 15 minutes late to an important meeting. Your heart''s racing and you''re gripping the wheel.

What''s actually up to you here?', 'A Stoic might sort it like this. Not up to you: the traffic, how the others react. Up to you: sending a quick message (once you''re safely stopped) to say you''re running late, planning what you''ll say when you arrive, and how you treat yourself for the next 15 minutes. Once the message is sent, the rest is just waiting.'::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mind' and p.slug = 'stoicism-basics') and sort_order >= 7;
insert into public.ls_questions (part_id, sort_order, question, options, correct_index, explanation)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mind' and p.slug = 'stoicism-basics'), v.sort_order, v.question, v.options, v.correct_index, v.explanation from (values
  (0, 'Who founded Stoicism?', '["Socrates","Zeno of Citium","Marcus Aurelius","Epicurus"]'::jsonb, 1, 'Zeno of Citium, teaching in Athens around 300 BCE.'),
  (1, 'Where does the name ''Stoic'' come from?', '["A Greek word for calm","The Stoa Poikile, a painted porch in Athens","Zeno''s home town","A Roman legion"]'::jsonb, 1, 'Zeno taught at the Stoa Poikile, so his followers were ''people of the porch''.'),
  (2, 'According to Epictetus, which of these is up to you?', '["Your reputation","The weather","Your judgments and choices","Other people''s opinions"]'::jsonb, 2, 'Judgments, choices and actions are ours; most outside things aren''t.'),
  (3, 'What was Marcus Aurelius''s Meditations originally?', '["A speech to the Senate","A textbook for his school","A private journal of notes to himself","A letter to Seneca"]'::jsonb, 2, 'He wrote it in Greek for himself and never meant it to be published.'),
  (4, 'What was unusual about Epictetus''s early life?', '["He was a Roman emperor","He was born into slavery","He was a general","He grew up in Egypt as a priest"]'::jsonb, 1, 'He was born enslaved, later freed, and went on to teach in Nicopolis.')
) as v(sort_order, question, options, correct_index, explanation)
on conflict (part_id, sort_order) do update set question = excluded.question, options = excluded.options,
  correct_index = excluded.correct_index, explanation = excluded.explanation;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mind' and p.slug = 'stoicism-basics') and sort_order >= 5;

-- part: staying-calm
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'staying-calm', 'Staying calm', 'Small things you can do in the moment.', '🌊', 1
from public.ls_chapters c where c.slug = 'mind'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mind' and p.slug = 'staying-calm'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'concept', 'Breathe out longer than in', 'When you notice your heart racing, try slowing your breath down so each exhale is a little longer than the inhale. For example, in for four counts, out for six.

Slow breathing like this is a simple, widely taught way to help your body settle. Try a few rounds before you react.', null::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mind' and p.slug = 'staying-calm') and sort_order >= 1;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mind' and p.slug = 'staying-calm') and sort_order >= 0;

-- part: daily-motivation
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'daily-motivation', 'Daily motivation', 'Getting started when you don''t feel like it.', '☀️', 2
from public.ls_chapters c where c.slug = 'mind'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mind' and p.slug = 'daily-motivation'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'concept', 'Make it tiny', 'Motivation often shows up after you start, not before. So shrink the first step until it''s almost too small to skip: put on your shoes, open the document, write one sentence.

James Clear calls a version of this the two-minute rule in Atomic Habits: start with something that takes two minutes or less.', null::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mind' and p.slug = 'daily-motivation') and sort_order >= 1;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mind' and p.slug = 'daily-motivation') and sort_order >= 0;

-- part: questions-to-ask-yourself
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'questions-to-ask-yourself', 'Questions to ask yourself', 'Prompts for a quick check-in.', '❓', 3
from public.ls_chapters c where c.slug = 'mind'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mind' and p.slug = 'questions-to-ask-yourself'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'concept', 'Will this matter in a year?', 'When something feels huge, ask: will this matter in a year? In five?

If yes, it deserves real thought and maybe a plan. If not, it might deserve less of today than it''s taking.', null::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mind' and p.slug = 'questions-to-ask-yourself') and sort_order >= 1;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mind' and p.slug = 'questions-to-ask-yourself') and sort_order >= 0;

commit;
