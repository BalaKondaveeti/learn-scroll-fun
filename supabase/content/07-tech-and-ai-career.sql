-- Generated from content/07-tech-and-ai-career.json by "npm run content:sql". Safe to run more than once.
-- Paste into Supabase: SQL Editor > New query > Run.
begin;

insert into public.ls_chapters (slug, title, description, emoji, color, sort_order)
values ('tech-and-ai-career', 'Tech and AI Career', 'How LLMs work, system design basics and getting ready for big-tech interviews.', '💻', '#ec4899', 7)
on conflict (slug) do update set title = excluded.title, description = excluded.description,
  emoji = excluded.emoji, color = excluded.color, sort_order = excluded.sort_order;

-- part: how-llms-work
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'how-llms-work', 'How LLMs work', 'Tokens, attention and next-word prediction, without the math.', '🤖', 0
from public.ls_chapters c where c.slug = 'tech-and-ai-career'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'tech-and-ai-career' and p.slug = 'how-llms-work'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'concept', 'Text becomes tokens', 'A large language model doesn''t read letters or whole words. It reads tokens: common chunks of text like ''learn'', ''ing'' or '' the''.

In English, a token averages about three-quarters of a word. Model limits and API pricing are usually counted in tokens, not words.', null::text, null::text),
  (1, 'concept', 'Tokens become vectors', 'Each token is turned into an embedding: a long list of numbers that places it in a high-dimensional space.

Tokens used in similar ways end up near each other. That''s how the model gets a sense that ''car'' and ''truck'' are related without being told.', null::text, null::text),
  (2, 'concept', 'It predicts the next token', 'At its core, an LLM does one thing: given the text so far, it outputs a probability for every possible next token.

One token is picked, added to the text, and the process repeats. Whole essays and programs come from running this loop over and over. This is called autoregressive generation.', null::text, null::text),
  (3, 'concept', 'Attention: looking back at the context', 'Modern LLMs are built on the Transformer, introduced in the 2017 paper ''Attention Is All You Need'' by researchers at Google.

Its key idea, attention, lets every token weigh how relevant every earlier token is. In ''the bank by the river'', attention helps ''bank'' connect to ''river'' rather than to money.', 'Attention runs in many layers and in parallel ''heads'', each free to learn different kinds of relationships: grammar, references back to earlier names, code structure and so on. Because attention compares tokens with each other directly, Transformers train efficiently on modern hardware, which is a big reason models could scale up so far.'::text, null::text),
  (4, 'concept', 'Pretraining, then fine-tuning', 'First, a model is pretrained on a huge amount of text, learning simply to predict the next token. That teaches it language, facts and patterns.

Then it is fine-tuned to be a helpful assistant, often with human feedback on its answers, a method known as reinforcement learning from human feedback (RLHF).', null::text, null::text),
  (5, 'number', 'The context window', 'A model''s context window is the maximum number of tokens it can consider at once: your prompt, any documents, the conversation so far and its own reply.

Anything outside the window simply isn''t seen. That''s why long chats and big documents sometimes need summarizing or retrieval.', null::text, null::text),
  (6, 'concept', 'Temperature', 'When picking the next token, the model doesn''t have to choose the most likely one. Temperature controls how adventurous it is.

Low temperature means safer, more predictable picks, good for code and facts. Higher temperature means more varied, surprising output, good for brainstorming.', null::text, null::text),
  (7, 'fact', 'Why models make things up', 'An LLM is trained to produce likely-sounding text, not to check facts. So it can write something fluent and confident that''s false. This is often called hallucination.

One common fix is retrieval-augmented generation (RAG): look up relevant documents first and give them to the model, so it can answer from real sources.', null::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'tech-and-ai-career' and p.slug = 'how-llms-work') and sort_order >= 8;
insert into public.ls_questions (part_id, sort_order, question, options, correct_index, explanation)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'tech-and-ai-career' and p.slug = 'how-llms-work'), v.sort_order, v.question, v.options, v.correct_index, v.explanation from (values
  (0, 'What is a token?', '["A single letter","A chunk of text, often part of a word, that the model reads","An API key","A full sentence"]'::jsonb, 1, 'In English a token averages about three-quarters of a word.'),
  (1, 'At each step, what does an LLM predict?', '["The whole answer at once","The topic of the conversation","A probability for every possible next token","Which documents to search"]'::jsonb, 2, 'One token is chosen, appended, and the loop repeats.'),
  (2, 'Which 2017 paper introduced the Transformer?', '["ImageNet Classification with Deep CNNs","Attention Is All You Need","Playing Atari with Deep Reinforcement Learning","Generative Adversarial Nets"]'::jsonb, 1, 'Published by researchers at Google in 2017.'),
  (3, 'What does lowering the temperature usually do?', '["Makes output more varied and creative","Makes output more predictable","Makes the model run faster","Increases the context window"]'::jsonb, 1, 'Lower temperature favors the most likely tokens.'),
  (4, 'What is retrieval-augmented generation (RAG) for?', '["Training the model from scratch","Compressing the model","Giving the model relevant documents so it answers from real sources","Translating tokens into vectors"]'::jsonb, 2, 'Retrieving sources first reduces made-up answers.')
) as v(sort_order, question, options, correct_index, explanation)
on conflict (part_id, sort_order) do update set question = excluded.question, options = excluded.options,
  correct_index = excluded.correct_index, explanation = excluded.explanation;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'tech-and-ai-career' and p.slug = 'how-llms-work') and sort_order >= 5;

-- part: system-design-basics
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'system-design-basics', 'System design basics', 'Caches, load balancers and the building blocks of big systems.', '🏗️', 1
from public.ls_chapters c where c.slug = 'tech-and-ai-career'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'tech-and-ai-career' and p.slug = 'system-design-basics'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'concept', 'Caching', 'A cache keeps a copy of data somewhere faster, like memory, so repeat requests don''t go back to the slow source every time.

The hard parts are deciding what to keep, when to throw it out, and what happens when the original data changes and the cached copy goes stale.', null::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'tech-and-ai-career' and p.slug = 'system-design-basics') and sort_order >= 1;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'tech-and-ai-career' and p.slug = 'system-design-basics') and sort_order >= 0;

-- part: interview-prep
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'interview-prep', 'Big-tech interview prep', 'How to get ready for coding, design and behavioral rounds.', '🎯', 2
from public.ls_chapters c where c.slug = 'tech-and-ai-career'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'tech-and-ai-career' and p.slug = 'interview-prep'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'concept', 'STAR for behavioral questions', 'For ''tell me about a time when…'' questions, many interviewers expect the STAR structure: Situation, Task, Action, Result.

Spend most of your time on Action: what you personally did. End with a concrete Result, a number if you have one.', null::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'tech-and-ai-career' and p.slug = 'interview-prep') and sort_order >= 1;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'tech-and-ai-career' and p.slug = 'interview-prep') and sort_order >= 0;

commit;
