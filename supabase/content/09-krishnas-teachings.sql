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
