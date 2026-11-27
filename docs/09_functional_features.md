# Functional Features — Manabi Do

What a learner can do in the app today, screen by screen. Improvement ideas live in [10_polish_backlog.md](10_polish_backlog.md).

---

## General

- Fully offline, no data collected: no account needed
- Content is shown in the app language, falling back to English when a translation is missing:
  - Applies to word meanings, example sentence translations, and kanji detail example words
  - Each fallback shows an info pill; tapping it explains the text is in English because the translation is missing
- Back navigation (intended): each tab keeps its own stack of screens; back closes one screen, then steps out of a group, then a level, then returns to the Home tab; back on Home exits the app
- Tapping the current tab in the bottom bar returns to that tab's root
- Layout:
  - Narrow screens (portrait phone): bottom navigation bar
  - 600px wide and up (landscape phone, tablet, desktop): navigation rail on the side, hidden during a practice session
  - Content sits in a centred column, at most 840px wide; on a landscape phone it fills the space beside the rail
  - Short screens: section headers shrink to one line
  - Character grids stay compact; kana rows are centred

---

## Onboarding

_Draft from the code; to review._

Shown once, on first launch (and again after a progress reset). Every choice has a default and can be changed later in Settings.

1. **Welcome**: pick the app language
2. **Why this word order**: words are taught by how often they appear in written Japanese; the first level alone covers half of everything written (shown with a bar per level)
3. **What to learn**: choose which sections show on Home (Kana, Kanji, Vocabulary)
4. **Daily pace**: set new characters and new vocabulary per day, with an estimate of minutes per day
5. **Daily reminder** (only on platforms with notifications): turn it on and pick a time, or "not now". Turning it on asks for notification permission right away

A skip button appears on the last screen only.

---

## Home

_Draft from the code; to review._

- **Header**: today's date in Japanese and in the app language, and a streak pill
- **Today's session** card:
  - Reviews due per section (Kana, Kanji, Vocabulary) and new items available
  - One button starts a combined session: everything due, then new items up to the daily limits
  - "All caught up, come back later" when nothing is due
- **Your decks**: one row per section (Kana, Kanji, Vocabulary)
  - Progress bar (known out of seen), due count, new today
  - Status pill: due count, Start (never practised), Continue, or Caught up
  - Tap a row to start a session for that section only
- **Keep learning**: resume the last grammar lesson opened, with its position in the chapter
- **This week**: one dot per day, checked on days with reviews, today ringed
- Sections hidden in Settings (or onboarding) disappear from Home
- Refreshes when the app comes back to the foreground

### Android home-screen widgets

- Reviews: due reviews, opens today's session
- Kanji of the day: rotates through the kanji being learned (N5 before any); tapping opens its kanji detail
- Streak: 20 weeks of activity
- Grammar: the lesson to continue; tapping opens it (or the Grammar tab if none started)

---

## Characters

Separate sections: Hiragana, Katakana, Kanji.

### Kana

- Grid list; progress shown by color in the grid
- Tap to hear the kana
- Kana detail: due date, progress bar, reset button
  - No "mark as known" on purpose: knowledge is only validated through sessions

### Kanji

- Split by JLPT level, then in groups of 20 so lists stay light
- Each group has its own progress bar
- Same color grid as kana for a progress overview
- Kanji detail:
  - Audio playback
  - JLPT level
  - Readings: onyomi, kunyomi
  - Animated stroke order, the stroke sequence listed below, and a practice button
  - Example words: Japanese with furigana, meaning, word type (noun, numeral, adjective, verb...), and how common it is
  - Tap a word to open its word detail

---

## Vocabulary

- 5 levels, separated by commonality
- Each level split into groups of 30 words
- Word list split by status: due today, not started, known, etc.
- Same color logic as kana and kanji
- Search bar:
  - Matches the word, its reading (typed in kana or romaji), or its meaning
  - Results ordered by commonality (most common first) and closeness to the search
  - Filter results by commonality
- Word detail:
  - The word, with audio playback (like kana and kanji)
  - List of meanings, each with its labels: transitive or intransitive, usage (colloquial, honorific, slang…), subject (computing, medicine…), dialect
  - Word type (adverb, noun, etc.)
  - Commonality
  - Example sentences: furigana and translation; tap one to open its sentence detail
- Sentence detail:
  - The sentence with furigana, the word highlighted, and its translation (English fallback pill when needed)
  - Audio playback
  - "Copy Japanese" and "Copy translation" buttons
  - Kanji in this sentence: each with meaning, reading and level; tap to open the kanji detail. Only kanji the app teaches (the 2,211 with a JLPT level) are listed
  - Kanji in the word: each listed with meaning, reading, and level; tap to open the kanji detail

---

## Grammar

_Draft from the code; to review._

- **Level selector**: Japanese Basics (language fundamentals), then JLPT N5 to N1
  - Only Basics and N5 have content so far
- **Chapter list** (per level):
  - Numbered chapter cards with title, description, lesson count, and a "done / total lessons" progress bar
  - A chapter is locked until the previous one is fully read; tapping it offers to continue anyway
- **Lesson list** (per chapter):
  - Lessons grouped under section labels; groups can be collapsed
  - Same locking as chapters, for groups and single lessons, with "continue anyway"
- **Lesson reader**:
  - Lesson content made of blocks: text, section titles, grammar patterns, notes, lists, example tables, vocabulary tables, conjugation tables, comparisons, transform cards
  - "Mark as read" toggle at the bottom; read lessons count toward progress and unlock the next step
- **Continue on Home**: opening a lesson counts as starting it, and Home offers to resume the last one
- **Practice button** (floating, on a level and on a chapter, when it has exercises):
  - Free practice over that level's or chapter's exercises; nothing is recorded in the SRS
  - Exercise types:
    - Flashcard: reveal and grade yourself, with a worked example
    - Multiple choice: "What does this sentence mean?"
    - Fill the gap: choose the word that fits the sentence
    - Build the sentence: put the scrambled parts back in order
    - Spot the error: pick the correct sentence out of two, then see an explanation

---

## Practice session

_Draft from the code; to review._

### During a session

- History button in the top bar (once something is answered): opens the session review
- Settings button in the top bar: change exercise settings without leaving the session

### Graded sessions vs. free practice

- **Graded sessions** (recorded in the SRS) start only from Home: today's session, or a deck row
- **Free practice** (nothing recorded) starts from the practice buttons inside each section:
  - Kana: a practice button per tab (Hiragana, Katakana); mixes flashcards and multiple choice over the items due and new today
  - Kanji: a practice button on a level or on a group of 20, opening a picker:
    - Free practice (mixed: flashcard, multiple choice both ways, writing)
    - Writing only
    - Flashcard only
    - Multiple choice only
  - Vocabulary: a practice button on a level or on a group of 30, opening a picker:
    - Free practice (mixed)
    - Flashcard only
    - Multiple choice only
    - Sentence only
  - Grammar: the floating practice button on a level or chapter (see Grammar)
- Kanji and vocabulary pick items at random from the level or group, up to the free practice length
- What changes in free practice:
  - Grade buttons are drawn in the level's colour instead of the grade colours, as a hint that nothing is recorded
  - Summary shows "X of Y right", no streak or schedule, and offers another round
  - Grades can't be changed in the session review

### Answering a question

- **Flashcard**: tap to reveal the answer, then grade yourself. No auto-advance
- **Multiple choice and Sentence**: tap an option; it's marked right or wrong (small pop or shake), and the correct answer is highlighted if you were wrong
  - Auto-advance on: graded automatically (right = Good, wrong = Again) and moves on after a short pause
  - Auto-advance off: the grade buttons appear and you grade yourself; multiple choice also offers a link to the item's detail
  - Auto-advance off, after answering: kanji and vocabulary options show an info icon, and tapping any option opens that kanji's or word's detail; the sentence exercise also offers "View sentence" (kana and grammar options open nothing)
- **Writing**: once all strokes are drawn
  - Auto-advance off: shows the number of wrong strokes, replays the correct stroke order if any were wrong, then grade buttons, retry, and a link to the kanji detail
  - Auto-advance on: moves on after a short pause, without showing the correction
  - Hint used: in a graded session it moves on automatically, whatever the setting (the hint gave the answer away)
- Grade buttons follow the grading setting (4 grades or 2), and each one previews when the item would come back
- Auto-advance is set per exercise type (Settings > Exercises, or the in-session sheet) and applies to graded sessions and free practice alike
- In-session settings sheet: shows the settings of the exercise types in that session; a graded session also shows grading detail and hides the free practice length

### Session review

- Every item answered so far, with a counter ("8 of 20")
- Tap an item to expand it (one open at a time):
  - What was asked, your answer and the correct answer (merged into one when you were right)
  - Long meaning lists folded after 4, with "show all"
  - For writing: number of wrong strokes
  - How well the item is known, and when it comes back
  - Change the grade (same scale as your grading setting); not offered in free practice
  - Kanji items link to the kanji detail

### End-of-session summary

- Title depends on the session:
  - Graded session: number of cards reviewed, or "Today's reviews are done" when nothing was missed
  - Free practice: "X of Y right", and a note that nothing changes the review schedule
- Time spent, how many remembered vs. to look at again
- Streak, with "come back tomorrow to make it N"
- How it went: grade breakdown
- Look again: the items missed, with what you chose
- Link to all answers (opens the session review)
- Coming back: when the cards return (later today, tomorrow, later)
- Next actions:
  - Continue reviews, when some are still due today
  - Practice the missed items again, or all of them again
  - Learn N new, when new items are ready ("Room for more?")
  - Done

---

## Settings

_Draft from the code; to review._

- **Practice** (applies to every graded session):
  - Set how many new characters and new vocabulary to learn per day
  - Grading detail: either detailed (Again / Hard / Good / Easy) or simple (Not yet / Got it); free practice always uses the simple one
- **Exercises**: one settings page per exercise type, shared by all sections; applies to both graded sessions and free practice unless noted
  - Common settings:
    - Free practice length: number of questions in a free practice session (all four types; graded sessions take everything due plus new up to the daily limits)
    - Auto-advance (all but flashcard): move on automatically and score each answer, in graded sessions and free practice
  - Flashcard (kana, kanji, vocabulary, grammar): a prompt is shown, the learner reveals the answer and grades themselves (either direction: Japanese to meaning, or meaning to Japanese)
    - Show an example sentence on the card (only grammar flashcards have one)
  - Multiple choice (kana, kanji, vocabulary, grammar): pick the right answer from a short list
    - Number of choices: 4 (default), 6, or 8
    - Furigana on the word being asked
  - Sentence (vocabulary): choose the word that fills the gap in a sentence
    - Furigana on the sentence and on the answer choices, set separately
    - Translation: always shown, shown on a button press, or never
    - Skip sentences that have no translation in the app language
  - Writing (kanji): draw the kanji from its meaning
    - How strict stroke recognition is: strict / normal / lenient
    - Hint shown: meaning, readings, or both
    - Show the kanji outline while drawing
    - Replace correct strokes with a clean reference stroke
    - Show the stroke count as a hint
- **App**:
  - Colour theme (palette picker), shown in light, dark, or following the system
  - Language
  - Home screen: choose which sections show (Kana, Kanji, Vocabulary)
- **Reminders** (Android only for now):
  - Daily reminder on/off, with a time picker; turning it on asks for notification permission
  - Warning with a shortcut to system settings when notifications are blocked
  - What the reminder says:
    - Reviews due: "N reviews due", mentioning the streak when there is one
    - Nothing due but a streak at stake: "Keep your N-day streak"
  - Skipped on days with nothing due and no streak at stake, and skipped today once you've studied
  - Scheduled locally 7 days ahead, so it keeps working if the app isn't opened
  - Tapping it opens today's session
- **About**:
  - App version
  - Open source licenses
  - Data sources
  - Send feedback (email; shows a copyable address if no mail app)
  - Support the developer (web page; shows a copyable link if no browser)
- **Reset progress**: deletes all SRS cards after a confirmation, and restarts the app from the welcome screens
