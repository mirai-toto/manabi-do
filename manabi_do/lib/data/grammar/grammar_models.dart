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

class GrammarExample {
  final String sentence;
  final String? highlight;
  final Map<String, String>? translation;

  const GrammarExample({
    required this.sentence,
    this.highlight,
    this.translation,
  });

  factory GrammarExample.fromJson(Map<String, dynamic> json) {
    return GrammarExample(
      sentence: json['sentence'] as String,
      highlight: json['highlight'] as String?,
      translation: json['translation'] == null
          ? null
          : Map<String, String>.from(json['translation'] as Map),
    );
  }
}

final class FlashcardExercise extends GrammarExercise {
  final String front;
  final Map<String, String> back;
  final GrammarExample? example;
  final bool isReversed;
  final Map<String, String>? question;

  const FlashcardExercise({
    required this.front,
    required this.back,
    this.example,
    this.isReversed = false,
    this.question,
  });

  factory FlashcardExercise.fromJson(Map<String, dynamic> json) {
    return FlashcardExercise(
      front: json['front'] as String,
      back: Map<String, String>.from(json['back'] as Map),
      example: json['example'] == null
          ? null
          : GrammarExample.fromJson(
              Map<String, dynamic>.from(json['example'] as Map),
            ),
      isReversed: json['is_reversed'] as bool? ?? false,
      question: json['question'] == null
          ? null
          : Map<String, String>.from(json['question'] as Map),
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

/// One block of a grammar lesson, parsed from the lesson's `blocks_json`.
///
/// Parsed here, once, so the widgets that draw a block receive typed fields
/// instead of reaching into a map. A type this build does not know becomes an
/// [UnknownGrammarBlock], which draws nothing: newer content must not break
/// an older app.
sealed class GrammarBlock {
  const GrammarBlock();

  factory GrammarBlock.fromJson(Map<String, dynamic> json) {
    final String type = json['type'] as String;
    return switch (type) {
      'text' => TextGrammarBlock(json['content'] as String),
      'section_title' => SectionTitleGrammarBlock(json['content'] as String),
      'pattern' => PatternGrammarBlock(_strings(json['lines'])),
      'note' => NoteGrammarBlock(json['content'] as String),
      'example_table' => ExampleTableGrammarBlock(
        columns: _strings(json['columns']),
        rows: _rows(json['rows']),
      ),
      'vocabulary_table' => VocabularyTableGrammarBlock(
        columns: _strings(json['columns']),
        rows: _rows(json['rows']),
      ),
      'conjugation_table' => ConjugationTableGrammarBlock(
        label: json['label'] as String,
        rows: _rows(json['rows']),
      ),
      'comparison' => ComparisonGrammarBlock(
        left: ComparisonSide.fromJson(json['left'] as Map<String, dynamic>),
        right: ComparisonSide.fromJson(json['right'] as Map<String, dynamic>),
      ),
      'list' => ListGrammarBlock(
        bullet: json['style'] == 'bullet',
        items: _strings(json['items']),
      ),
      'transform_cards' => TransformCardsGrammarBlock(
        (json['groups'] as List<dynamic>)
            .map((g) => TransformGroup.fromJson(g as Map<String, dynamic>))
            .toList(),
      ),
      'divider' => const DividerGrammarBlock(),
      _ => UnknownGrammarBlock(type),
    };
  }

  static List<String> _strings(Object? raw) =>
      (raw as List<dynamic>).cast<String>();

  static List<Map<String, String>> _rows(Object? raw) => (raw as List<dynamic>)
      .map((r) => Map<String, String>.from(r as Map))
      .toList();
}

final class TextGrammarBlock extends GrammarBlock {
  final String content;
  const TextGrammarBlock(this.content);
}

final class SectionTitleGrammarBlock extends GrammarBlock {
  final String content;
  const SectionTitleGrammarBlock(this.content);
}

final class PatternGrammarBlock extends GrammarBlock {
  final List<String> lines;
  const PatternGrammarBlock(this.lines);
}

final class NoteGrammarBlock extends GrammarBlock {
  final String content;
  const NoteGrammarBlock(this.content);
}

final class ExampleTableGrammarBlock extends GrammarBlock {
  final List<String> columns;
  final List<Map<String, String>> rows;
  const ExampleTableGrammarBlock({required this.columns, required this.rows});
}

final class VocabularyTableGrammarBlock extends GrammarBlock {
  final List<String> columns;
  final List<Map<String, String>> rows;
  const VocabularyTableGrammarBlock({
    required this.columns,
    required this.rows,
  });
}

final class ConjugationTableGrammarBlock extends GrammarBlock {
  final String label;
  final List<Map<String, String>> rows;
  const ConjugationTableGrammarBlock({required this.label, required this.rows});
}

final class ComparisonGrammarBlock extends GrammarBlock {
  final ComparisonSide left;
  final ComparisonSide right;
  const ComparisonGrammarBlock({required this.left, required this.right});
}

final class ListGrammarBlock extends GrammarBlock {
  final bool bullet;
  final List<String> items;
  const ListGrammarBlock({required this.bullet, required this.items});
}

final class TransformCardsGrammarBlock extends GrammarBlock {
  final List<TransformGroup> groups;
  const TransformCardsGrammarBlock(this.groups);
}

final class DividerGrammarBlock extends GrammarBlock {
  const DividerGrammarBlock();
}

final class UnknownGrammarBlock extends GrammarBlock {
  final String type;
  const UnknownGrammarBlock(this.type);
}

/// One side of a comparison block.
class ComparisonSide {
  final String label;
  final String description;
  final String exampleJp;
  final String exampleEn;

  const ComparisonSide({
    required this.label,
    required this.description,
    required this.exampleJp,
    required this.exampleEn,
  });

  factory ComparisonSide.fromJson(Map<String, dynamic> d) => ComparisonSide(
    label: d['label'] as String,
    description: d['description'] as String,
    exampleJp: d['example_jp'] as String,
    exampleEn: d['example_en'] as String,
  );
}

class TransformRow {
  final String base;
  final String? old;
  final String? newSuffix;
  final String result;
  final String? romaji;
  final String? english;

  const TransformRow({
    required this.base,
    this.old,
    this.newSuffix,
    required this.result,
    this.romaji,
    this.english,
  });

  factory TransformRow.fromJson(Map<String, dynamic> d) => TransformRow(
    base: d['base'] as String,
    old: d['old'] as String?,
    newSuffix: d['new'] as String?,
    result: d['result'] as String,
    romaji: d['romaji'] as String?,
    english: d['english'] as String?,
  );
}

class TransformGroup {
  final String label;
  final String? tag;
  final String? description;
  final String? rule;
  final List<TransformRow> rows;
  final String? note;

  const TransformGroup({
    required this.label,
    this.tag,
    this.description,
    this.rule,
    required this.rows,
    this.note,
  });

  factory TransformGroup.fromJson(Map<String, dynamic> d) => TransformGroup(
    label: d['label'] as String,
    tag: d['tag'] as String?,
    description: d['description'] as String?,
    rule: d['rule'] as String?,
    rows: (d['rows'] as List<dynamic>)
        .map((r) => TransformRow.fromJson(r as Map<String, dynamic>))
        .toList(),
    note: d['note'] as String?,
  );
}

class GrammarLesson {
  final String id;
  final String title;
  final List<GrammarBlock> blocks;
  final int difficulty;

  const GrammarLesson({
    required this.id,
    required this.title,
    required this.blocks,
    this.difficulty = 1,
  });
}
