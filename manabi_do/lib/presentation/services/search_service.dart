import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/text/search_rank.dart';
import '../../data/database/app_database.dart';

/// How many results a search returns. A one-letter query matches thousands of
/// entries and nobody scrolls that far.
const int kSearchResultLimit = 50;

/// The text a search ranks an entry against.
typedef SearchFields = ({
  String japanese,
  List<String> readings,
  String meaning,
  String level,
});

/// Orders search matches. The database decides which rows contain the query;
/// this decides which of them answer it.
///
/// Both searches share one policy — best match first, ties to the easier level,
/// capped — so neither can drift away from the other.
class SearchService {
  const SearchService();

  Future<List<VocabularyEntry>> vocabulary(AppDatabase db, String query) async {
    final candidates = await db.searchVocabularyCandidates(query);
    return _ranked(
      query: query,
      candidates: candidates,
      fieldsOf: (entry) => (
        japanese: entry.word,
        readings: [entry.reading],
        meaning: entry.meaning,
        level: entry.jlptLevel,
      ),
      // Alphabetical, so equally good matches keep a stable order.
      tiebreak: (a, b) => a.word.compareTo(b.word),
    );
  }

  Future<List<Kanji>> kanji(AppDatabase db, String query) async {
    final candidates = await db.searchKanjiCandidates(query);
    return _ranked(
      query: query,
      candidates: candidates,
      fieldsOf: (kanji) => (
        japanese: kanji.character,
        readings: [kanji.onReading, kanji.kunReading],
        meaning: kanji.meaning,
        level: kanji.jlptLevel,
      ),
      tiebreak: (a, b) => a.id.compareTo(b.id),
    );
  }
}

List<T> _ranked<T>({
  required String query,
  required List<T> candidates,
  required SearchFields Function(T) fieldsOf,
  required Comparator<T> tiebreak,
}) {
  final scored =
      candidates.map((candidate) {
        final fields = fieldsOf(candidate);
        return (
          item: candidate,
          rank: searchRank(
            query: query,
            japanese: fields.japanese,
            readings: fields.readings,
            meaning: fields.meaning,
          ),
          level: _levelRank(fields.level),
        );
      }).toList()..sort((a, b) {
        final byRank = a.rank.compareTo(b.rank);
        if (byRank != 0) return byRank;
        final byLevel = a.level.compareTo(b.level);
        return byLevel != 0 ? byLevel : tiebreak(a.item, b.item);
      });

  return scored
      .take(kSearchResultLimit)
      .map((candidate) => candidate.item)
      .toList();
}

/// Easiest first. Searching "water" should surface 水 above the rare N1 entries
/// whose meanings happen to mention water.
int _levelRank(String level) => switch (level) {
  'N5' => 0,
  'N4' => 1,
  'N3' => 2,
  'N2' => 3,
  'N1' => 4,
  _ => 5,
};

const searchService = SearchService();

final searchServiceProvider = Provider((_) => const SearchService());
