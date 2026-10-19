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
