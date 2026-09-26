import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' show Card;

import '../../core/srs/srs_queue.dart';
import '../../data/database/app_database.dart';
import '../providers/database_provider.dart';

/// Builds the review queue for a practice session.
///
/// Which items are due and how many new ones a learner gets today is teaching
/// policy, so it lives here rather than in the query layer. The database only
/// supplies the rows: the items, their SRS cards, and how many were first seen
/// today.
class SrsQueueService {
  final AppDatabase _db;

  const SrsQueueService(this._db);

  Future<List<(Kana, Card?)>> kana(
    String type, {
    int newCardLimit = 10,
  }) async => _queue(
    itemType: type,
    items: await _db.getKanaByType(type),
    idOf: (kana) => kana.id,
    newCardLimit: newCardLimit,
  );

  Future<List<(Kanji, Card?)>> kanji(
    String level, {
    int newCardLimit = 10,
  }) async => _queue(
    itemType: 'kanji',
    items: await _db.getKanjiByLevel(level),
    idOf: (kanji) => kanji.id,
    newCardLimit: newCardLimit,
  );

  Future<List<(VocabularyEntry, Card?)>> vocabulary(
    String level, {
    int newCardLimit = 10,
  }) async => _queue(
    itemType: 'vocabulary',
    items: await _db.getVocabularyByLevel(level),
    idOf: (entry) => entry.id,
    newCardLimit: newCardLimit,
  );

  /// Due hiragana and katakana together, sharing one new-card budget so the
  /// daily allowance is not handed out twice.
  Future<List<(Kana, Card?)>> allDueKana({int newCardLimit = 0}) async {
    final hiragana = await _db.getKanaByType('hiragana');
    final katakana = await _db.getKanaByType('katakana');
    final due = [
      ...await _queue(
        itemType: 'hiragana',
        items: hiragana,
        idOf: (kana) => kana.id,
        newCardLimit: 0,
      ),
      ...await _queue(
        itemType: 'katakana',
        items: katakana,
        idOf: (kana) => kana.id,
        newCardLimit: 0,
      ),
    ];
    if (newCardLimit <= 0) return due;

    final remaining = remainingNewCards(
      dailyLimit: newCardLimit,
      seenToday:
          await _db.countSeenToday('hiragana') +
          await _db.countSeenToday('katakana'),
    );
    if (remaining == 0) return due;

    // Hiragana first, katakana with whatever the budget has left.
    final freshHiragana = unseenItems(
      items: hiragana,
      cards: await _db.getAllSrsCardsForType('hiragana'),
      idOf: (kana) => kana.id,
      limit: remaining,
    );
    final freshKatakana = unseenItems(
      items: katakana,
      cards: await _db.getAllSrsCardsForType('katakana'),
      idOf: (kana) => kana.id,
      limit: remaining - freshHiragana.length,
    );

    return [...due, ...freshHiragana, ...freshKatakana];
  }

  /// Due kanji from every level. New cards come from the easiest level that
  /// still has unseen kanji, so a learner is not handed N1 kanji while N5 is
  /// unfinished.
  Future<List<(Kanji, Card?)>> allDueKanji({int newCardLimit = 0}) async {
    final now = DateTime.now();
    final allKanji = await _db.getAllKanji();
    final cards = await _db.getAllSrsCardsForType('kanji');

    final due = <(Kanji, Card?)>[];
    final unseenByLevel = <String, List<Kanji>>{};
    for (final kanji in allKanji) {
      final card = cards[kanji.id];
      if (card == null) {
        (unseenByLevel[kanji.jlptLevel] ??= []).add(kanji);
      } else if (!card.due.isAfter(now)) {
        due.add((kanji, card));
      }
    }

    if (newCardLimit <= 0) return due;
    final fresh = newCardsFromEasiestLevel(
      unseenByLevel,
      remainingNew: remainingNewCards(
        dailyLimit: newCardLimit,
        seenToday: await _db.countSeenToday('kanji'),
      ),
    );

    return [...due, ...fresh.map((kanji) => (kanji, null as Card?))];
  }

  /// Due vocabulary across every level, for the home screen review.
  Future<List<(VocabularyEntry, Card?)>> allDueVocabulary({
    int newCardLimit = 0,
  }) async => _queue(
    itemType: 'vocabulary',
    items: await _db.getAllVocabulary(),
    idOf: (entry) => entry.id,
    newCardLimit: newCardLimit,
  );

  Future<List<(T, Card?)>> _queue<T>({
    required String itemType,
    required List<T> items,
    required int Function(T) idOf,
    required int newCardLimit,
  }) async {
    final cards = await _db.getAllSrsCardsForType(itemType);
    final seenToday = await _db.countSeenToday(itemType);
    return buildSrsQueue(
      items: items,
      cards: cards,
      idOf: idOf,
      remainingNew: remainingNewCards(
        dailyLimit: newCardLimit,
        seenToday: seenToday,
      ),
    );
  }
}

final srsQueueServiceProvider = Provider(
  (ref) => SrsQueueService(ref.read(databaseProvider)),
);
