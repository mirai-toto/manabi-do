enum ExerciseType { mcq, flashcard, trueFalse, freeWriting, matching, ordering }

enum ExerciseSource { kana, kanji, vocabulary, grammar }

class Exercise {
  final int id;
  final String locale;
  final ExerciseType type;
  final ExerciseSource source;
  final int sourceId;
  final String prompt;
  final String answer;
  final List<String> distractors;
  final int? lessonId;

  const Exercise({
    required this.id,
    required this.locale,
    required this.type,
    required this.source,
    required this.sourceId,
    required this.prompt,
    required this.answer,
    required this.distractors,
    this.lessonId,
  });
}
