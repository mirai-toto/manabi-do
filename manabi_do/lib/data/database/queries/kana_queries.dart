part of '../app_database.dart';

/// Kana lookups.
extension KanaQueries on AppDatabase {
  Future<KanaData> getKanaData() async {
    final rows = await (select(
      kanas,
    )..orderBy([(k) => OrderingTerm.asc(k.id)])).get();

    final hiraganaRowOrder = <String>[];
    final katakanaRowOrder = <String>[];
    final hiraganaGroup = <String, String>{};
    final katakanaGroup = <String, String>{};
    final hiraganaSlots = <String, List<Kana?>>{};
    final katakanaSlots = <String, List<Kana?>>{};

    for (final k in rows) {
      final isHiragana = k.type == 'hiragana';
      final slotMap = isHiragana ? hiraganaSlots : katakanaSlots;
      final order = isHiragana ? hiraganaRowOrder : katakanaRowOrder;
      final groupMap = isHiragana ? hiraganaGroup : katakanaGroup;

      if (!slotMap.containsKey(k.row)) {
        slotMap[k.row] = List.filled(5, null);
        order.add(k.row);
        groupMap[k.row] = k.kanaGroup;
      }
      slotMap[k.row]![k.slot] = k;
    }

    KanaRow buildRow(String label, List<Kana?> slots, String group) => KanaRow(
      label: label,
      group: group,
      entries: slots
          .map(
            (k) => k == null
                ? null
                : KanaEntry(id: k.id, kana: k.character, romaji: k.romaji),
          )
          .toList(),
    );

    final hiragana = hiraganaRowOrder
        .map((l) => buildRow(l, hiraganaSlots[l]!, hiraganaGroup[l]!))
        .toList();
    final katakana = katakanaRowOrder
        .map((l) => buildRow(l, katakanaSlots[l]!, katakanaGroup[l]!))
        .toList();
    return KanaData(
      total: [...hiragana, ...katakana].expand((r) => r.kana).length,
      hiragana: hiragana,
      katakana: katakana,
    );
  }

  Future<int> countKanaOfType(String type) {
    final count = kanas.id.count();
    return (selectOnly(kanas)
          ..addColumns([count])
          ..where(kanas.type.equals(type)))
        .map((r) => r.read(count)!)
        .getSingle();
  }

  Future<List<Kana>> getKanaByType(String type) =>
      (select(kanas)
            ..where((k) => k.type.equals(type))
            ..orderBy([(k) => OrderingTerm.asc(k.id)]))
          .get();
}
