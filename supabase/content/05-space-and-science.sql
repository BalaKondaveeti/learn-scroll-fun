-- Generated from content/05-space-and-science.json by "npm run content:sql". Safe to run more than once.
-- Paste into Supabase: SQL Editor > New query > Run.
begin;

insert into public.ls_chapters (slug, title, description, emoji, color, sort_order)
values ('space-and-science', 'Space and Science', 'Our corner of the universe, and the physics that runs it.', '🔭', '#8b5cf6', 5)
on conflict (slug) do update set title = excluded.title, description = excluded.description,
  emoji = excluded.emoji, color = excluded.color, sort_order = excluded.sort_order;

-- part: solar-system
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'solar-system', 'The Solar System', 'Surprising facts about our Sun and its planets.', '🪐', 0
from public.ls_chapters c where c.slug = 'space-and-science'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'space-and-science' and p.slug = 'solar-system'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'number', 'Sunlight is about 8 minutes old', 'Light from the Sun takes about 8 minutes and 20 seconds to reach Earth.

So when you look at the Sun (please don''t, directly), you''re seeing it as it was a little over eight minutes ago.', null::text, null::text),
  (1, 'number', '1 AU ≈ 150 million km', 'Astronomers measure distances in the Solar System with the astronomical unit, or AU: roughly the average distance from Earth to the Sun, about 150 million kilometers.

Jupiter is about 5 AU from the Sun. Neptune is about 30 AU.', null::text, null::text),
  (2, 'fact', 'The hottest planet isn''t the closest', 'Mercury is closest to the Sun, but Venus is the hottest planet, with surface temperatures around 465°C.

Venus has a thick atmosphere made mostly of carbon dioxide. It traps heat in a runaway greenhouse effect, hot enough to melt lead.', null::text, null::text),
  (3, 'concept', 'Seasons come from the tilt', 'Earth''s axis is tilted about 23.4 degrees. As Earth orbits, first one hemisphere and then the other leans toward the Sun, getting more direct sunlight and longer days.

Seasons aren''t caused by distance. Earth is actually closest to the Sun in early January, during northern winter.', null::text, null::text),
  (4, 'fact', 'Jupiter outweighs everyone', 'Jupiter is more than twice as massive as all the other planets combined.

It is mostly hydrogen and helium, and its Great Red Spot is a storm bigger than Earth.', null::text, null::text),
  (5, 'fact', 'A day longer than a year', 'Venus spins very slowly, and backwards compared with most planets. One full rotation takes about 243 Earth days, while one trip around the Sun takes about 225.

So on Venus, a day (one rotation) is longer than a year.', null::text, null::text),
  (6, 'concept', 'Why Pluto was reclassified', 'In 2006, the International Astronomical Union defined a planet as a body that orbits the Sun, is round from its own gravity, and has cleared its orbit of other material.

Pluto meets the first two but shares its region with many icy objects in the Kuiper Belt. So it became a dwarf planet.', null::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'space-and-science' and p.slug = 'solar-system') and sort_order >= 7;
insert into public.ls_questions (part_id, sort_order, question, options, correct_index, explanation)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'space-and-science' and p.slug = 'solar-system'), v.sort_order, v.question, v.options, v.correct_index, v.explanation from (values
  (0, 'About how long does sunlight take to reach Earth?', '["8 seconds","About 8 minutes","About 8 hours","About 8 days"]'::jsonb, 1, 'About 8 minutes and 20 seconds.'),
  (1, 'Why is Venus hotter than Mercury?', '["Venus is closer to the Sun","Venus has active volcanoes everywhere","Its thick carbon dioxide atmosphere traps heat","Venus spins faster"]'::jsonb, 2, 'A runaway greenhouse effect keeps Venus around 465°C.'),
  (2, 'What causes Earth''s seasons?', '["Changes in Earth''s distance from the Sun","The tilt of Earth''s axis","The Moon''s orbit","Changes in the Sun''s brightness"]'::jsonb, 1, 'A tilt of about 23.4° changes how directly sunlight hits each hemisphere.'),
  (3, 'Why is Pluto classed as a dwarf planet?', '["It isn''t round","It doesn''t orbit the Sun","It hasn''t cleared its orbit of other objects","It has no moons"]'::jsonb, 2, 'Pluto shares its orbital region with other Kuiper Belt objects.'),
  (4, 'On which planet is a day longer than a year?', '["Mars","Venus","Jupiter","Mercury"]'::jsonb, 1, 'Venus takes about 243 Earth days to rotate once but about 225 to orbit the Sun.')
) as v(sort_order, question, options, correct_index, explanation)
on conflict (part_id, sort_order) do update set question = excluded.question, options = excluded.options,
  correct_index = excluded.correct_index, explanation = excluded.explanation;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'space-and-science' and p.slug = 'solar-system') and sort_order >= 5;

-- part: rockets
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'rockets', 'How rockets work', 'Pushing against nothing, and getting to orbit.', '🚀', 1
from public.ls_chapters c where c.slug = 'space-and-science'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'space-and-science' and p.slug = 'rockets'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'concept', 'Throw stuff backward, go forward', 'A rocket doesn''t push against the air. It throws hot gas out of its nozzle very fast, and the gas pushes the rocket the other way, which is Newton''s third law.

Rockets also carry their own oxidizer along with fuel, so they can burn in the vacuum of space where there''s no air.', null::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'space-and-science' and p.slug = 'rockets') and sort_order >= 1;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'space-and-science' and p.slug = 'rockets') and sort_order >= 0;

-- part: light
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'light', 'Light', 'The fastest thing there is.', '💡', 2
from public.ls_chapters c where c.slug = 'space-and-science'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'space-and-science' and p.slug = 'light'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'number', '299,792 kilometers per second', 'That''s the speed of light in a vacuum, about 300,000 km every second. Light could circle Earth about seven and a half times in one second.

The meter is now defined using this speed, which is set at exactly 299,792,458 meters per second.', null::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'space-and-science' and p.slug = 'light') and sort_order >= 1;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'space-and-science' and p.slug = 'light') and sort_order >= 0;

commit;
