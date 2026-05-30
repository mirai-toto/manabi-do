enum KanaType { hiragana, katakana }

class Kana {
  final int id;
  final String character;
  final String romaji;
  final KanaType type;
  final String row;

  const Kana({
    required this.id,
    required this.character,
    required this.romaji,
    required this.type,
    required this.row,
  });
}
