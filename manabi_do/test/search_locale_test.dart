import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manabi_do/data/database/app_database.dart';
import 'package:manabi_do/presentation/services/search_service.dart';

/// Searching ran against the English columns only, so a French reader typing
/// "feu" found nothing while "fire" worked. These run against the shipped
/// content database rather than a fixture, because the bug was in what the
/// query could reach.
void main() {
  late AppDatabase db;
  late SearchService search;

  setUpAll(() {
    final asset = File('assets/manabi_do_content.db');
    if (!asset.existsSync()) return;
    final work = File('${Directory.systemTemp.path}/search_locale.db');
    if (work.existsSync()) work.deleteSync();
    asset.copySync(work.path);
    db = AppDatabase.withExecutor(NativeDatabase(work));
    search = SearchService(db);
  });

  tearDownAll(() async {
    await db.close();
  });

  test('a French reader finds 火 by searching feu', () async {
    final results = await search.kanji('feu', locale: 'fr');
    expect(
      results.map((k) => k.character),
      contains('火'),
      reason: 'the French meaning of 火 is "feu"',
    );
  });

  test('English still works, and is not polluted by French', () async {
    final results = await search.kanji('fire', locale: 'en');
    expect(results.map((k) => k.character), contains('火'));
  });

  test('searching feu in English finds almost nothing', () async {
    // The guard that the locale is really being used: "feu" is a French word
    // and the English column has all but no trace of it.
    final results = await search.kanji('feu', locale: 'en');
    expect(results.length, lessThan(3));
  });

  test('a French reader finds 食べる by searching manger', () async {
    final results = await search.vocabulary('manger', locale: 'fr');
    expect(results.map((v) => v.word), contains('食べる'));
  });

  test('the best match comes first, scored on the French', () async {
    // 火 is exactly "feu"; 葉 merely contains "feuille". Ranking on the
    // English text would have had nothing to go on for either.
    final results = await search.kanji('feu', locale: 'fr');
    expect(results.first.character, '火');
  });
}
