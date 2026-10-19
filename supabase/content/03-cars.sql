-- Generated from content/03-cars.json by "npm run content:sql". Safe to run more than once.
-- Paste into Supabase: SQL Editor > New query > Run.
begin;

insert into public.ls_chapters (slug, title, description, emoji, color, sort_order)
values ('cars', 'Cars', 'What''s actually happening under the hood.', '🚗', '#ef4444', 3)
on conflict (slug) do update set title = excluded.title, description = excluded.description,
  emoji = excluded.emoji, color = excluded.color, sort_order = excluded.sort_order;

-- part: engine
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'engine', 'The engine', 'Four strokes, a spinning crank and a lot of controlled explosions.', '⚙️', 0
from public.ls_chapters c where c.slug = 'cars'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'cars' and p.slug = 'engine'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'concept', 'Suck, squeeze, bang, blow', 'Most car engines are four-stroke engines. Each piston repeats four steps:

1. **Intake**: the piston moves down and pulls in air (and fuel).
2. **Compression**: it moves up and squeezes the mix.
3. **Power**: the mix burns, pushing the piston down hard.
4. **Exhaust**: it moves up and pushes the burned gas out.', null::text, null::text),
  (1, 'concept', 'Turning up-and-down into round-and-round', 'Pistons move straight up and down, but wheels need to spin. The crankshaft solves this.

Each piston connects to the crankshaft through a connecting rod attached off-center, like your leg on a bicycle pedal. Every push down turns the crank, and the crank''s rotation eventually reaches the wheels through the gearbox.', null::text, null::text),
  (2, 'number', 'One power stroke per two turns', 'In a four-stroke engine, each cylinder fires once for every two full turns of the crankshaft, or 720 degrees.

That''s why engines have several cylinders firing in a staggered order. With four cylinders, there''s a power stroke every half turn, which keeps the engine smooth.', null::text, null::text),
  (3, 'concept', 'Spark or squeeze', 'A petrol engine lights the fuel-air mix with a spark plug.

A diesel engine has no spark plugs. It squeezes air so hard that the air gets very hot, then injects diesel fuel, which ignites on its own. That''s called compression ignition, and it''s why diesel engines run at much higher compression ratios than petrol engines.', 'Compression ratio compares the cylinder''s volume with the piston at the bottom to its volume with the piston at the top. Petrol engines commonly sit around 10:1 to 13:1, because squeezing a fuel-air mix too hard can make it ignite early and knock. Diesels only squeeze air, so they can go much higher, often 15:1 or more.'::text, null::text),
  (4, 'concept', 'Valves and the camshaft', 'Each cylinder has intake valves to let air in and exhaust valves to let gas out. A camshaft, with egg-shaped lobes, pushes them open at exactly the right moments.

A timing belt or chain links the camshaft to the crankshaft. The camshaft turns at half the crank''s speed, because each valve opens once per two crank turns.', null::text, null::text),
  (5, 'concept', 'Turbochargers: free energy from exhaust', 'Hot exhaust gas leaving the engine still carries energy. A turbocharger uses it to spin a small turbine, which drives a compressor on the same shaft.

The compressor packs more air into the cylinders. More air lets the engine burn more fuel per stroke, so a smaller engine can make the power of a bigger one.', null::text, null::text),
  (6, 'what_would_you_do', 'The check-engine light starts flashing', 'You''re driving and the check-engine light comes on. It isn''t steady. It''s flashing, and the car feels a bit rough.

Keep going to your destination, or ease off and get it checked soon?', 'A steady check-engine light usually means a fault has been logged and you should get it scanned soon. A flashing light usually signals a severe misfire. Unburned fuel can then reach the catalytic converter and overheat it, which can damage it. The usual advice is to reduce speed and load and get the car checked as soon as you safely can.'::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'cars' and p.slug = 'engine') and sort_order >= 7;
insert into public.ls_questions (part_id, sort_order, question, options, correct_index, explanation)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'cars' and p.slug = 'engine'), v.sort_order, v.question, v.options, v.correct_index, v.explanation from (values
  (0, 'What is the order of the four strokes?', '["Compression, intake, exhaust, power","Intake, compression, power, exhaust","Intake, power, compression, exhaust","Power, exhaust, intake, compression"]'::jsonb, 1, 'Intake, compression, power, exhaust: often remembered as suck, squeeze, bang, blow.'),
  (1, 'How does a diesel engine ignite its fuel?', '["With a spark plug","With a glow from the exhaust","Air is compressed until it''s hot enough to ignite the injected fuel","The battery heats the fuel directly"]'::jsonb, 2, 'That''s compression ignition. Glow plugs only help with cold starts in many diesels.'),
  (2, 'How fast does the camshaft turn compared with the crankshaft?', '["Twice as fast","The same speed","Half as fast","Four times as fast"]'::jsonb, 2, 'Each valve opens once per two crank turns, so the cam turns at half speed.'),
  (3, 'What powers a turbocharger?', '["The battery","Exhaust gas","A belt from the crankshaft","The cooling fan"]'::jsonb, 1, 'Exhaust spins the turbine. A supercharger, by contrast, is driven by the engine through a belt or gears.'),
  (4, 'A flashing check-engine light usually means:', '["Low windshield washer fluid","Time for routine service","A severe misfire that can damage the catalytic converter","The fuel cap is loose"]'::jsonb, 2, 'Ease off and get it checked soon. A loose fuel cap typically triggers a steady light, not a flashing one.')
) as v(sort_order, question, options, correct_index, explanation)
on conflict (part_id, sort_order) do update set question = excluded.question, options = excluded.options,
  correct_index = excluded.correct_index, explanation = excluded.explanation;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'cars' and p.slug = 'engine') and sort_order >= 5;

-- part: cooling-system
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'cooling-system', 'Cooling system', 'How the engine keeps from cooking itself.', '🌡️', 1
from public.ls_chapters c where c.slug = 'cars'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'cars' and p.slug = 'cooling-system'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'concept', 'A loop of coolant', 'A pump pushes coolant through passages in the engine, where it soaks up heat, then through the radiator at the front of the car, where air carries the heat away.

A thermostat stays closed while the engine is cold so it warms up quickly, then opens to let coolant flow to the radiator.', null::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'cars' and p.slug = 'cooling-system') and sort_order >= 1;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'cars' and p.slug = 'cooling-system') and sort_order >= 0;

-- part: exhaust
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'exhaust', 'Exhaust', 'Cleaning up what comes out of the engine.', '💨', 2
from public.ls_chapters c where c.slug = 'cars'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'cars' and p.slug = 'exhaust'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'concept', 'The catalytic converter', 'A petrol car''s three-way catalytic converter handles three harmful gases at once. Precious metals coated on a honeycomb inside help turn carbon monoxide into carbon dioxide, unburned fuel into carbon dioxide and water, and nitrogen oxides into nitrogen.', null::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'cars' and p.slug = 'exhaust') and sort_order >= 1;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'cars' and p.slug = 'exhaust') and sort_order >= 0;

-- part: high-voltage-battery
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'high-voltage-battery', 'High-voltage battery', 'What''s inside an electric car''s battery pack.', '🔋', 3
from public.ls_chapters c where c.slug = 'cars'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'cars' and p.slug = 'high-voltage-battery'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'concept', 'Cells, modules, pack', 'An EV battery pack is built from hundreds or thousands of small lithium-ion cells, grouped into modules, then into one pack under the floor.

A battery management system watches each group''s voltage and temperature to keep the pack safe and balanced. Many packs run around 400 volts; some newer cars use about 800.', null::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'cars' and p.slug = 'high-voltage-battery') and sort_order >= 1;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'cars' and p.slug = 'high-voltage-battery') and sort_order >= 0;

commit;
