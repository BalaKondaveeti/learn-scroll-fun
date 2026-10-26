-- Generated from content/01-business.json by "npm run content:sql". Safe to run more than once.
-- Paste into Supabase: SQL Editor > New query > Run.
begin;

insert into public.ls_chapters (slug, title, description, emoji, color, sort_order)
values ('business', 'Business', 'How real companies solved real problems, the words founders use, and what to check before you start.', '💼', '#f59e0b', 1)
on conflict (slug) do update set title = excluded.title, description = excluded.description,
  emoji = excluded.emoji, color = excluded.color, sort_order = excluded.sort_order;

-- part: case-studies
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'case-studies', 'Company case studies', 'Six moments where a company faced a hard problem and chose a path.', '📚', 0
from public.ls_chapters c where c.slug = 'business'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'business' and p.slug = 'case-studies'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'case_study', 'Tylenol, 1982: protect people first', 'In 1982, seven people in the Chicago area died after taking Tylenol capsules that someone had laced with cyanide. Johnson & Johnson didn''t wait to learn how far it spread. It pulled Tylenol from shelves across the US and told the public not to use it.

The lesson: in a safety crisis, speed and honesty protect the brand better than damage control.', 'The tampering happened after the bottles reached stores, not in the factory, but J&J treated it as its own problem. It later brought Tylenol back in tamper-resistant packaging. The case is still taught as a model of crisis response, and it is a big reason sealed caps and foil seals on medicine became normal.'::text, null::text),
  (1, 'number', '31 million bottles', 'That is roughly how many bottles of Tylenol Johnson & Johnson recalled in 1982. The recall cost the company over $100 million, a huge sum at the time.

The brand''s market share collapsed, then recovered within about a year once the product returned in tamper-resistant packaging.', null::text, null::text),
  (2, 'case_study', 'Toyota: let anyone stop the line', 'On a Toyota assembly line, any worker can pull a cord, called the andon cord, when they spot a problem. The line stops and a team leader comes to help.

Stopping a car factory sounds expensive. Toyota''s bet was that fixing a defect at its source is cheaper than shipping it, finding it later, or repeating it a thousand times.', 'This is part of the Toyota Production System. Two ideas sit at its core: just-in-time (make only what is needed, when it is needed, which keeps inventory low) and jidoka (build quality checks into the process so problems surface immediately). Many software teams borrow the same idea when they stop and fix a broken build before adding more code.'::text, null::text),
  (3, 'case_study', 'Southwest: one kind of plane', 'For most of its history, Southwest Airlines has flown only one aircraft family: the Boeing 737.

One type means pilots, mechanics and crews train on a single model, spare parts are shared across the fleet, and any plane can replace any other when something breaks. That simplicity was a big part of how it kept costs low.', null::text, null::text),
  (4, 'case_study', 'Apple, 1997: cut the menu', 'When Steve Jobs returned to a struggling Apple in 1997, it sold a confusing number of similar computers. He cut the lineup down to a simple grid: consumer and professional, desktop and portable. Four main products.

Fewer products meant engineers could focus, and customers could tell what to buy. Saying no was the strategy.', 'That same year, Microsoft invested $150 million in Apple and committed to keeping Office on the Mac, which helped calm fears that Apple might not survive. The iMac followed in 1998 and became Apple''s first big hit of that era.'::text, null::text),
  (5, 'case_study', 'Amazon: sell what you built for yourself', 'Amazon spent years building computing infrastructure to run its own store. In 2006 it began renting that capability to others as Amazon Web Services, starting with storage (S3) and then rented servers (EC2).

A tool built to solve an internal problem became a business in its own right, and later one of Amazon''s most profitable.', null::text, null::text),
  (6, 'what_would_you_do', 'Your DVD business vs. streaming', 'You run a profitable DVD-by-mail company. Internet speeds are rising and streaming is starting to look possible, but it would compete with the business that pays your bills.

Do you protect the DVD business, or start the thing that could replace it?', 'Netflix faced exactly this. It launched streaming in 2007 while DVDs were still its core. In 2011 it tried to split the two into separate services, with DVDs renamed Qwikster. Customers hated it, the company lost about 800,000 US subscribers in a quarter, and it dropped the Qwikster plan within weeks. The move to streaming itself was right; the rushed split was the mistake.'::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'business' and p.slug = 'case-studies') and sort_order >= 7;
insert into public.ls_questions (part_id, sort_order, question, options, correct_index, explanation)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'business' and p.slug = 'case-studies'), v.sort_order, v.question, v.options, v.correct_index, v.explanation from (values
  (0, 'What did Johnson & Johnson do after the 1982 Tylenol poisonings?', '["Recalled Tylenol nationwide and told people not to use it","Recalled only the bottles from Chicago stores","Waited for the police investigation before acting","Lowered the price to win back customers"]'::jsonb, 0, 'J&J recalled roughly 31 million bottles across the US, then relaunched in tamper-resistant packaging.'),
  (1, 'What is the andon cord on a Toyota line?', '["A safety harness for workers","A cord any worker can pull to stop the line when they see a problem","A conveyor that moves parts just in time","A signal that a shift is over"]'::jsonb, 1, 'Stopping to fix a problem at its source is cheaper than passing defects down the line.'),
  (2, 'Why did Southwest fly a single aircraft family?', '["Boeing gave it the planes for free","Regulators required it","It simplified training, maintenance and spare parts","The 737 was the only plane that fit its airports"]'::jsonb, 2, 'One type means crews and mechanics train once and parts are shared across the whole fleet.'),
  (3, 'How did Apple simplify its lineup in 1997?', '["It stopped making laptops","It moved to a four-part grid: consumer or pro, desktop or portable","It only sold software","It licensed the Mac to other manufacturers"]'::jsonb, 1, 'Cutting to four core products let teams focus and made buying decisions simple.'),
  (4, 'What went wrong with Netflix''s Qwikster plan in 2011?', '["Streaming technology wasn''t ready","Splitting DVDs and streaming angered customers, and Netflix reversed it within weeks","A competitor bought the Qwikster name","Regulators blocked the split"]'::jsonb, 1, 'Netflix lost about 800,000 US subscribers that quarter and quickly dropped the split.')
) as v(sort_order, question, options, correct_index, explanation)
on conflict (part_id, sort_order) do update set question = excluded.question, options = excluded.options,
  correct_index = excluded.correct_index, explanation = excluded.explanation;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'business' and p.slug = 'case-studies') and sort_order >= 5;

-- part: startup-terms
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'startup-terms', 'Startup terms', 'The vocabulary you''ll hear in every founder conversation.', '🗣️', 1
from public.ls_chapters c where c.slug = 'business'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'business' and p.slug = 'startup-terms'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'concept', 'Burn rate and runway', 'Burn rate is how much money a company loses each month. Runway is how many months it can survive at that pace.

Runway = cash in the bank ÷ monthly burn. With $600,000 and a burn of $50,000 a month, you have 12 months to grow, raise money or cut costs.', null::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'business' and p.slug = 'startup-terms') and sort_order >= 1;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'business' and p.slug = 'startup-terms') and sort_order >= 0;

-- part: before-you-start
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'before-you-start', 'Before you start a business', 'Questions worth answering before you spend your savings.', '🧭', 2
from public.ls_chapters c where c.slug = 'business'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'business' and p.slug = 'before-you-start'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'concept', 'Know your unit economics', 'Before scaling anything, know what one customer is worth. How much do you earn from them over time, and how much does it cost to win and serve them?

If each sale loses money, growing faster only loses money faster.', null::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'business' and p.slug = 'before-you-start') and sort_order >= 1;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'business' and p.slug = 'before-you-start') and sort_order >= 0;

commit;

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

-- Generated from content/04-politics-and-world.json by "npm run content:sql". Safe to run more than once.
-- Paste into Supabase: SQL Editor > New query > Run.
begin;

insert into public.ls_chapters (slug, title, description, emoji, color, sort_order)
values ('politics-and-world', 'Politics and World', 'How elections and governments work, in India, the US and beyond. Systems and facts, not opinions.', '🗳️', '#3b82f6', 4)
on conflict (slug) do update set title = excluded.title, description = excluded.description,
  emoji = excluded.emoji, color = excluded.color, sort_order = excluded.sort_order;

-- part: voting-in-india
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'voting-in-india', 'How voting works in India', 'From the Election Commission to the ink on your finger.', '🇮🇳', 0
from public.ls_chapters c where c.slug = 'politics-and-world'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'politics-and-world' and p.slug = 'voting-in-india'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'concept', 'Who runs elections', 'The Election Commission of India is set up by Article 324 of the Constitution. It conducts elections to the Lok Sabha, the state legislative assemblies, and the offices of President and Vice-President.

It is independent of the government of the day, which is meant to keep elections fair no matter who is in power.', null::text, null::text),
  (1, 'number', '543 seats, 272 to govern', 'The Lok Sabha has 543 elected seats, one per constituency. A party or alliance needs a majority, at least 272 seats, to form a government on its own.

The leader of that majority usually becomes Prime Minister.', null::text, null::text),
  (2, 'concept', 'Most votes wins', 'India uses first-past-the-post. Each constituency elects one member, and the candidate with the most votes wins, even without a majority.

So a party''s share of seats can be quite different from its share of the national vote.', null::text, null::text),
  (3, 'concept', 'EVMs and the paper slip', 'Indians vote on electronic voting machines. When you press the button for a candidate, an attached VVPAT printer shows a slip with the candidate''s serial number, name and symbol behind glass for about seven seconds. The slip then drops into a sealed box.

VVPATs have been used at every polling station since the 2019 Lok Sabha election.', 'VVPAT stands for Voter Verifiable Paper Audit Trail. It was first used in a 2013 by-election in Noksen, Nagaland. In 2019, the Supreme Court ordered that VVPAT slips be matched against EVM counts at five randomly chosen polling stations in each assembly segment, up from one.'::text, null::text),
  (4, 'fact', 'NOTA: None of the Above', 'Since 2013, following a Supreme Court judgment, every ballot has a NOTA option: None of the Above.

NOTA lets you record that you reject every candidate. But it does not change who wins. Even if NOTA gets the most votes, the candidate with the most votes is still elected.', null::text, null::text),
  (5, 'concept', 'The Model Code of Conduct', 'Once the Election Commission announces the election schedule, the Model Code of Conduct takes effect. These are guidelines for parties, candidates and governments during the campaign.

For example, governments shouldn''t announce new schemes that could sway voters, and official resources shouldn''t be used for campaigning.', null::text, null::text),
  (6, 'fact', 'The ink that marks you', 'After you vote, an official marks your left index finger with indelible ink. It can''t be washed off for days, which helps stop anyone voting twice.

The ink is made by Mysore Paints and Varnish Limited, a company owned by the Karnataka government.', null::text, null::text),
  (7, 'number', 'Voting at 18', 'The voting age in India used to be 21. The 61st Constitutional Amendment, passed in 1988, lowered it to 18.

Any citizen aged 18 or over who is enrolled on the electoral roll can vote.', null::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'politics-and-world' and p.slug = 'voting-in-india') and sort_order >= 8;
insert into public.ls_questions (part_id, sort_order, question, options, correct_index, explanation)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'politics-and-world' and p.slug = 'voting-in-india'), v.sort_order, v.question, v.options, v.correct_index, v.explanation from (values
  (0, 'How many elected seats does the Lok Sabha have?', '["250","450","543","790"]'::jsonb, 2, '543 elected seats, so a majority is 272.'),
  (1, 'Which body conducts Lok Sabha and state assembly elections?', '["The Supreme Court","The Election Commission of India","The Ministry of Home Affairs","The Rajya Sabha"]'::jsonb, 1, 'The Election Commission, set up under Article 324 of the Constitution.'),
  (2, 'If NOTA gets the most votes in a constituency, what happens?', '["The election is cancelled","A fresh election is held with new candidates","The candidate with the most votes still wins","The seat stays empty"]'::jsonb, 2, 'NOTA records rejection but doesn''t change the result.'),
  (3, 'What does the VVPAT do?', '["Counts votes automatically","Shows the voter a paper slip of their choice for about seven seconds","Gives the voter a receipt to take home","Checks the voter''s ID"]'::jsonb, 1, 'The slip is visible briefly behind glass, then drops into a sealed box. Voters can''t take it home.'),
  (4, 'Which amendment lowered India''s voting age from 21 to 18?', '["The 42nd Amendment","The 61st Amendment","The 73rd Amendment","The 86th Amendment"]'::jsonb, 1, 'The 61st Amendment, passed in 1988.')
) as v(sort_order, question, options, correct_index, explanation)
on conflict (part_id, sort_order) do update set question = excluded.question, options = excluded.options,
  correct_index = excluded.correct_index, explanation = excluded.explanation;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'politics-and-world' and p.slug = 'voting-in-india') and sort_order >= 5;

-- part: voting-in-the-usa
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'voting-in-the-usa', 'How voting works in the USA', 'States, the Electoral College and 270.', '🇺🇸', 1
from public.ls_chapters c where c.slug = 'politics-and-world'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'politics-and-world' and p.slug = 'voting-in-the-usa'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'number', '538 electors, 270 to win', 'Americans don''t elect the President directly. Each state gets electors equal to its number of senators plus representatives, and Washington, D.C. gets three. That makes 538 in total.

A candidate needs a majority, 270, to win. Most states give all their electors to whoever wins the state''s popular vote.', null::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'politics-and-world' and p.slug = 'voting-in-the-usa') and sort_order >= 1;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'politics-and-world' and p.slug = 'voting-in-the-usa') and sort_order >= 0;

-- part: indian-politics
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'indian-politics', 'Indian politics', 'How India''s parliamentary system fits together.', '🏛️', 2
from public.ls_chapters c where c.slug = 'politics-and-world'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'politics-and-world' and p.slug = 'indian-politics'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'concept', 'President and Prime Minister', 'India is a parliamentary democracy. The President is head of state, but real executive power sits with the Prime Minister and the Council of Ministers, who must keep the support of the Lok Sabha.

Rajya Sabha members are mostly elected by state legislators, not directly by voters.', null::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'politics-and-world' and p.slug = 'indian-politics') and sort_order >= 1;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'politics-and-world' and p.slug = 'indian-politics') and sort_order >= 0;

-- part: andhra-pradesh-politics
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'andhra-pradesh-politics', 'Andhra Pradesh politics', 'The state''s legislature and how it was reshaped in 2014.', '🌾', 3
from public.ls_chapters c where c.slug = 'politics-and-world'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'politics-and-world' and p.slug = 'andhra-pradesh-politics'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'fact', 'A state reshaped in 2014', 'On 2 June 2014, Andhra Pradesh was divided and Telangana became a separate state.

Today, Andhra Pradesh elects 175 members to its Legislative Assembly and sends 25 members to the Lok Sabha.', null::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'politics-and-world' and p.slug = 'andhra-pradesh-politics') and sort_order >= 1;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'politics-and-world' and p.slug = 'andhra-pradesh-politics') and sort_order >= 0;

-- part: american-politics
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'american-politics', 'American politics', 'Three branches and how they check each other.', '⚖️', 4
from public.ls_chapters c where c.slug = 'politics-and-world'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'politics-and-world' and p.slug = 'american-politics'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'concept', 'Three branches', 'The US Constitution splits power three ways. Congress makes laws, the President carries them out, and the courts interpret them.

Congress has two chambers: a Senate with 100 members, two per state, and a House of Representatives with 435 members, allocated by population.', null::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'politics-and-world' and p.slug = 'american-politics') and sort_order >= 1;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'politics-and-world' and p.slug = 'american-politics') and sort_order >= 0;

-- part: geopolitics
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'geopolitics', 'Geopolitics', 'How countries and institutions shape world events.', '🌍', 5
from public.ls_chapters c where c.slug = 'politics-and-world'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'politics-and-world' and p.slug = 'geopolitics'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'fact', 'Five vetoes', 'The UN Security Council has 15 members. Five are permanent: the United States, the United Kingdom, France, China and Russia.

Each permanent member can veto a substantive resolution, so a single ''no'' from any of them blocks it.', null::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'politics-and-world' and p.slug = 'geopolitics') and sort_order >= 1;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'politics-and-world' and p.slug = 'geopolitics') and sort_order >= 0;

commit;

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

-- Generated from content/06-mind.json by "npm run content:sql". Safe to run more than once.
-- Paste into Supabase: SQL Editor > New query > Run.
begin;

insert into public.ls_chapters (slug, title, description, emoji, color, sort_order)
values ('mind', 'Mind', 'Old philosophy and simple practices for a steadier head.', '🧘', '#06b6d4', 6)
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

-- Generated from content/07-tech-and-ai-career.json by "npm run content:sql". Safe to run more than once.
-- Paste into Supabase: SQL Editor > New query > Run.
begin;

insert into public.ls_chapters (slug, title, description, emoji, color, sort_order)
values ('tech-and-ai-career', 'Tech and AI Career', 'How LLMs work, system design basics and getting ready for big-tech interviews.', '💻', '#d946ef', 7)
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

-- Generated from content/08-mahabharata.json by "npm run content:sql". Safe to run more than once.
-- Paste into Supabase: SQL Editor > New query > Run.
begin;

insert into public.ls_chapters (slug, title, description, emoji, color, sort_order)
values ('mahabharata', 'Mahabharata and the Gita', 'The people, the feud that led to Kurukshetra, and what happened in the 18-day war. Who''s who, not the whole story.', '🏹', '#ea580c', 8)
on conflict (slug) do update set title = excluded.title, description = excluded.description,
  emoji = excluded.emoji, color = excluded.color, sort_order = excluded.sort_order;

-- part: the-gita-moment
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'the-gita-moment', 'The Gita moment', 'Where the Bhagavad Gita sits in the epic, and why it begins on a battlefield.', '📜', 0
from public.ls_chapters c where c.slug = 'mahabharata'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mahabharata' and p.slug = 'the-gita-moment'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'concept', 'A conversation inside an epic', 'The Bhagavad Gita is a conversation between Prince Arjuna and Krishna, who is driving his chariot. It sits inside the Mahabharata, in the Bhishma Parva, the sixth of the epic''s 18 books.

It happens on the battlefield of Kurukshetra, just before the first day of a great war, with both armies lined up and waiting.', null::text, null::text),
  (1, 'number', '18 chapters, 700 verses', 'The Gita is traditionally counted as 700 verses in 18 chapters. The Mahabharata around it is enormous, traditionally said to run to about 100,000 verses.

The number 18 keeps appearing: 18 books in the epic, 18 chapters in the Gita, 18 armies at Kurukshetra and 18 days of war.', null::text, null::text),
  (2, 'fact', 'The Gita is told secondhand', 'The Gita opens with a question from Dhritarashtra, the blind king of Hastinapura: what are my sons and Pandu''s sons doing at Kurukshetra?

His advisor Sanjaya answers. The sage Vyasa had given Sanjaya divine sight so he could see and hear the battlefield from far away. So the whole Gita reaches us as Sanjaya''s report to the king.', null::text, null::text),
  (3, 'concept', 'Arjuna drops his bow', 'Arjuna asks Krishna to drive his chariot between the two armies. Facing him he sees his grand-uncle Bhishma, his teacher Drona, cousins, friends and relatives.

Overwhelmed, he says he would rather die than kill his own family. He sets down his bow and sits in the chariot. The first chapter is named after this despair: Arjuna Vishada Yoga.', null::text, null::text),
  (4, 'concept', 'Krishna''s answer', 'The other 17 chapters are Krishna''s reply. He talks about duty, action without attachment to results, the self that does not die, controlling the mind, devotion, and the nature of the divine.

In chapter 11, he shows Arjuna his cosmic form, the Vishvarupa. By the last chapter, Arjuna says his confusion is gone and he will act.', null::text, null::text),
  (5, 'number', '18 akshauhinis', 'Armies in the epic are counted in akshauhinis, a unit the Mahabharata defines as 21,870 chariots, 21,870 elephants, 65,610 horses and 109,350 foot soldiers.

At Kurukshetra, the Kauravas had 11 akshauhinis and the Pandavas 7. The Pandavas went in outnumbered.', null::text, null::text),
  (6, 'fact', 'Kurukshetra is a real place', 'Kurukshetra is a town and district in present-day Haryana, north of Delhi. It is a major pilgrimage site, and Jyotisar near the town is traditionally pointed to as the spot where the Gita was spoken.', null::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mahabharata' and p.slug = 'the-gita-moment') and sort_order >= 7;
insert into public.ls_questions (part_id, sort_order, question, options, correct_index, explanation)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mahabharata' and p.slug = 'the-gita-moment'), v.sort_order, v.question, v.options, v.correct_index, v.explanation from (values
  (0, 'Who are the two people talking in the Bhagavad Gita?', '["Arjuna and Krishna","Yudhishthira and Bhishma","Dhritarashtra and Vidura","Karna and Duryodhana"]'::jsonb, 0, 'Arjuna asks and Krishna, his charioteer, answers.'),
  (1, 'How does the Gita reach the blind king Dhritarashtra?', '["Arjuna writes him a letter","Sanjaya, given divine sight by Vyasa, describes it to him","Krishna visits the palace","He hears it from Bhishma after the war"]'::jsonb, 1, 'The whole Gita is Sanjaya''s report of what he sees and hears on the battlefield.'),
  (2, 'Why does Arjuna put down his bow?', '["He is wounded","He sees his elders, teachers and relatives on the other side and can''t bear to fight them","Krishna orders him to","The battle has been called off"]'::jsonb, 1, 'His grief and confusion at fighting his own family is what starts the conversation.'),
  (3, 'How many chapters does the Bhagavad Gita have?', '["12","18","24","100"]'::jsonb, 1, '18 chapters and traditionally 700 verses.'),
  (4, 'Which side had the bigger army at Kurukshetra?', '["The Pandavas, with 11 akshauhinis","Both were equal","The Kauravas, with 11 akshauhinis to the Pandavas'' 7","Neither side had an army; it was single combat"]'::jsonb, 2, 'The Kauravas had 11 akshauhinis; the Pandavas had 7.')
) as v(sort_order, question, options, correct_index, explanation)
on conflict (part_id, sort_order) do update set question = excluded.question, options = excluded.options,
  correct_index = excluded.correct_index, explanation = excluded.explanation;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mahabharata' and p.slug = 'the-gita-moment') and sort_order >= 5;

-- part: pandavas
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'pandavas', 'Who''s who: the Pandavas', 'The five brothers, their mother and their wife, and what each is known for.', '🛡️', 1
from public.ls_chapters c where c.slug = 'mahabharata'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mahabharata' and p.slug = 'pandavas'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'concept', 'Five sons of Pandu', 'King Pandu could not father children because of a curse. His wife Kunti had a mantra, given by the sage Durvasa, that let her call on a god and have a child by him. She shared it with Pandu''s second wife, Madri.

That is why each Pandava brother is called the son of a god.', null::text, null::text),
  (1, 'concept', 'Yudhishthira: the truthful one', 'The eldest Pandava, son of Kunti and Dharma, the god of righteousness. He is known for honesty and calm judgment, and he later becomes king.

His weakness is gambling. In a game of dice he loses his kingdom, his brothers, himself and his wife, which sets the road to war in motion.', null::text, null::text),
  (2, 'concept', 'Bhima: the strongest', 'Son of Kunti and Vayu, the wind god. Bhima has enormous strength and a huge appetite, and he fights with a mace.

He kills powerful enemies like the demons Hidimba and Baka, and in the war he kills Dushasana and Duryodhana, fulfilling vows he made after Draupadi was humiliated.', null::text, null::text),
  (3, 'concept', 'Arjuna: the archer', 'Son of Kunti and Indra, king of the gods. Arjuna is the greatest archer of his time, Drona''s favorite student, and Krishna''s close friend.

He carries the Gandiva bow and can shoot with either hand, which earned him the name Savyasachi. He also won divine weapons, including the Pashupatastra from Shiva.', 'Arjuna won Draupadi at her swayamvara by hitting the eye of a revolving fish target while looking only at its reflection. He received the Gandiva from the fire god Agni at the burning of the Khandava forest. In the war he faces his own teachers and elders, which is exactly why he breaks down before it begins.'::text, null::text),
  (4, 'concept', 'Nakula and Sahadeva: the twins', 'The youngest two, sons of Madri and the Ashvins, the twin gods of healing. After Madri''s death, Kunti raised them as her own.

Nakula is known for his good looks and skill with horses. Sahadeva is known for wisdom and knowledge. In the war, Sahadeva kills Shakuni.', null::text, null::text),
  (5, 'concept', 'Draupadi: born from fire', 'Daughter of King Drupada of Panchala, said to have risen from a sacrificial fire. She becomes the shared wife of all five Pandavas.

When Yudhishthira loses her in the dice game, she is dragged into the royal court and insulted. Her humiliation is one of the deepest causes of the war.', null::text, null::text),
  (6, 'concept', 'Kunti: mother with a secret', 'Mother of Yudhishthira, Bhima and Arjuna, and Krishna''s aunt. Before her marriage she tested Durvasa''s mantra on the sun god Surya and had a son, Karna.

Afraid of the scandal, she set the baby afloat on a river. She tells Karna the truth only shortly before the war.', null::text, null::text),
  (7, 'concept', 'The next generation', 'Abhimanyu, son of Arjuna and Krishna''s sister Subhadra, is a brilliant young warrior who dies in the war.

Ghatotkacha, son of Bhima and Hidimbi, has the powers of a rakshasa, including flight and illusion. Draupadi''s five sons by the brothers, the Upapandavas, also fight.', null::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mahabharata' and p.slug = 'pandavas') and sort_order >= 8;
insert into public.ls_questions (part_id, sort_order, question, options, correct_index, explanation)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mahabharata' and p.slug = 'pandavas'), v.sort_order, v.question, v.options, v.correct_index, v.explanation from (values
  (0, 'Which god is Arjuna''s father?', '["Vayu","Indra","Dharma","Surya"]'::jsonb, 1, 'Arjuna is Indra''s son. Vayu is Bhima''s father, Dharma is Yudhishthira''s, and Surya is Karna''s.'),
  (1, 'What is Bhima best known for?', '["Archery","Enormous strength and fighting with a mace","Knowledge of astrology","Never telling a lie"]'::jsonb, 1, 'He''s the strongest of the brothers and kills Dushasana and Duryodhana in the war.'),
  (2, 'Who is the mother of Nakula and Sahadeva?', '["Kunti","Gandhari","Madri","Draupadi"]'::jsonb, 2, 'They are Madri''s sons by the Ashvins. Kunti raised them after Madri died.'),
  (3, 'What was Yudhishthira''s great weakness?', '["Anger","Gambling","Fear of battle","Greed for land"]'::jsonb, 1, 'He lost everything, including Draupadi, in a game of dice.'),
  (4, 'Why is Arjuna called Savyasachi?', '["He never misses a target","He can shoot with either hand","He was born at sunrise","He carries two bows"]'::jsonb, 1, 'Savyasachi means someone who can draw the bow with the left hand as well as the right.')
) as v(sort_order, question, options, correct_index, explanation)
on conflict (part_id, sort_order) do update set question = excluded.question, options = excluded.options,
  correct_index = excluded.correct_index, explanation = excluded.explanation;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mahabharata' and p.slug = 'pandavas') and sort_order >= 5;

-- part: kaurava-side
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'kaurava-side', 'Who''s who: the Kaurava side', 'The blind king''s family, and the great warriors who fought for them.', '⚔️', 2
from public.ls_chapters c where c.slug = 'mahabharata'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mahabharata' and p.slug = 'kaurava-side'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'concept', 'Dhritarashtra and Gandhari', 'Dhritarashtra was born blind, so his younger brother Pandu was made king first. After Pandu''s death, Dhritarashtra ruled in Hastinapura.

His wife Gandhari blindfolded herself for life to share his blindness. They had 100 sons, the Kauravas, and one daughter, Dushala. His love for his sons keeps him from stopping their wrongs.', null::text, null::text),
  (1, 'concept', 'Duryodhana: the rival', 'The eldest Kaurava, and a formidable mace fighter trained by Krishna''s brother Balarama. He believes the throne is his by right and resents the Pandavas from childhood.

He plots against them again and again. Before the war, he refuses to give them even the five villages they ask for.', null::text, null::text),
  (2, 'concept', 'Shakuni: the dice master', 'Gandhari''s brother, a prince of Gandhara, and Duryodhana''s uncle and advisor.

He is a master of dice. He plays on Duryodhana''s behalf in the fateful game and wins everything from Yudhishthira. He is killed by Sahadeva on the last day of the war.', null::text, null::text),
  (3, 'concept', 'Dushasana: the insult', 'The second Kaurava brother. In the dice hall, he drags Draupadi into court by her hair and tries to strip her in front of everyone. In the popular telling, her sari becomes endless and cannot be pulled away.

Bhima vows revenge, and kills him on the 16th day of the war.', null::text, null::text),
  (4, 'concept', 'Karna: the tragic hero', 'Kunti''s firstborn son by the sun god Surya, so the Pandavas'' eldest brother, though he doesn''t know it for most of his life. He was born with divine armor and earrings, and raised by a charioteer.

Mocked for his low status, he finds a friend in Duryodhana, who makes him king of Anga. He stays loyal to Duryodhana to the end.', 'Karna is famous for generosity. When Indra, disguised as a brahmin, asks for his armor and earrings to protect Arjuna, Karna cuts them off and gives them away, knowing what it costs him. In return Indra gives him a weapon that can be used only once. Even after Kunti tells him he is her son, Karna refuses to switch sides, though he promises her he will spare all her sons except Arjuna.'::text, null::text),
  (5, 'concept', 'Bhishma: the grand-uncle', 'Born Devavrata, son of King Shantanu and the river goddess Ganga. He took a vow never to marry or claim the throne so his father could marry Satyavati. The vow was so fierce he became known as Bhishma, the one of the terrible vow.

He was granted the power to choose the moment of his own death. He leads the Kaurava army for the first ten days.', null::text, null::text),
  (6, 'concept', 'Drona: the teacher', 'Dronacharya taught weapons to both the Pandavas and the Kauravas, and Arjuna was his favorite student. He is a brahmin who became a supreme warrior.

Bound by duty to Hastinapura, he fights for the Kauravas and leads their army after Bhishma falls.', null::text, null::text),
  (7, 'concept', 'Ashwatthama: the one who survives', 'Drona''s son, born with a gem on his forehead, and one of the chiranjivis, beings said to live for ages.

After the war is lost, he attacks the Pandava camp at night and kills Draupadi''s sons and Dhrishtadyumna in their sleep. For this, Krishna curses him to wander the earth.', null::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mahabharata' and p.slug = 'kaurava-side') and sort_order >= 8;
insert into public.ls_questions (part_id, sort_order, question, options, correct_index, explanation)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mahabharata' and p.slug = 'kaurava-side'), v.sort_order, v.question, v.options, v.correct_index, v.explanation from (values
  (0, 'Why did Gandhari wear a blindfold all her life?', '["As a punishment from a sage","To share her husband Dhritarashtra''s blindness","Because she was born blind","To hide her identity"]'::jsonb, 1, 'She chose to share Dhritarashtra''s blindness.'),
  (1, 'Who played dice on Duryodhana''s behalf?', '["Karna","Dushasana","Shakuni","Drona"]'::jsonb, 2, 'Shakuni, Duryodhana''s uncle and a master of dice.'),
  (2, 'What is Karna''s real relationship to the Pandavas?', '["He is their cousin through Gandhari","He is Kunti''s firstborn, so their eldest brother","He is Drona''s son","He has no relation to them"]'::jsonb, 1, 'Kunti had Karna by Surya before her marriage.'),
  (3, 'What special power did Bhishma have?', '["He could not be hit by arrows","He could choose the moment of his own death","He could become invisible","He could see the future"]'::jsonb, 1, 'This is why he could lie on a bed of arrows after falling and choose when to die.'),
  (4, 'What does Ashwatthama do after the war is lost?', '["He becomes king of Hastinapura","He joins the Pandavas","He attacks the Pandava camp at night and kills Draupadi''s sons","He retires to the forest in peace"]'::jsonb, 2, 'The night raid is one of the darkest moments of the epic, and Krishna curses him for it.')
) as v(sort_order, question, options, correct_index, explanation)
on conflict (part_id, sort_order) do update set question = excluded.question, options = excluded.options,
  correct_index = excluded.correct_index, explanation = excluded.explanation;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mahabharata' and p.slug = 'kaurava-side') and sort_order >= 5;

-- part: krishna-and-the-elders
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'krishna-and-the-elders', 'Krishna and the others', 'Krishna, plus the advisors and relatives who shaped events from the side.', '🦚', 3
from public.ls_chapters c where c.slug = 'mahabharata'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mahabharata' and p.slug = 'krishna-and-the-elders'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'concept', 'Krishna', 'Prince of the Yadavas, ruling from Dwaraka, and worshipped as an avatar of Vishnu. He is the Pandavas'' cousin (Kunti is his aunt) and Arjuna''s closest friend.

In the war he vows not to take up weapons. He serves as Arjuna''s charioteer, and his advice shapes every major turn of the fighting.', null::text, null::text),
  (1, 'case_study', 'Krishna or his army?', 'Before the war, Arjuna and Duryodhana both go to Krishna for help. He offers a choice: his large Narayani army, or himself alone, unarmed and not fighting.

Arjuna chooses Krishna. Duryodhana happily takes the army. The lesson drawn from it: wisdom and guidance can matter more than numbers.', null::text, null::text),
  (2, 'concept', 'Vidura: the wise advisor', 'Half-brother of Dhritarashtra and Pandu, and minister at Hastinapura. He is known for wisdom and fairness, and his advice to the king is collected as the Vidura Niti.

He warns the Pandavas about the plot to burn them alive and repeatedly urges Dhritarashtra to stop his sons.', null::text, null::text),
  (3, 'concept', 'Vyasa: author and grandfather', 'The sage Vyasa is traditionally credited with composing the Mahabharata. He is also part of the story: he is the biological father of Dhritarashtra, Pandu and Vidura, so grandfather to both sides.

He gives Sanjaya the divine sight to narrate the war.', null::text, null::text),
  (4, 'concept', 'Balarama: the one who stayed out', 'Krishna''s elder brother, a mighty warrior who taught mace fighting to both Bhima and Duryodhana.

Unwilling to fight either of his students'' sides, he leaves on a pilgrimage during the war. He returns for the final duel and is furious when Bhima strikes Duryodhana below the waist.', null::text, null::text),
  (5, 'concept', 'Dhrishtadyumna and Shikhandi', 'Draupadi''s brother Dhrishtadyumna, also said to be born from fire, commands the Pandava army for the whole war. He is destined to kill Drona, and does.

Shikhandi, another child of Drupada, was born female and is linked to Amba, a woman Bhishma had wronged. Bhishma refuses to fight Shikhandi, and that becomes the key to his fall.', null::text, null::text),
  (6, 'concept', 'Shalya: an uncle on the wrong side', 'King of Madra and brother of Madri, so uncle to Nakula and Sahadeva. He sets out to join the Pandavas, but Duryodhana wins him over through hospitality.

He ends up as Karna''s charioteer, where he undermines Karna''s confidence, and leads the Kaurava army on the last day. Yudhishthira kills him.', null::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mahabharata' and p.slug = 'krishna-and-the-elders') and sort_order >= 7;
insert into public.ls_questions (part_id, sort_order, question, options, correct_index, explanation)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mahabharata' and p.slug = 'krishna-and-the-elders'), v.sort_order, v.question, v.options, v.correct_index, v.explanation from (values
  (0, 'What choice did Krishna offer Arjuna and Duryodhana?', '["Gold or land","His army, or himself alone and unarmed","To fight or to make peace","His bow or his chariot"]'::jsonb, 1, 'Arjuna chose Krishna; Duryodhana chose the Narayani army.'),
  (1, 'What is Krishna''s role in the war?', '["Commander of the Pandava army","Arjuna''s charioteer, having vowed not to take up weapons","King of Hastinapura","Neutral observer on a pilgrimage"]'::jsonb, 1, 'He drives Arjuna''s chariot and guides him, without fighting himself.'),
  (2, 'Who commanded the Pandava army throughout the war?', '["Arjuna","Bhima","Dhrishtadyumna","Krishna"]'::jsonb, 2, 'Draupadi''s brother Dhrishtadyumna was the Pandava commander.'),
  (3, 'Why did Balarama not fight in the war?', '["He was injured","He had taught both Bhima and Duryodhana and would not take sides","Krishna forbade him","He was too old"]'::jsonb, 1, 'He went on a pilgrimage instead.'),
  (4, 'How is Vyasa related to both sides?', '["He is their teacher","He is the biological father of Dhritarashtra and Pandu, so grandfather to both","He is Krishna''s father","He is Bhishma''s son"]'::jsonb, 1, 'Vyasa is the author of the epic and also grandfather to the Kauravas and Pandavas.')
) as v(sort_order, question, options, correct_index, explanation)
on conflict (part_id, sort_order) do update set question = excluded.question, options = excluded.options,
  correct_index = excluded.correct_index, explanation = excluded.explanation;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mahabharata' and p.slug = 'krishna-and-the-elders') and sort_order >= 5;

-- part: road-to-war
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'road-to-war', 'What led to the war', 'Rivalry, a fire, a game of dice and 13 years of exile.', '🎲', 4
from public.ls_chapters c where c.slug = 'mahabharata'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mahabharata' and p.slug = 'road-to-war'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'concept', 'Who should be king?', 'Dhritarashtra was the elder brother but blind, so Pandu became king. After Pandu died, Dhritarashtra ruled.

That left a question with no easy answer: should the next king be Yudhishthira, eldest son of the last king, or Duryodhana, eldest son of the ruling one? Everything that follows grows from this dispute.', null::text, null::text),
  (1, 'case_study', 'The house of lac', 'Duryodhana has a palace built for the Pandavas at Varanavata out of lac and other materials that burn easily. The plan is to set it on fire with them inside.

Vidura warns them in time. They dig a tunnel, escape the fire, and go into hiding, letting the world believe they are dead.', null::text, null::text),
  (2, 'case_study', 'Indraprastha and a bitter visit', 'To keep the peace, Dhritarashtra gives the Pandavas a share of the kingdom. They build a magnificent capital, Indraprastha, and Yudhishthira performs the Rajasuya sacrifice, marking him as an emperor.

Visiting the dazzling palace, Duryodhana mistakes floor for water and water for floor, falls in, and is laughed at. His envy hardens.', null::text, null::text),
  (3, 'case_study', 'The game of dice', 'Duryodhana invites Yudhishthira to a game of dice, with Shakuni playing for him. Yudhishthira bets and loses his wealth, his kingdom, his brothers, himself, and finally Draupadi.

Draupadi is dragged into court and humiliated. Bhima vows to kill Dushasana and break Duryodhana''s thigh.', null::text, null::text),
  (4, 'number', '12 years plus 1', 'After a second game, the Pandavas must spend 12 years in exile in the forest, then one more year living in disguise. If they are discovered in that final year, the whole exile starts over.

They survive all 13 years and come back to claim their kingdom.', null::text, null::text),
  (5, 'fact', 'A year in disguise', 'The Pandavas spend the hidden year at the court of King Virata. Yudhishthira poses as a courtier, Bhima as a cook, Arjuna as Brihannala, a dance teacher, Nakula as a horse keeper, Sahadeva as a cowherd, and Draupadi as a maid.

They complete the year without being exposed.', null::text, null::text),
  (6, 'case_study', 'Five villages', 'Back from exile, the Pandavas try for peace. Krishna goes to Hastinapura as their envoy, asking in the end for just five villages, one for each brother.

Duryodhana refuses, saying he won''t give up even as much land as the point of a needle would cover. Diplomacy fails, and both sides prepare for war.', null::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mahabharata' and p.slug = 'road-to-war') and sort_order >= 7;
insert into public.ls_questions (part_id, sort_order, question, options, correct_index, explanation)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mahabharata' and p.slug = 'road-to-war'), v.sort_order, v.question, v.options, v.correct_index, v.explanation from (values
  (0, 'What was the house of lac?', '["A palace built to burn with the Pandavas inside","The Pandavas'' new capital","The hall where the dice game was played","Bhishma''s home"]'::jsonb, 0, 'Vidura''s warning let them escape through a tunnel.'),
  (1, 'What did Yudhishthira lose in the game of dice?', '["Only his gold","His kingdom only","His wealth, kingdom, brothers, himself and Draupadi","Nothing; he won"]'::jsonb, 2, 'He staked and lost everything, ending with Draupadi.'),
  (2, 'How long was the Pandavas'' exile?', '["5 years","12 years in the forest plus 1 year in disguise","14 years in the forest","1 year in disguise only"]'::jsonb, 1, 'If found in the hidden 13th year, they would have had to start over.'),
  (3, 'Where did the Pandavas spend their year in disguise?', '["Dwaraka","Indraprastha","King Virata''s court","Panchala"]'::jsonb, 2, 'They lived at Virata''s court under false identities.'),
  (4, 'What did the Pandavas finally ask for to avoid war?', '["Half the kingdom","Five villages","Hastinapura","Only an apology"]'::jsonb, 1, 'Duryodhana refused even that, saying not even a needle-point of land.')
) as v(sort_order, question, options, correct_index, explanation)
on conflict (part_id, sort_order) do update set question = excluded.question, options = excluded.options,
  correct_index = excluded.correct_index, explanation = excluded.explanation;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mahabharata' and p.slug = 'road-to-war') and sort_order >= 5;

-- part: eighteen-days
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'eighteen-days', 'Inside the 18-day war', 'Who led each phase, the turning points, and how it ended.', '🔥', 5
from public.ls_chapters c where c.slug = 'mahabharata'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mahabharata' and p.slug = 'eighteen-days'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'concept', 'Four Kaurava commanders', 'The Kaurava army changed commanders as each one fell:

1. **Bhishma**, days 1 to 10
2. **Drona**, days 11 to 15
3. **Karna**, days 16 and 17
4. **Shalya**, day 18

On the other side, Dhrishtadyumna led the Pandava army the whole time.', null::text, null::text),
  (1, 'case_study', 'Day 10: Bhishma falls', 'Bhishma is nearly unstoppable, and his power over his own death means he can''t simply be killed. He tells the Pandavas he will not fight Shikhandi.

On day 10, Arjuna shoots from behind Shikhandi. Bhishma falls, pierced by so many arrows that he lies on a bed of them, choosing to live on until the sun turns north.', null::text, null::text),
  (2, 'case_study', 'Day 13: Abhimanyu in the wheel', 'Drona arranges his army in the chakravyuha, a spiral formation. Abhimanyu, Arjuna''s teenage son, knows how to break in but not how to get out.

He forces his way in, the gap closes behind him, and he is surrounded and killed by several warriors at once. Arjuna avenges him the next day.', null::text, null::text),
  (3, 'case_study', 'Day 14 night: Ghatotkacha', 'Fighting continues into the night, when Bhima''s son Ghatotkacha and his rakshasa powers wreak havoc on the Kauravas.

Desperate, Karna uses the one-time weapon Indra gave him, which he had been saving for Arjuna. It kills Ghatotkacha, and Arjuna is now safe from it.', null::text, null::text),
  (4, 'case_study', 'Day 15: "Ashwatthama is dead"', 'To stop Drona, Bhima kills an elephant named Ashwatthama and announces it. Drona asks Yudhishthira, who never lies, if it''s true.

Yudhishthira says Ashwatthama is dead, adding only quietly that it was an elephant. Grief-stricken, Drona lays down his weapons and Dhrishtadyumna kills him.', null::text, null::text),
  (5, 'case_study', 'Day 17: Karna''s last fight', 'Karna and Arjuna finally meet in their great duel. During the fight, Karna''s chariot wheel sinks into the earth and he steps down to free it.

When Karna appeals to the rules of fair combat, Krishna reminds him of Draupadi''s humiliation and Abhimanyu''s death, which Karna took part in. Arjuna shoots, and Karna falls.', null::text, null::text),
  (6, 'case_study', 'Day 18 and after', 'Shakuni and Shalya are killed, and Duryodhana hides in a lake. In his final mace duel with Bhima, Bhima strikes his thigh, below the waist, fulfilling his old vow.

That night Ashwatthama raids the Pandava camp. Only a handful of warriors survive the war. Yudhishthira becomes king, at a terrible cost.', null::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mahabharata' and p.slug = 'eighteen-days') and sort_order >= 7;
insert into public.ls_questions (part_id, sort_order, question, options, correct_index, explanation)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mahabharata' and p.slug = 'eighteen-days'), v.sort_order, v.question, v.options, v.correct_index, v.explanation from (values
  (0, 'Who led the Kaurava army for the first ten days?', '["Drona","Karna","Bhishma","Duryodhana"]'::jsonb, 2, 'Bhishma led until he fell on day 10.'),
  (1, 'How did the Pandavas get past Bhishma?', '["They poisoned his food","Arjuna shot from behind Shikhandi, whom Bhishma would not fight","Krishna fought him directly","He surrendered"]'::jsonb, 1, 'Bhishma had said he would not fight Shikhandi.'),
  (2, 'What trapped Abhimanyu?', '["A flood","The chakravyuha formation, which he could enter but not exit","A curse from Drona","Karna''s divine weapon"]'::jsonb, 1, 'He knew how to break in but not how to get out.'),
  (3, 'Why did Drona lay down his weapons?', '["He was told his son Ashwatthama was dead","Duryodhana ordered him to","Krishna asked him to","He was wounded by Arjuna"]'::jsonb, 0, 'An elephant named Ashwatthama had been killed, and Yudhishthira''s answer let Drona believe it was his son.'),
  (4, 'Whom did Karna use Indra''s one-time weapon on?', '["Arjuna","Ghatotkacha","Bhima","Abhimanyu"]'::jsonb, 1, 'He was forced to use it on Ghatotkacha, which left Arjuna safe from it.')
) as v(sort_order, question, options, correct_index, explanation)
on conflict (part_id, sort_order) do update set question = excluded.question, options = excluded.options,
  correct_index = excluded.correct_index, explanation = excluded.explanation;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'mahabharata' and p.slug = 'eighteen-days') and sort_order >= 5;

commit;

-- Generated from content/09-krishnas-teachings.json by "npm run content:sql". Safe to run more than once.
-- Paste into Supabase: SQL Editor > New query > Run.
begin;

insert into public.ls_chapters (slug, title, description, emoji, color, sort_order)
values ('krishnas-teachings', 'What Krishna Teaches', 'The Bhagavad Gita''s ideas on work, the mind, decisions and loss, in plain words, with the verse each one comes from.', '🦚', '#4f46e5', 9)
on conflict (slug) do update set title = excluded.title, description = excluded.description,
  emoji = excluded.emoji, color = excluded.color, sort_order = excluded.sort_order;

-- part: do-your-work
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'do-your-work', 'Do your work, let go of the result', 'Karma yoga: acting fully without being ruled by the outcome.', '🎯', 0
from public.ls_chapters c where c.slug = 'krishnas-teachings'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'krishnas-teachings' and p.slug = 'do-your-work'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'concept', 'Your right is to the work', 'The Gita''s most famous line (2.47): you have a right to your actions, but never to their fruits. Don''t make the result your reason for acting, and don''t let that turn you toward doing nothing either.

It isn''t saying results don''t matter. It''s saying your effort is the part you control, so put yourself there.', 'In Sanskrit it begins *karmany evadhikaras te, ma phaleshu kadachana*. The verse has four parts: your right is to action; never to its fruits; don''t let the fruit be your motive; and don''t be attached to inaction. That last part matters. The Gita is not advice to stop caring and stop trying. It''s advice to give full effort while loosening your grip on how it turns out, so fear of failure doesn''t freeze you and success doesn''t swell you.'::text, null::text),
  (1, 'concept', 'Steady in success and failure', 'In the next verse (2.48), Krishna tells Arjuna to act while staying even-minded about success and failure, abandoning attachment.

He defines yoga itself this way: *samatvam yoga uchyate*, evenness of mind is called yoga. You still want to win. You just don''t let winning or losing knock you off balance.', null::text, null::text),
  (2, 'concept', 'Yoga is skill in action', 'Verse 2.50 gives another short definition: *yogah karmasu kaushalam*, yoga is skill in action.

Here yoga isn''t about postures. It means doing your work with focus and care, from a steady mind, so the work itself becomes a practice.', null::text, null::text),
  (3, 'concept', 'Doing nothing isn''t an escape', 'Arjuna wants to walk away from the battle. Krishna tells him (3.8) to do his prescribed work, because action is better than inaction. Even keeping your own body alive needs action.

For anyone stuck: withdrawing doesn''t free you from the problem. Doing the right next thing does.', null::text, null::text),
  (4, 'concept', 'Your own path, even imperfectly', 'Verse 3.35 says it is better to follow your own duty, even imperfectly, than someone else''s done well.

The idea is called svadharma, your own role and nature. Copying someone else''s life, however impressive it looks, tends to go worse than living your own honestly.', null::text, null::text),
  (5, 'concept', 'People copy what you do', 'In 3.21, Krishna points out that whatever a great person does, others follow. The standard they set by example is the one the world takes up.

If you lead a team, raise kids, or are simply looked up to by someone, your actions teach more than your words.', null::text, null::text),
  (6, 'what_would_you_do', 'You did everything right and still lost', 'You worked hard for months on a project. It went well, but the promotion went to someone else.

You''re tempted to stop trying so hard, since effort clearly didn''t pay. What would the Gita say?', 'Verse 2.47 would say the effort was yours and the result never was. Verse 2.48 would ask you to stay steady in the loss as you would in a win. And 3.8 would warn against swinging to the other extreme, doing less, because that just trades one attachment for another. The practical move: keep doing excellent work because it''s your work, learn what you can from the decision, and let the outcome go.'::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'krishnas-teachings' and p.slug = 'do-your-work') and sort_order >= 7;
insert into public.ls_questions (part_id, sort_order, question, options, correct_index, explanation)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'krishnas-teachings' and p.slug = 'do-your-work'), v.sort_order, v.question, v.options, v.correct_index, v.explanation from (values
  (0, 'According to Gita 2.47, what do you have a right to?', '["The results of your work","Your actions, not their fruits","Neither actions nor results","Only success"]'::jsonb, 1, 'Your right is to the action. The result is not yours to control.'),
  (1, 'Does 2.47 tell you to stop acting since results aren''t yours?', '["Yes, withdraw from action","No, it also says don''t be attached to inaction","Only if you might fail","It doesn''t mention inaction"]'::jsonb, 1, 'The verse ends by warning against attachment to doing nothing.'),
  (2, 'How does the Gita define yoga in 2.48?', '["Physical postures","Evenness of mind","Giving up all work","Long meditation"]'::jsonb, 1, 'Samatvam yoga uchyate: evenness of mind is called yoga.'),
  (3, 'What does svadharma (3.35) mean?', '["Doing whatever earns the most","Following your own duty and nature, even imperfectly","Copying successful people","Avoiding all duties"]'::jsonb, 1, 'Better your own path imperfectly than another''s done well.'),
  (4, 'What is the point of 3.21?', '["Leaders should hide their actions","Others follow the example set by those they look up to","Only words matter","Great people need no rules"]'::jsonb, 1, 'Whatever a great person does, others follow.')
) as v(sort_order, question, options, correct_index, explanation)
on conflict (part_id, sort_order) do update set question = excluded.question, options = excluded.options,
  correct_index = excluded.correct_index, explanation = excluded.explanation;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'krishnas-teachings' and p.slug = 'do-your-work') and sort_order >= 5;

-- part: master-your-mind
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'master-your-mind', 'Master your mind', 'The mind as friend or enemy, how desire turns to ruin, and how to steady it.', '🧠', 1
from public.ls_chapters c where c.slug = 'krishnas-teachings'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'krishnas-teachings' and p.slug = 'master-your-mind'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'concept', 'Lift yourself up', 'Verse 6.5: raise yourself by your own self, and don''t let yourself sink. You alone are your own friend, and you alone can be your own enemy.

No one else can do your inner work for you. The same mind that drags you down is the one that can pull you up.', null::text, null::text),
  (1, 'concept', 'Friend or enemy', 'The following verse (6.6) explains: for someone who has mastered their mind, the mind is their best friend. For someone who hasn''t, it behaves like an enemy.

The mind doesn''t change sides by itself. Training it is what turns it from a critic into an ally.', null::text, null::text),
  (2, 'concept', 'How a thought becomes ruin', 'Verses 2.62 and 2.63 trace a chain:

1. Dwelling on something creates attachment.
2. Attachment creates desire.
3. Desire gives rise to anger.
4. Anger brings delusion, then loss of memory and judgment.
5. Lost judgment leads to ruin.

The easiest place to break the chain is at the start, at what you keep dwelling on.', null::text, null::text),
  (3, 'fact', 'Three gates', 'In 16.21, Krishna names three gates that lead a person to self-destruction: desire, anger and greed (*kama, krodha, lobha*).

His advice is simple: give up these three. Most bad decisions you regret can probably be traced through one of them.', null::text, null::text),
  (4, 'concept', 'The restless mind', 'Arjuna admits (6.34) that the mind is restless and stubborn, as hard to control as the wind. Krishna doesn''t argue. He agrees it is hard.

Then (6.35) he gives the method: *abhyasa* and *vairagya*, steady practice and letting go. Not one big effort, but repeated small ones.', null::text, null::text),
  (5, 'concept', 'Not too much, not too little', 'Verses 6.16 and 6.17 say yoga isn''t for someone who eats too much or too little, or sleeps too much or too little.

It''s for someone balanced in eating, rest, work and recreation. Extremes in either direction pull the mind off center.', null::text, null::text),
  (6, 'concept', 'This too will pass', 'In 2.14, Krishna says that heat and cold, pleasure and pain come from the senses meeting the world. They come and go and don''t last.

His advice is *titikshasva*: bear them patiently. A hard feeling is real, but it''s also temporary.', null::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'krishnas-teachings' and p.slug = 'master-your-mind') and sort_order >= 7;
insert into public.ls_questions (part_id, sort_order, question, options, correct_index, explanation)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'krishnas-teachings' and p.slug = 'master-your-mind'), v.sort_order, v.question, v.options, v.correct_index, v.explanation from (values
  (0, 'According to 6.5, who can raise you up?', '["Only a teacher","Only luck","You yourself","No one"]'::jsonb, 2, 'Raise yourself by yourself; you are your own friend and your own enemy.'),
  (1, 'In 2.62 to 2.63, what does dwelling on something lead to first?', '["Anger","Attachment","Wisdom","Peace"]'::jsonb, 1, 'Dwelling creates attachment, then desire, anger, confusion and ruin.'),
  (2, 'What are the three gates in 16.21?', '["Fear, doubt and laziness","Desire, anger and greed","Pride, envy and sloth","Hunger, thirst and sleep"]'::jsonb, 1, 'Kama, krodha and lobha: desire, anger and greed.'),
  (3, 'How does Krishna say the restless mind can be controlled (6.35)?', '["It can''t be controlled","By practice and letting go","By avoiding all people","By force of will in one attempt"]'::jsonb, 1, 'Abhyasa and vairagya: steady practice and detachment.'),
  (4, 'What does 6.16 to 6.17 recommend?', '["Fasting and little sleep","Balance in eating, sleeping, work and rest","Eating and sleeping as much as possible","Working without rest"]'::jsonb, 1, 'Yoga isn''t for extremes in either direction.')
) as v(sort_order, question, options, correct_index, explanation)
on conflict (part_id, sort_order) do update set question = excluded.question, options = excluded.options,
  correct_index = excluded.correct_index, explanation = excluded.explanation;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'krishnas-teachings' and p.slug = 'master-your-mind') and sort_order >= 5;

-- part: making-decisions
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'making-decisions', 'Making decisions', 'How Arjuna goes from frozen to clear, and what the Gita says about choosing well.', '🧭', 2
from public.ls_chapters c where c.slug = 'krishnas-teachings'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'krishnas-teachings' and p.slug = 'making-decisions'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'concept', 'Admit you''re confused', 'In 2.7, Arjuna says plainly that he is confused about what is right and his nature is overcome by weakness. He asks Krishna to tell him what is truly best.

The whole Gita starts from that moment of honesty. Admitting you don''t know, and asking for help, is the first step to a good decision.', null::text, null::text),
  (1, 'concept', 'Stand up', 'Krishna''s first response (2.3) is blunt: don''t give in to this weakness, it doesn''t suit you. Shake off this small faint-heartedness and stand up.

Before the philosophy comes a push. Sometimes the first thing a decision needs is for you to get up and face it.', null::text, null::text),
  (2, 'concept', 'A clear mind sees what to do', 'Verse 18.30 describes a clear (sattvic) intellect: it knows when to act and when to hold back, what should be done and what shouldn''t, what to fear and what not to, and what binds and what frees.

Good decisions come less from cleverness than from a mind calm enough to see these differences.', null::text, null::text),
  (3, 'concept', 'Three kinds of action', 'Verses 18.23 to 18.25 sort actions into three kinds:

1. **Clear (sattvic)**: done because it''s right, without craving the reward.
2. **Driven (rajasic)**: done for desire or ego, with great strain.
3. **Dark (tamasic)**: done from confusion, ignoring consequences and harm to others.

A quick test before deciding: which kind is this?', null::text, null::text),
  (4, 'concept', 'Speak in a way that helps', 'Verse 17.15 describes disciplined speech: words that don''t cause needless distress, and that are truthful, pleasant and beneficial.

When a decision involves a hard conversation, all four still apply. True isn''t enough on its own; it should also help.', null::text, null::text),
  (5, 'fact', 'Krishna hands the choice back', 'After 17 chapters of teaching, Krishna says (18.63): I have told you this wisdom. Reflect on it fully, then do as you wish.

He doesn''t order Arjuna. He gives him understanding and leaves the decision with him. The best guidance helps you choose; it doesn''t choose for you.', null::text, null::text),
  (6, 'what_would_you_do', 'Two good paths, one choice', 'You have two good options. One is safe and expected. The other fits who you are but scares you.

You''ve been going back and forth for weeks and can''t move. How might the Gita help?', 'Start like Arjuna in 2.7: name the confusion and talk it through with someone you trust. Use 3.35 to ask which path is truly yours rather than the one that looks better on paper. Check the motive with 18.23 to 18.25: is it clear, driven by ego, or avoiding something? Then follow 18.63: reflect fully, and decide. Whichever you pick, 2.47 still applies: commit to the work and let go of guaranteeing the result.'::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'krishnas-teachings' and p.slug = 'making-decisions') and sort_order >= 7;
insert into public.ls_questions (part_id, sort_order, question, options, correct_index, explanation)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'krishnas-teachings' and p.slug = 'making-decisions'), v.sort_order, v.question, v.options, v.correct_index, v.explanation from (values
  (0, 'What does Arjuna do in 2.7 that starts the teaching?', '["He attacks the Kauravas","He admits he''s confused and asks Krishna for guidance","He leaves the battlefield","He prays for victory"]'::jsonb, 1, 'His honest admission of confusion opens the door to Krishna''s teaching.'),
  (1, 'What is Krishna''s first message to Arjuna in 2.3?', '["Go home","Don''t give in to weakness; stand up","Pray before you fight","Ask your elders"]'::jsonb, 1, 'Shake off faint-heartedness and stand up.'),
  (2, 'What marks a sattvic (clear) action in 18.23?', '["Done with great strain for fame","Done because it''s right, without craving the reward","Done out of confusion","Done to harm a rival"]'::jsonb, 1, 'Driven actions are rajasic; actions from confusion are tamasic.'),
  (3, 'What does Krishna say in 18.63?', '["Obey me without question","Reflect on this fully, then do as you wish","Never decide alone","Let fate decide"]'::jsonb, 1, 'He gives the understanding and leaves the choice to Arjuna.'),
  (4, 'According to 17.15, good speech is:', '["Always blunt, whatever the cost","Truthful, pleasant, beneficial and not needlessly distressing","Pleasant even if untrue","As short as possible"]'::jsonb, 1, 'All four together: true, kind, helpful and not causing needless distress.')
) as v(sort_order, question, options, correct_index, explanation)
on conflict (part_id, sort_order) do update set question = excluded.question, options = excluded.options,
  correct_index = excluded.correct_index, explanation = excluded.explanation;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'krishnas-teachings' and p.slug = 'making-decisions') and sort_order >= 5;

-- part: facing-loss
insert into public.ls_parts (chapter_id, parent_part_id, slug, title, description, emoji, sort_order)
select c.id, null, 'facing-loss', 'Facing loss and change', 'What Krishna tells a grieving Arjuna about death, change and inner steadiness.', '🌅', 3
from public.ls_chapters c where c.slug = 'krishnas-teachings'
on conflict (chapter_id, slug) do update set parent_part_id = excluded.parent_part_id, title = excluded.title,
  description = excluded.description, emoji = excluded.emoji, sort_order = excluded.sort_order;
insert into public.ls_cards (part_id, sort_order, kind, title, body, deep_dive, video_url)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'krishnas-teachings' and p.slug = 'facing-loss'), v.sort_order, v.kind, v.title, v.body, v.deep_dive, v.video_url from (values
  (0, 'concept', 'Childhood, youth, old age', 'Verse 2.13: just as the self passes through childhood, youth and old age in this body, it passes into another body. The wise aren''t confused by this.

You are not the same body you were at five, yet you''re still you. Krishna uses that everyday change to point at something deeper that continues.', null::text, null::text),
  (1, 'concept', 'Never born, never dies', 'Verse 2.20 describes the self, the atman: it is never born and never dies. It did not come into being and will not cease to be. It is not killed when the body is killed.

This is the Gita''s central answer to Arjuna''s grief: what is truly you doesn''t end.', null::text, null::text),
  (2, 'concept', 'Like changing clothes', 'Verse 2.22 gives one of the Gita''s best-known images: as a person throws off worn-out clothes and puts on new ones, the embodied self leaves worn-out bodies and takes on new ones.

For the Gita, death is a change of clothing, not an ending of the one who wears it.', null::text, null::text),
  (3, 'concept', 'What is certain', 'Verse 2.27: for one who is born, death is certain, and for one who dies, birth is certain. So don''t grieve over what can''t be avoided.

It isn''t asking you to feel nothing. It''s asking you not to fight what cannot change, so your energy goes to what can.', null::text, null::text),
  (4, 'concept', 'Whenever goodness fades', 'In 4.7 and 4.8, Krishna says that whenever dharma (righteousness) declines and adharma rises, he manifests himself, to protect the good and restore dharma, age after age.

For many readers, it''s a promise that no dark period is the final word.', null::text, null::text),
  (5, 'concept', 'The kind of person Krishna loves', 'Verses 12.13 and 12.14 describe the devotee dear to Krishna: free of hatred toward anyone, friendly and compassionate, without ego or possessiveness, the same in pleasure and pain, forgiving, content and steady.

Read as a checklist, it''s a quiet picture of a good person.', null::text, null::text),
  (6, 'fact', 'How it ends', 'At the close of the Gita (18.73), Arjuna says his delusion is gone and his memory restored by Krishna''s grace. His doubts are cleared, he stands firm, and he will do as Krishna says: *karishye vachanam tava*.

The man who sat down in despair stands up with clarity.', null::text, null::text)
) as v(sort_order, kind, title, body, deep_dive, video_url)
on conflict (part_id, sort_order) do update set kind = excluded.kind, title = excluded.title,
  body = excluded.body, deep_dive = excluded.deep_dive, video_url = excluded.video_url;
delete from public.ls_cards where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'krishnas-teachings' and p.slug = 'facing-loss') and sort_order >= 7;
insert into public.ls_questions (part_id, sort_order, question, options, correct_index, explanation)
select (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'krishnas-teachings' and p.slug = 'facing-loss'), v.sort_order, v.question, v.options, v.correct_index, v.explanation from (values
  (0, 'What image does 2.22 use for death?', '["A candle going out","Throwing off worn-out clothes and putting on new ones","A river reaching the sea","A long sleep"]'::jsonb, 1, 'The self leaves old bodies as a person changes worn clothes.'),
  (1, 'According to 2.20, the self (atman) is:', '["Born with the body and dies with it","Never born and never dies","Created by good deeds","Only present in the wise"]'::jsonb, 1, 'It is not killed when the body is killed.'),
  (2, 'What everyday example does 2.13 use?', '["Day and night","Passing through childhood, youth and old age","Seasons of the year","Waves on the sea"]'::jsonb, 1, 'The body changes, yet the same self continues.'),
  (3, 'What does 4.7 to 4.8 promise?', '["Wealth to the faithful","That Krishna manifests whenever dharma declines, to restore it","An end to all suffering","Victory in every war"]'::jsonb, 1, 'Age after age, to protect the good and restore righteousness.'),
  (4, 'How does Arjuna respond at the end, in 18.73?', '["He still refuses to fight","His doubts are gone and he says he will act as Krishna says","He asks for more time","He gives the decision to Yudhishthira"]'::jsonb, 1, 'Karishye vachanam tava: I will do as you say.')
) as v(sort_order, question, options, correct_index, explanation)
on conflict (part_id, sort_order) do update set question = excluded.question, options = excluded.options,
  correct_index = excluded.correct_index, explanation = excluded.explanation;
delete from public.ls_questions where part_id = (select p.id from public.ls_parts p join public.ls_chapters c on c.id = p.chapter_id where c.slug = 'krishnas-teachings' and p.slug = 'facing-loss') and sort_order >= 5;

commit;
