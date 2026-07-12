import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import '../services/writing_session_service.dart';

// ── Args ──────────────────────────────────────────────────────────────────────

class WritingSessionArgs {
  final String level;
  // Stored sorted so equality is stable regardless of Set iteration order.
  final List<int>? kanjiIds;

  WritingSessionArgs({required this.level, Set<int>? kanjiIds})
    : kanjiIds = kanjiIds == null ? null : (kanjiIds.toList()..sort());

  @override
  bool operator ==(Object other) =>
      other is WritingSessionArgs &&
      other.level == level &&
      listEquals(other.kanjiIds, kanjiIds);

  @override
  int get hashCode =>
      Object.hash(level, kanjiIds == null ? null : Object.hashAll(kanjiIds!));
}

// ── Provider ──────────────────────────────────────────────────────────────────

/// Loads and shuffles the kanji queue for a writing session.
/// autoDispose ensures the list is regenerated (and reshuffled) each time
/// the screen is entered or [ref.invalidate] is called (on restart).
final writingKanjiProvider = FutureProvider.autoDispose
    .family<List<(Kanji, String)>, WritingSessionArgs>(
      (ref, args) => ref
          .read(writingSessionServiceProvider)
          .buildQueue(ref: ref, args: args),
    );
