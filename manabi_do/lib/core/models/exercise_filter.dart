/// Which kinds of exercise a free-practice session is allowed to ask.
///
/// Chosen on the practice screen before the session starts, and read by the
/// session service when it picks a type per item.
enum ExerciseFilter { mixed, flashcardOnly, mcqOnly }
