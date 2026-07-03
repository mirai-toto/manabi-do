import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/locale_provider.dart';
import '../../data/database/app_database.dart';
import 'database_provider.dart';
import 'drawing_settings_provider.dart';

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
      _listEquals(other.kanjiIds, kanjiIds);

  @override
  int get hashCode =>
      Object.hash(level, kanjiIds == null ? null : Object.hashAll(kanjiIds!));

  static bool _listEquals(List<int>? a, List<int>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null || a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

/// Loads and shuffles the kanji queue for a writing session.
/// autoDispose ensures the list is regenerated (and reshuffled) each time
/// the screen is entered or [ref.invalidate] is called (on restart).
final writingKanjiProvider = FutureProvider.autoDispose
    .family<List<(Kanji, String)>, WritingSessionArgs>((ref, args) async {
      final db = ref.read(databaseProvider);
      final settings = ref.read(drawingSettingsProvider);
      final locale = ref.watch(localeProvider).languageCode;
      final all = await db.getKanjiByLevel(args.level);
      final kanji = args.kanjiIds != null
          ? all.where((k) => args.kanjiIds!.contains(k.id)).toList()
          : all;
      kanji.shuffle();
      final limited = settings.sessionLength != null
          ? kanji.take(settings.sessionLength!).toList()
          : kanji;
      final translations = locale != 'en'
          ? await db.getKanjiTranslations(
              limited.map((k) => k.id).toList(),
              locale,
            )
          : <int, String>{};
      return limited
          .map(
            (k) => (
              k,
              translations[k.id]?.isNotEmpty == true
                  ? translations[k.id]!
                  : k.meaning,
            ),
          )
          .toList();
    });
