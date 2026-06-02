import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import 'database_provider.dart';

class KanjiListEntry {
  final int id;
  final String character;
  const KanjiListEntry({required this.id, required this.character});
}

class KanjiLevelData {
  final String level;
  final String label;
  final List<KanjiListEntry> kanji;
  const KanjiLevelData({required this.level, required this.label, required this.kanji});
  int get total => kanji.length;
}

// Loads level metadata + kanji list (id + character) from JSON.
final kanjiListProvider = FutureProvider.family<KanjiLevelData, String>((ref, level) async {
  final raw = await rootBundle.loadString('assets/data/${level.toLowerCase()}.json');
  final json = jsonDecode(raw) as Map<String, dynamic>;
  return KanjiLevelData(
    level: json['level'] as String,
    label: json['label'] as String,
    kanji: (json['kanji'] as List<dynamic>)
        .map((e) => KanjiListEntry(id: e['id'] as int, character: e['character'] as String))
        .toList(),
  );
});

final kanjiDetailProvider = StreamProvider.family<Kanji?, int>((ref, id) {
  return ref.watch(databaseProvider).watchKanjiById(id);
});

final knownKanjiIdsProvider = StreamProvider<Set<int>>((ref) {
  return ref.watch(databaseProvider).watchKnownKanjiIds();
});
