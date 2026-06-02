class KanaEntry {
  final String kana;
  final String romaji;
  const KanaEntry(this.kana, this.romaji);

  factory KanaEntry.fromJson(Map<String, dynamic> json) =>
      KanaEntry(json['kana'] as String, json['romaji'] as String);
}

class KanaRow {
  final String label;
  final String group;
  final List<KanaEntry?> entries;
  const KanaRow({required this.label, required this.group, required this.entries});

  List<KanaEntry> get kana => entries.whereType<KanaEntry>().toList();

  factory KanaRow.fromJson(Map<String, dynamic> json) => KanaRow(
        label: json['label'] as String,
        group: json['group'] as String,
        entries: (json['entries'] as List<dynamic>)
            .map((e) => e == null ? null : KanaEntry.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class KanaGroup {
  final String id;
  final String label;
  const KanaGroup({required this.id, required this.label});

  factory KanaGroup.fromJson(Map<String, dynamic> json) =>
      KanaGroup(id: json['id'] as String, label: json['label'] as String);
}

class KanaData {
  final int hiraganaCount;
  final int katakanaCount;
  final int total;
  final List<KanaGroup> groups;
  final List<KanaRow> hiragana;
  final List<KanaRow> katakana;

  const KanaData({
    required this.hiraganaCount,
    required this.katakanaCount,
    required this.total,
    required this.groups,
    required this.hiragana,
    required this.katakana,
  });

  factory KanaData.fromJson(Map<String, dynamic> json) {
    final meta = json['metadata'] as Map<String, dynamic>;
    return KanaData(
      hiraganaCount: meta['hiragana_count'] as int,
      katakanaCount: meta['katakana_count'] as int,
      total: meta['total'] as int,
      groups: (meta['groups'] as List<dynamic>)
          .map((g) => KanaGroup.fromJson(g as Map<String, dynamic>))
          .toList(),
      hiragana: (json['hiragana'] as List<dynamic>)
          .map((r) => KanaRow.fromJson(r as Map<String, dynamic>))
          .toList(),
      katakana: (json['katakana'] as List<dynamic>)
          .map((r) => KanaRow.fromJson(r as Map<String, dynamic>))
          .toList(),
    );
  }
}
