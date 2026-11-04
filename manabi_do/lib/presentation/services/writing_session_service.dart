import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/locale_provider.dart';
import '../../core/text/short_meaning.dart';
import '../../data/database/app_database.dart';
import '../providers/database_provider.dart';
import '../providers/drawing_settings_provider.dart';

/// Which kanji a writing session draws: a whole level, or some of it.
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

class WritingSessionService {
  final Ref _ref;

  const WritingSessionService(this._ref);

  Future<List<(Kanji, String)>> buildQueue({
    required WritingSessionArgs args,
  }) async {
    final db = _ref.read(databaseProvider);
    final settings = _ref.read(drawingSettingsProvider);
    final locale = _ref.read(localeProvider).languageCode;

    final all = await db.getKanjiByLevel(args.level);
    final kanji = args.kanjiIds != null
        ? all.where((k) => args.kanjiIds!.contains(k.id)).toList()
        : all;
    kanji.shuffle(Random());

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
            shortMeaning(
              translations[k.id]?.isNotEmpty == true
                  ? translations[k.id]!
                  : k.meaning,
            ),
          ),
        )
        .toList();
  }
}

final writingSessionServiceProvider = Provider<WritingSessionService>(
  (ref) => WritingSessionService(ref),
);
