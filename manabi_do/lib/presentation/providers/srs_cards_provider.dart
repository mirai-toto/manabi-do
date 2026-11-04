import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart';
import '../../data/database/app_database.dart';
import 'database_provider.dart';

/// Every SRS card of one item type ('hiragana', 'katakana', 'kanji',
/// 'vocabulary'), by item id, kept live.
final srsCardsProvider = StreamProvider.family<Map<int, Card>, String>(
  (ref, type) => ref.watch(databaseProvider).watchAllSrsCardsForType(type),
);
