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

// Loads the lightweight kanji list (id + character) for a given level from JSON.
final kanjiListProvider = FutureProvider.family<List<KanjiListEntry>, String>((ref, level) async {
  final raw = await rootBundle.loadString('assets/data/${level.toLowerCase()}.json');
  final json = jsonDecode(raw) as Map<String, dynamic>;
  return (json['kanji'] as List<dynamic>)
      .map((e) => KanjiListEntry(
            id: e['id'] as int,
            character: e['character'] as String,
          ))
      .toList();
});

// Full kanji stream from DB — used for detail views.
final n5KanjiProvider = StreamProvider<List<Kanji>>((ref) {
  return ref.watch(databaseProvider).watchKanjiByLevel('N5');
});

final knownKanjiIdsProvider = StreamProvider<Set<int>>((ref) {
  return ref.watch(databaseProvider).watchKnownKanjiIds();
});
