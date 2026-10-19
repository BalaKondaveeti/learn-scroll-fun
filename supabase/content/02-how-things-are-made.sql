-- Generated from content/02-how-things-are-made.json by "npm run content:sql". Safe to run more than once.
-- Paste into Supabase: SQL Editor > New query > Run.
begin;

insert into public.ls_chapters (slug, title, description, emoji, color, sort_order)
values ('how-things-are-made', 'How Things Are Made', 'From tree to tire, sand to window, pulp to notebook.', '🏭', '#10b981', 2)
on conflict (slug) do update set title = excluded.title, description = excluded.description,
  emoji = excluded.emoji, color = excluded.color, sort_order = excluded.sort_order;

-- part: rubber
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'rubber', 'Rubber', 'Natural rubber from trees, and the synthetic kinds made from oil.', '🌳', 0
from public.ls_chapters c where c.slug = 'how-things-are-made'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'how-things-are-made' and p.slug = 'rubber') and sort_order >= 0;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'how-things-are-made' and p.slug = 'rubber') and sort_order >= 0;

-- part: natural-rubber
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'how-things-are-made' and p.slug = 'rubber'), 'natural-rubber', 'Natural rubber', 'How latex from a tree becomes a tire.', '🌿', 0
from public.ls_chapters c where c.slug = 'how-things-are-made'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'how-things-are-made' and p.slug = 'natural-rubber'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'concept', 'It starts with a cut in the bark', 'Natural rubber comes from latex, a milky fluid in the bark of the rubber tree, Hevea brasiliensis.

A tapper shaves a thin, sloping groove into the bark. Latex oozes out, runs down the groove and drips into a cup tied to the trunk. The same tree can be tapped again every few days for years.', 'Latex isn''t the tree''s sap. It flows in separate channels in the bark called latex vessels. The cut is angled so the latex runs one way into the cup, and tappers take only a thin sliver each time so the bark can heal and be tapped again.'::text, null::text),
  (1, 'fact', 'Why tappers start before dawn', 'Tapping usually begins in the early morning. Latex flows best when the tree''s cells are full of water and under higher pressure, which happens in the cool hours before the day heats up.

Later in the day, the tree loses water to the air and latex flow slows.', null::text, null::text),
  (2, 'number', 'About 6 to 7 years', 'That is roughly how long a rubber tree grows before it is ready to tap. After that, a tree typically stays productive for about 25 years or more before yields fall and it is replanted.

Rubber is a long bet: a farmer plants today for income years from now.', null::text, null::text),
  (3, 'concept', 'From liquid to sheet', 'Fresh latex is mostly water. To turn it into solid rubber, processors add a mild acid, often formic acid. The rubber particles clump together, or coagulate, into a soft white mass.

That mass is pressed through rollers into thin sheets, then dried. Sheets dried in smokehouses are called ribbed smoked sheets, a common grade traded worldwide.', null::text, null::text),
  (4, 'concept', 'Vulcanization: the trick that made rubber useful', 'Raw rubber gets sticky in heat and brittle in cold. In 1839, Charles Goodyear found that heating rubber with sulfur changes it for good.

Sulfur forms bridges, called cross-links, between the long rubber molecules. The result stays elastic across a wide range of temperatures and springs back after stretching. Almost every rubber product today is vulcanized.', 'Chemically, natural rubber is mostly a polymer called cis-1,4-polyisoprene: long chains of the same small unit repeated thousands of times. Without cross-links, the chains slide past each other, which is why raw rubber flows and deforms. With them, the chains are tied into a loose net that can stretch and then pull back.'::text, null::text),
  (5, 'fact', 'Where it''s grown', 'Most of the world''s natural rubber comes from Southeast Asia. Thailand is the largest producer, followed by countries like Indonesia and Vietnam.

In India, most natural rubber is grown in Kerala, where the warm, wet climate suits the tree.', null::text, null::text),
  (6, 'concept', 'Why tires still need trees', 'Synthetic rubbers made from oil now outsell natural rubber, but they haven''t replaced it. Natural rubber resists tearing well and builds up less heat when it flexes over and over.

That is why heavy-duty tires, like those on trucks, use a high share of natural rubber. Most tires blend natural and synthetic rubber to get the best of both.', null::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'how-things-are-made' and p.slug = 'natural-rubber') and sort_order >= 7;
insert into public.ls_questions (part_id, sort_order, question, options, correct_index, explanation)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'how-things-are-made' and p.slug = 'natural-rubber'), v.sort_order, v.question, v.options, v.correct_index, v.explanation from (values
  (0, 'Which tree is the main source of natural rubber?', '["Hevea brasiliensis","Ficus elastica","Acacia senegal","Pinus sylvestris"]'::jsonb, 0, 'Hevea brasiliensis, the rubber tree, produces nearly all commercial natural rubber.'),
  (1, 'Why is rubber usually tapped in the early morning?', '["Workers prefer cooler hours","Latex flows best when the tree''s cells are full of water and under higher pressure","Sunlight spoils latex instantly","The bark is softer at night"]'::jsonb, 1, 'Cool early hours mean higher pressure in the latex vessels, so more latex flows.'),
  (2, 'What does adding a mild acid like formic acid do to latex?', '["Makes it more liquid","Colors it black","Makes the rubber particles clump together into a solid","Vulcanizes it"]'::jsonb, 2, 'Acid coagulates the latex, which can then be pressed into sheets and dried.'),
  (3, 'What does vulcanization with sulfur do?', '["Removes water from latex","Forms cross-links between rubber molecules so it stays elastic in heat and cold","Turns rubber into plastic","Makes rubber dissolve in water"]'::jsonb, 1, 'Cross-links tie the polymer chains together, so rubber springs back instead of flowing.'),
  (4, 'Which country produces the most natural rubber?', '["India","Brazil","Thailand","China"]'::jsonb, 2, 'Thailand leads world production, with Indonesia and Vietnam also major producers.')
) as v(sort_order, question, options, correct_index, explanation)
on conflict (part_id, sort_order) do update set question = excluded.question, options = excluded.options,
  correct_index = excluded.correct_index, explanation = excluded.explanation;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'how-things-are-made' and p.slug = 'natural-rubber') and sort_order >= 5;

-- part: synthetic-rubber
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'how-things-are-made' and p.slug = 'rubber'), 'synthetic-rubber', 'Synthetic rubber', 'Rubbers made from petrochemicals, like EPDM and SBR.', '🧪', 1
from public.ls_chapters c where c.slug = 'how-things-are-made'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'how-things-are-made' and p.slug = 'synthetic-rubber'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'concept', 'EPDM, the weatherproof one', 'EPDM stands for ethylene propylene diene monomer. It is a synthetic rubber known for standing up to sunlight, ozone, rain and heat.

That makes it a favorite for things that live outdoors: the rubber seals around car doors and windows, roofing membranes and garden hoses.', null::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'how-things-are-made' and p.slug = 'synthetic-rubber') and sort_order >= 1;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'how-things-are-made' and p.slug = 'synthetic-rubber') and sort_order >= 0;

-- part: glass
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'glass', 'Glass', 'How sand becomes a flat, clear window.', '🪟', 1
from public.ls_chapters c where c.slug = 'how-things-are-made'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'how-things-are-made' and p.slug = 'glass'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'concept', 'Sand, soda ash and limestone', 'Most everyday glass is soda-lime glass. It is made by melting silica sand with soda ash, which lowers the melting point, and limestone, which makes the glass stable and durable.

Recycled glass, called cullet, is often added too because it melts more easily and saves energy.', null::text, null::text),
  (1, 'fact', 'Floating glass on molten tin', 'Window glass is made by the float process, developed by Pilkington in the 1950s. Molten glass is poured onto a bath of molten tin. It spreads into a perfectly flat, even sheet and cools as it moves along.

Before this, flat glass often had to be ground and polished to get smooth.', null::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'how-things-are-made' and p.slug = 'glass') and sort_order >= 2;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'how-things-are-made' and p.slug = 'glass') and sort_order >= 0;

-- part: notebook
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'notebook', 'A school notebook', 'Pulp, paper, printed lines and binding.', '📓', 2
from public.ls_chapters c where c.slug = 'how-things-are-made'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'how-things-are-made' and p.slug = 'notebook'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'concept', 'From pulp to ruled pages', 'Paper starts as pulp: wood or recycled fibers broken down and mixed with water. The pulp is spread on a moving screen, drained, pressed and dried into huge rolls.

For a notebook, the paper is cut, ruled lines are printed on, and the pages are folded and bound, usually stitched, glued or held with a spiral wire.', null::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'how-things-are-made' and p.slug = 'notebook') and sort_order >= 1;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'how-things-are-made' and p.slug = 'notebook') and sort_order >= 0;

commit;
