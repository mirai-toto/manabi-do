import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart';
import 'database_provider.dart';

final knownHiraganaProvider = StreamProvider<Set<int>>((ref) =>
    ref.watch(databaseProvider).watchKnownKanaIds('hiragana'));

final knownKatakanaProvider = StreamProvider<Set<int>>((ref) =>
    ref.watch(databaseProvider).watchKnownKanaIds('katakana'));

// Map<kanaId, Card> — reloaded whenever the SRS session provider invalidates
final kanaSrsCardsProvider = FutureProvider.family<Map<int, Card>, String>(
  (ref, type) => ref.watch(databaseProvider).getAllSrsCardsForType(type),
);
