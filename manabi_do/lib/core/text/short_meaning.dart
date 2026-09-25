/// How many senses a practice card keeps.
const int kMaxCardGlosses = 3;

/// Length past which a card drops another sense, so that one long first gloss
/// ("eastern Japan (esp. Kamakura or Edo, from perspective of Kyoto or Nara)")
/// does not fill the card on its own. Never cuts below one sense.
const int _maxLength = 80;

/// The first few senses of [meaning], for a practice card.
///
/// Dictionary entries run long — 暇 carries two dozen senses — and a card only
/// has to be recognisable, so the tail is dropped and marked with an ellipsis.
/// Lists and detail screens keep the full text.
///
/// Vocabulary separates senses with `;` and uses `,` inside a single sense
/// ("to attain (nirvana, enlightenment, etc.)"); kanji has only `,`. The
/// separator found is the one used to rejoin, so nothing reads as a sense
/// boundary that wasn't one.
String shortMeaning(String meaning, {int max = kMaxCardGlosses}) {
  final separator = meaning.contains(';') ? ';' : ',';
  final glosses = meaning
      .split(separator)
      .map((gloss) => gloss.trim())
      .where((gloss) => gloss.isNotEmpty)
      .toList();
  if (glosses.length <= max) return meaning.trim();

  final kept = glosses.take(max).toList();
  while (kept.length > 1 && kept.join('$separator ').length > _maxLength) {
    kept.removeLast();
  }
  return '${kept.join('$separator ')}…';
}
