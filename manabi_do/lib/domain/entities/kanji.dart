class Kanji {
  final int id;
  final String character;
  final String meaning;
  final String onReading;
  final String kunReading;
  final String jlptLevel;
  final String? strokeSvg;

  const Kanji({
    required this.id,
    required this.character,
    required this.meaning,
    required this.onReading,
    required this.kunReading,
    required this.jlptLevel,
    this.strokeSvg,
  });
}
