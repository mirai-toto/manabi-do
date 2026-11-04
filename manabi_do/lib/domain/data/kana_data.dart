class KanaEntry {
  final int id;
  final String kana;
  final String romaji;
  const KanaEntry({required this.id, required this.kana, required this.romaji});
}

class KanaRow {
  final String label;
  final String group;
  final List<KanaEntry?> entries;
  const KanaRow({
    required this.label,
    required this.group,
    required this.entries,
  });

  List<KanaEntry> get kana => entries.whereType<KanaEntry>().toList();
}

class KanaData {
  final int total;
  final List<KanaRow> hiragana;
  final List<KanaRow> katakana;

  const KanaData({
    required this.total,
    required this.hiragana,
    required this.katakana,
  });
}
