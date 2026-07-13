sealed class GrammarExercise {
  const GrammarExercise();

  factory GrammarExercise.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    return switch (type) {
      'flashcard' => FlashcardExercise.fromJson(json),
      'mcq' => McqExercise.fromJson(json),
      'cloze' => ClozeExercise.fromJson(json),
      'builder' => BuilderExercise.fromJson(json),
      'error_detection' => ErrorDetectionExercise.fromJson(json),
      _ => throw ArgumentError('Unknown exercise type: $type'),
    };
  }
}

final class FlashcardExercise extends GrammarExercise {
  final String front;
  final Map<String, String> back;
  final String? example;

  const FlashcardExercise({
    required this.front,
    required this.back,
    this.example,
  });

  factory FlashcardExercise.fromJson(Map<String, dynamic> json) {
    return FlashcardExercise(
      front: json['front'] as String,
      back: Map<String, String>.from(json['back'] as Map),
      example: json['example'] as String?,
    );
  }
}

final class McqExercise extends GrammarExercise {
  final String sentence;
  final Map<String, List<String>> choices;
  final int answerIndex;

  const McqExercise({
    required this.sentence,
    required this.choices,
    required this.answerIndex,
  });

  factory McqExercise.fromJson(Map<String, dynamic> json) {
    return McqExercise(
      sentence: json['sentence'] as String,
      choices: (json['choices'] as Map).map(
        (k, v) => MapEntry(k as String, List<String>.from(v as List)),
      ),
      answerIndex: json['answer_index'] as int,
    );
  }
}

final class ClozeExercise extends GrammarExercise {
  final String sentence;
  final String answer;
  final List<String> distractors;

  const ClozeExercise({
    required this.sentence,
    required this.answer,
    required this.distractors,
  });

  factory ClozeExercise.fromJson(Map<String, dynamic> json) {
    return ClozeExercise(
      sentence: json['sentence'] as String,
      answer: json['answer'] as String,
      distractors: List<String>.from(json['distractors'] as List),
    );
  }
}

final class BuilderExercise extends GrammarExercise {
  final List<String> parts;
  final Map<String, String> translation;

  const BuilderExercise({required this.parts, required this.translation});

  factory BuilderExercise.fromJson(Map<String, dynamic> json) {
    return BuilderExercise(
      parts: List<String>.from(json['parts'] as List),
      translation: Map<String, String>.from(json['translation'] as Map),
    );
  }
}

final class ErrorDetectionExercise extends GrammarExercise {
  final String correct;
  final String wrong;
  final Map<String, String> explanation;

  const ErrorDetectionExercise({
    required this.correct,
    required this.wrong,
    required this.explanation,
  });

  factory ErrorDetectionExercise.fromJson(Map<String, dynamic> json) {
    return ErrorDetectionExercise(
      correct: json['correct'] as String,
      wrong: json['wrong'] as String,
      explanation: Map<String, String>.from(json['explanation'] as Map),
    );
  }
}

class GrammarBlock {
  final String type;
  final Map<String, dynamic> data;

  const GrammarBlock({required this.type, required this.data});

  factory GrammarBlock.fromJson(Map<String, dynamic> json) {
    return GrammarBlock(
      type: json['type'] as String,
      data: Map<String, dynamic>.from(json),
    );
  }
}

class GrammarLesson {
  final String id;
  final String title;
  final List<GrammarBlock> blocks;

  const GrammarLesson({
    required this.id,
    required this.title,
    required this.blocks,
  });

  factory GrammarLesson.fromJson(Map<String, dynamic> json) {
    return GrammarLesson(
      id: json['id'] as String,
      title: json['title'] as String,
      blocks: (json['blocks'] as List<dynamic>)
          .map((b) => GrammarBlock.fromJson(Map<String, dynamic>.from(b)))
          .toList(),
    );
  }
}
