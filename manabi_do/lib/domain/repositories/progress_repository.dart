import '../entities/progress_entry.dart';

abstract interface class ProgressRepository {
  Future<ProgressEntry?> get(ItemType itemType, int itemId);
  Future<void> toggle(ItemType itemType, int itemId, bool isKnown);
  Future<Map<int, bool>> getAllForType(ItemType itemType);
}
