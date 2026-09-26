import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/locale_provider.dart';
import '../../core/text/short_meaning.dart';
import '../../data/database/app_database.dart';
import '../providers/database_provider.dart';
import '../providers/drawing_settings_provider.dart';
import '../providers/writing_session_provider.dart';

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

final writingSessionServiceProvider = Provider(
  (ref) => WritingSessionService(ref),
);
