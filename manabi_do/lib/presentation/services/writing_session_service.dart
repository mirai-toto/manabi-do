import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/locale_provider.dart';
import '../../data/database/app_database.dart';
import '../providers/database_provider.dart';
import '../providers/drawing_settings_provider.dart';
import '../providers/writing_session_provider.dart';

class WritingSessionService {
  const WritingSessionService();

  Future<List<(Kanji, String)>> buildQueue({
    required Ref ref,
    required WritingSessionArgs args,
  }) async {
    final db = ref.read(databaseProvider);
    final settings = ref.read(drawingSettingsProvider);
    final locale = ref.read(localeProvider).languageCode;

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
            translations[k.id]?.isNotEmpty == true
                ? translations[k.id]!
                : k.meaning,
          ),
        )
        .toList();
  }
}

const writingSessionService = WritingSessionService();

final writingSessionServiceProvider = Provider(
  (_) => const WritingSessionService(),
);
