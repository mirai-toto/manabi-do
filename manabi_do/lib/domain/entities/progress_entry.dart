enum ItemType { kanji, kana, exercise, lesson }

class ProgressEntry {
  final int id;
  final ItemType itemType;
  final int itemId;
  final bool isKnown;
  final DateTime toggledAt;

  const ProgressEntry({
    required this.id,
    required this.itemType,
    required this.itemId,
    required this.isKnown,
    required this.toggledAt,
  });
}
