/// Which kinds of exercise a free-practice session is allowed to ask.
///
/// Chosen on the practice screen before the session starts, and read by the
/// session service when it picks a type per item.
///
/// Sentence cloze exists for vocabulary only; kanji have no example sentences
/// to hide themselves in.
enum ExerciseFilter { mixed, flashcardOnly, mcqOnly, sentenceOnly }
