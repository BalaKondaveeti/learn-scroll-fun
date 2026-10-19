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
