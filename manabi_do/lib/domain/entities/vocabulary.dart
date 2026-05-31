class Vocabulary {
  final int id;
  final String word;
  final String reading;
  final String meaning;
  final String jlptLevel;
  final String partOfSpeech;
  final int? kanjiId;

  const Vocabulary({
    required this.id,
    required this.word,
    required this.reading,
    required this.meaning,
    required this.jlptLevel,
    required this.partOfSpeech,
    this.kanjiId,
  });
}
