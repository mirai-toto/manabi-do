import 'l10n.dart';
import 'package:flutter/widgets.dart';

String posLabel(String pos, BuildContext context) {
  final l = context.l10n;
  return switch (pos) {
    'noun'           => l.posNoun,
    'verb'           => l.posVerb,
    'adverb'         => l.posAdverb,
    'na-adjective'   => l.posNaAdjective,
    'i-adjective'    => l.posIAdjective,
    'no-adjective'   => l.posNoAdjective,
    'expression'     => l.posExpression,
    'conjunction'    => l.posConjunction,
    'interjection'   => l.posInterjection,
    'pronoun'        => l.posPronoun,
    'numeral'        => l.posNumeral,
    'prefix'         => l.posPrefix,
    'suffix'         => l.posSuffix,
    'particle'       => l.posParticle,
    'counter'        => l.posCounter,
    'auxiliary verb' => l.posAuxiliaryVerb,
    'auxiliary'      => l.posAuxiliary,
    'adj-pn'         => l.posPreNounAdj,
    'adj-ix'         => l.posAdjIxClass,
    'adj-f'          => l.posPrenominalAdj,
    'n-suf'          => l.posNounSuffix,
    'n-pref'         => l.posNounPrefix,
    'vs-s'           => l.posSuruSpecial,
    'vs-i'           => l.posSuruIrregular,
    _                => pos,
  };
}
