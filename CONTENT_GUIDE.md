# Content guide

This file explains how to write content for Scroll to Learn. It is written so that anyone, including an AI assistant in a fresh chat, can read it and produce a valid content file without seeing the rest of the code.

## How content gets into the app

1. Write or edit a JSON file in `content/`, one file per chapter (for example `content/03-cars.json`).
2. Run `npm run content:validate` to check every file. Fix anything it reports.
3. Run `npm run content:sql` to regenerate `supabase/content/<file>.sql` and `supabase/content/_all.sql`.
4. Open the Supabase dashboard, go to **SQL Editor**, click **New query**, paste the generated `.sql` file and click **Run**.
5. Commit both the JSON and the regenerated SQL. CI fails if they are out of sync.

Never hand-write SQL for content. The generated SQL is safe to run again and again: chapters and parts are matched by `slug`, and cards and questions by their position within a part, so re-running updates rows instead of duplicating them. Cards or questions you remove from the end of a part are deleted. Parts you remove from the file are not deleted automatically, so ask Bala to delete them by hand if needed (that also removes anyone's progress on them).

If you are an AI writing content in a chat without access to the repo, output the complete JSON file in a single code block and say which filename to save it as. Bala will run the two commands and paste the SQL.

## File format

```jsonc
{
  "chapter": {
    "slug": "cars",                 // lowercase-hyphenated, unique across chapters, never change once published
    "title": "Cars",                // 40 characters or fewer
    "description": "…",             // optional, 200 characters or fewer
    "emoji": "🚗",
    "color": "#ef4444",             // 6-digit hex; drives the chapter's gradients and accents
    "sort_order": 3                 // position on the home screen
  },
  "parts": [ /* one or more parts, see below */ ]
}
```

A part is either a parent (it has `parts`, and shows a list of sub-parts) or a leaf (it has `cards`, and optionally `questions`). Never both. Parts can nest to any depth.

```jsonc
{
  "slug": "engine",                 // unique within the chapter, including nested parts
  "title": "The engine",            // 60 characters or fewer
  "description": "…",               // optional, 160 characters or fewer, shown on the tile
  "emoji": "⚙️",                    // optional
  "parts": [ /* sub-parts */ ],     // parent parts only
  "cards": [ /* leaf parts: 1 to 15 cards, 6 to 8 is ideal */ ],
  "questions": [ /* leaf parts: 5 to 8 questions, or leave out for a stub */ ]
}
```

A card:

```jsonc
{
  "kind": "concept",                // concept | case_study | number | what_would_you_do | fact
  "title": "Spark or squeeze",      // 80 characters or fewer, works as a headline
  "body": "…",                      // markdown, about 80 words or fewer (hard limit 90)
  "deep_dive": "…",                 // optional markdown, 220 words or fewer, behind a "Go deeper" button
  "video_url": "https://…"          // optional, https only; shows a "Watch" button
}
```

A question:

```jsonc
{
  "question": "How does a diesel engine ignite its fuel?",
  "options": ["…", "…", "…", "…"],  // exactly 4, all different
  "correct_index": 2,               // 0-based index into options
  "explanation": "…"                // shown after answering, 400 characters or fewer
}
```

## Card kinds and when to use each

- **concept** ("Idea"): explains one mechanism or idea. The default kind.
- **case_study** ("Case study"): a real company, person or event that faced a problem and what they did. Name who, when and what happened, then the lesson in one line.
- **number** ("By the numbers"): one striking number as the title (for example "543 seats, 272 to govern"), with the body explaining what it means. The title is shown very large, so keep it short.
- **what_would_you_do** ("What would you do?"): puts the reader in a decision. The body sets up the situation and ends with a question. The real outcome or a reasoned answer goes in `deep_dive`, which shows behind a "See what happened" button. Always include a `deep_dive` for this kind.
- **fact** ("Fact"): one surprising, verifiable fact and why it is true.

Aim for a mix within a part: mostly concepts, a number or fact for rhythm, and at most one or two case studies or decisions.

## Writing rules

- **Accuracy first.** Only include facts you are confident are true. If you are unsure of a number, date or claim, leave it out or say it more generally ("about", "most", "in the 1950s"). Never invent quotes, statistics, studies or video links. A missing video is fine; a wrong one is not.
- **One idea per card.** If a card needs "also", split it.
- **Short.** Body text of about 80 words or fewer. Two or three short paragraphs at most. Use a numbered list only for real sequences.
- **Plain and conversational.** Write like a smart friend explaining it: plain verbs, active voice, second person where it helps. No filler intros ("Have you ever wondered…"), no hype.
- **Politics and current affairs: systems and facts, not opinions.** Explain how institutions work and what happened, attributed and dated. Don't characterize parties or people, don't predict, and avoid naming current officeholders, which goes stale.
- **Wellbeing content** (the Mind chapter): practical and gentle, no medical claims. Point to common, well-known practices rather than promising outcomes.
- **Questions** test the cards, not trivia beyond them. Every question should be answerable from the part's cards. Make wrong options plausible, not silly. Vary which letter is correct. The explanation says why the answer is right in one or two sentences.

## Complete example file

This file passes validation as-is.

```json
{
  "chapter": {
    "slug": "example-kitchen-science",
    "title": "Kitchen Science",
    "description": "The chemistry and physics behind everyday cooking.",
    "emoji": "🍳",
    "color": "#f97316",
    "sort_order": 99
  },
  "parts": [
    {
      "slug": "heat",
      "title": "Heat",
      "description": "How heat moves into food.",
      "emoji": "🔥",
      "cards": [
        {
          "kind": "concept",
          "title": "Three ways heat moves",
          "body": "Heat reaches food in three ways.\n\n1. **Conduction**: direct contact, like a pan touching a steak.\n2. **Convection**: moving air or liquid, like boiling water or a fan oven.\n3. **Radiation**: energy traveling through space, like a grill's glowing coals."
        },
        {
          "kind": "fact",
          "title": "Water boils cooler on mountains",
          "body": "At sea level, water boils at 100°C. Higher up, air pressure is lower, so water boils at a lower temperature.\n\nThat's why pasta and beans take longer to cook at high altitude: the water can't get as hot."
        },
        {
          "kind": "number",
          "title": "About 140°C",
          "body": "Above roughly this temperature, the Maillard reaction speeds up: sugars and proteins in food react to create browning and hundreds of new flavor compounds.\n\nIt's why seared meat, toast and roasted coffee taste so different from boiled versions.",
          "deep_dive": "The Maillard reaction is named after Louis-Camille Maillard, a French chemist who described it in the early 1900s. It is different from caramelization, which is sugar alone breaking down at high heat."
        },
        {
          "kind": "what_would_you_do",
          "title": "Your steak won't brown",
          "body": "You put a steak in a hot pan, but it turns grey and sits in a puddle of liquid instead of browning.\n\nWhat would you change?",
          "deep_dive": "Usually the surface is too wet or the pan is too crowded, so the meat steams at around 100°C instead of browning. Pat the steak dry, let the pan get hotter, and cook fewer pieces at a time."
        },
        {
          "kind": "concept",
          "title": "Resting meat",
          "body": "When you take meat off the heat, it keeps cooking for a few minutes as heat moves from the hot outside to the cooler center.\n\nResting lets that finish and gives the juices time to settle, so less runs out when you cut it."
        },
        {
          "kind": "fact",
          "title": "Salt doesn't make water boil much faster",
          "body": "Adding salt to water actually raises its boiling point slightly, and only by a tiny amount at normal cooking quantities.\n\nCooks salt pasta water for flavor, not speed."
        }
      ],
      "questions": [
        {
          "question": "Boiling pasta in water is mainly an example of:",
          "options": ["Conduction", "Convection", "Radiation", "Fermentation"],
          "correct_index": 1,
          "explanation": "Moving water carries heat to the pasta, which is convection."
        },
        {
          "question": "Why do beans take longer to cook at high altitude?",
          "options": [
            "The air is colder",
            "Water boils at a lower temperature",
            "Gas burners are weaker",
            "Beans are drier there"
          ],
          "correct_index": 1,
          "explanation": "Lower air pressure means water boils below 100°C, so it can't get as hot."
        },
        {
          "question": "What does the Maillard reaction produce?",
          "options": [
            "Steam",
            "Browning and new flavor compounds",
            "Salt crystals",
            "Melted fat only"
          ],
          "correct_index": 1,
          "explanation": "Sugars and proteins react at high heat to brown food and create new flavors."
        },
        {
          "question": "Your steak is steaming instead of browning. What usually helps?",
          "options": [
            "Add more oil and cover the pan",
            "Pat it dry and cook fewer pieces in a hotter pan",
            "Add water to the pan",
            "Lower the heat"
          ],
          "correct_index": 1,
          "explanation": "A dry surface and a hot, uncrowded pan let it get above 100°C and brown."
        },
        {
          "question": "Why do cooks salt pasta water?",
          "options": [
            "To make it boil much faster",
            "To stop pasta sticking",
            "For flavor",
            "To soften the water"
          ],
          "correct_index": 2,
          "explanation": "Salt raises the boiling point only slightly; it's there for taste."
        }
      ]
    }
  ]
}
```
