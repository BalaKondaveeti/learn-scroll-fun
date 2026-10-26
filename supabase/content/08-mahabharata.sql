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
