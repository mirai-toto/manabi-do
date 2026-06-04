// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Manabi Do';

  @override
  String get tagline => 'Japanisch lernen — offline, in deinem Tempo';

  @override
  String get signInWithGoogle => 'Mit Google anmelden';

  @override
  String get signInWithApple => 'Mit Apple anmelden';

  @override
  String get continueAsGuest => 'Als Gast fortfahren →';

  @override
  String get or => 'oder';

  @override
  String get sectionGrammar => 'Grammatik';

  @override
  String get sectionCharacters => 'Zeichen';

  @override
  String get sectionVocabulary => 'Vokabular';

  @override
  String get tabHiragana => 'Hiragana';

  @override
  String get tabKatakana => 'Katakana';

  @override
  String get tabKanji => 'Kanji';

  @override
  String get known => 'Gelernt';

  @override
  String get knownCheck => 'Gelernt ✓';

  @override
  String get markAsKnown => 'Als gelernt markieren';

  @override
  String get notKnown => 'Nicht gelernt';

  @override
  String get statusNotStarted => 'Nicht begonnen';

  @override
  String get exampleWords => 'Beispielwörter';

  @override
  String get readings => 'Lesungen';

  @override
  String difficultyLevel(int level) {
    return 'Schwierigkeit $level';
  }

  @override
  String chapterN(String number) {
    return 'Kapitel $number';
  }

  @override
  String nLessons(int count) {
    return '$count Lektionen';
  }

  @override
  String get multipleChoice => 'Multiple Choice';

  @override
  String get practice => 'Üben →';

  @override
  String get retry => 'Nochmal';

  @override
  String get nextLesson => 'Nächste Lektion →';

  @override
  String get correct => 'Richtig';

  @override
  String get missed => 'Falsch';

  @override
  String get markedKnown => 'Als gelernt markiert';

  @override
  String get timeSpent => 'Benötigte Zeit';

  @override
  String get flashcardDefaultPrompt => 'Was bedeutet das?';

  @override
  String get tapToReveal => 'Zum Aufdecken tippen';

  @override
  String get flashcardNotYet => '✗  Noch nicht';

  @override
  String get flashcardGotIt => '✓  Gewusst';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get navHome => 'Start';

  @override
  String get navVocab => 'Vokabeln';

  @override
  String get greetingMorning => 'Guten Morgen';

  @override
  String get greetingAfternoon => 'Guten Tag';

  @override
  String get greetingEvening => 'Guten Abend';

  @override
  String get greetingSubtitle => 'Lass uns Japanisch lernen';

  @override
  String get streakLabel => 'Tage in Folge';

  @override
  String get streakSubtitle => 'Weiter so!';

  @override
  String get comingSoon => 'Demnächst verfügbar';

  @override
  String get strokeOrderPlaceholder => '▶ Strichfolge-Animation';

  @override
  String get strokeOrder => 'Strichfolge';

  @override
  String get selectLevel => 'Niveau auswählen';

  @override
  String get onyomi => 'Onyomi';

  @override
  String get kunyomi => 'Kunyomi';

  @override
  String get noExampleWordsFound => 'Keine Beispielwörter gefunden';

  @override
  String get posNoun => 'Substantiv';

  @override
  String get posVerb => 'Verb';

  @override
  String get posAdverb => 'Adverb';

  @override
  String get posNaAdjective => 'Na-Adjektiv';

  @override
  String get posIAdjective => 'I-Adjektiv';

  @override
  String get posNoAdjective => 'No-Adjektiv';

  @override
  String get posExpression => 'Ausdruck';

  @override
  String get posConjunction => 'Konjunktion';

  @override
  String get posInterjection => 'Interjektion';

  @override
  String get posPronoun => 'Pronomen';

  @override
  String get posNumeral => 'Zahlwort';

  @override
  String get posPrefix => 'Präfix';

  @override
  String get posSuffix => 'Suffix';

  @override
  String get posParticle => 'Partikel';

  @override
  String get posCounter => 'Zählwort';

  @override
  String get posAuxiliaryVerb => 'Hilfsverb';

  @override
  String get posAuxiliary => 'Auxiliar';

  @override
  String get posPreNounAdj => 'Pränominales Adj.';

  @override
  String get posAdjIxClass => 'Adj. (ii/yoi)';

  @override
  String get posPrenominalAdj => 'Pränominales Adj.';

  @override
  String get posNounSuffix => 'Nominalsuffix';

  @override
  String get posNounPrefix => 'Nominalpräfix';

  @override
  String get posSuruSpecial => 'Suru-Verb (spez.)';

  @override
  String get posSuruIrregular => 'Suru-Verb (unreg.)';

  @override
  String get levelN5 => 'Anfänger';

  @override
  String get levelN4 => 'Grundstufe';

  @override
  String get levelN3 => 'Mittelstufe';

  @override
  String get levelN2 => 'Obere Mittelstufe';

  @override
  String get levelN1 => 'Fortgeschritten';

  @override
  String charactersSubtitle(int total) {
    return 'Kana · Kanji N5–N1 · $total Kana';
  }

  @override
  String get charactersSubtitleShort => 'Kana · Kanji N5–N1';

  @override
  String nKanji(int count) {
    return '$count Kanji';
  }

  @override
  String knownProgress(int known, int total) {
    return '$known / $total gelernt';
  }

  @override
  String get kanaRowVowels => 'Vokale';

  @override
  String get settingsAppearance => 'Erscheinungsbild';

  @override
  String get settingsThemeLight => 'Heller Modus';

  @override
  String get settingsThemeDark => 'Dunkler Modus';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get aboutTitle => 'Über';

  @override
  String aboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String get aboutDataSources => 'Datenquellen';

  @override
  String get aboutEdrdgNotice =>
      'Diese App verwendet JMdict und KANJIDIC2, veröffentlicht von der Electronic Dictionary Research and Development Group (EDRDG) unter einer Creative Commons Attribution-ShareAlike 4.0 International Lizenz.';

  @override
  String get aboutEdrdgLink => 'edrdg.org';

  @override
  String get aboutOpenSourceLicenses => 'Open-Source-Lizenzen';

  @override
  String get practiceSessionDone => 'Sitzung abgeschlossen';

  @override
  String practiceReviewed(int count) {
    return '$count wiederholt';
  }

  @override
  String practiceGotIt(int count) {
    return '$count gewusst';
  }

  @override
  String practiceNotYet(int count) {
    return '$count noch nicht';
  }

  @override
  String get practiceEmpty => 'Nichts zu wiederholen — komm morgen wieder!';

  @override
  String get practiceDone => 'Fertig';
}
