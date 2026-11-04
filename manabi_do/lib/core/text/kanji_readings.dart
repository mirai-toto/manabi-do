/// How many on'yomi or kun'yomi a reading list shows before it stops.
const int kMaxReadingsPerType = 4;

/// The readings in a KANJIDIC2 reading field, which joins them with '、'.
List<String> parseKanjiReadings(String raw) =>
    raw.split('、').where((s) => s.trim().isNotEmpty).toList();
