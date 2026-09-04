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
  String get tagline => 'Japanisch lernen · offline, in deinem Tempo';

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
  String get kana => 'Kana';

  @override
  String get skipKana => 'Überspringen (aus Übung ausschließen)';

  @override
  String get skippedKana => 'Übersprungen';

  @override
  String get statusNotStarted => 'Nicht begonnen';

  @override
  String get chapterLocked => 'Kapitel gesperrt';

  @override
  String get chapterLockedBody =>
      'Schließe das vorherige Kapitel ab, um dieses freizuschalten, oder mach trotzdem weiter.';

  @override
  String get groupLocked => 'Gruppe gesperrt';

  @override
  String get groupLockedBody =>
      'Schließe die vorherige Gruppe ab, um diese freizuschalten, oder mach trotzdem weiter.';

  @override
  String get lessonLocked => 'Lektion gesperrt';

  @override
  String get lessonLockedBody =>
      'Schließe die vorherige Lektion ab, um diese freizuschalten, oder mach trotzdem weiter.';

  @override
  String get chapterUnlockAnyway => 'Trotzdem freischalten';

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
  String lessonsProgress(int done, int total) {
    return '$done / $total Lektionen';
  }

  @override
  String get multipleChoice => 'Multiple Choice';

  @override
  String get sentenceFillIn => 'Satz';

  @override
  String get sentenceFillInPrompt => 'Lücke ausfüllen';

  @override
  String get practice => 'Üben →';

  @override
  String get sessionComplete => 'Sitzung abgeschlossen!';

  @override
  String get retry => 'Nochmal';

  @override
  String get nextLesson => 'Nächste Lektion →';

  @override
  String get lessonStart => 'Starten';

  @override
  String get lessonStateStarted => 'Begonnen';

  @override
  String get lessonStateKnown => 'Bekannt';

  @override
  String get lessonStateUnknown => 'Unbekannt';

  @override
  String get lessonStateLocked => 'Gesperrt';

  @override
  String get markLessonAsCompleted => 'Als erledigt markieren';

  @override
  String get lessonMarkedCompleted => 'Erledigt';

  @override
  String get dailyTraining => 'Tägliches Training';

  @override
  String get writingPractice => 'Schreibübung';

  @override
  String get next => 'Weiter →';

  @override
  String kanjiPracticed(int count) {
    return '$count Kanji geübt';
  }

  @override
  String get correct => 'Richtig';

  @override
  String get correctAnswer => 'Richtige Antwort';

  @override
  String get missed => 'Falsch';

  @override
  String get timeSpent => 'Benötigte Zeit';

  @override
  String get flashcardDefaultPrompt => 'Was bedeutet das?';

  @override
  String get flashcardJapaneseQuestion => 'Wie sagt man das auf Japanisch?';

  @override
  String get tapToReveal => 'Zum Aufdecken tippen';

  @override
  String get tapToHide => 'Zum Verbergen tippen';

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
  String get todaysSession => 'Heutige Lerneinheit';

  @override
  String reviewsDueUnit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'fällige Wiederholungen',
      one: 'fällige Wiederholung',
    );
    return '$_temp0';
  }

  @override
  String get startReviews => 'Wiederholungen starten';

  @override
  String get yourDecks => 'Deine Stapel';

  @override
  String get keepLearning => 'Weiterlernen';

  @override
  String get thisWeek => 'Diese Woche';

  @override
  String nNewToday(int count) {
    return '$count neue heute';
  }

  @override
  String nDue(int count) {
    return '$count fällig';
  }

  @override
  String lessonOfTotal(int index, int total) {
    return 'Lektion $index von $total';
  }

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
  String get kanaRowVowels => 'Vokale';

  @override
  String get settingsData => 'Daten';

  @override
  String get settingsResetProgress => 'Alle Fortschritte zurücksetzen';

  @override
  String get resetProgressTitle => 'Alle Fortschritte zurücksetzen?';

  @override
  String get resetProgressBody => 'Alle SRS-Karten werden dauerhaft gelöscht.';

  @override
  String get resetKanaTitle => 'Dieses Kana zurücksetzen?';

  @override
  String get resetKanjiTitle => 'Dieses Kanji zurücksetzen?';

  @override
  String get resetKanaBody =>
      'SRS-Daten für dieses Zeichen werden dauerhaft gelöscht.';

  @override
  String get resetCharacterProgress =>
      'Fortschritt dieses Zeichens zurücksetzen';

  @override
  String get resetConfirm => 'Zurücksetzen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get settingsPractice => 'Übung';

  @override
  String get settingsHomeScreen => 'Startbildschirm';

  @override
  String get settingsPracticeNewCharacters => 'Neue Zeichen pro Tag';

  @override
  String get settingsPracticeNewVocab => 'Neues Vokabular pro Tag';

  @override
  String get settingsAppearance => 'Erscheinungsbild';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Hell';

  @override
  String get settingsThemeDark => 'Dunkel';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsFeedback => 'Feedback';

  @override
  String get settingsSendFeedback => 'Feedback senden';

  @override
  String get feedbackEmailSubject => 'Manabi Do Feedback';

  @override
  String get feedbackEmailBodyHint =>
      'Was gut funktioniert, was nicht, und was fehlt.';

  @override
  String feedbackNoMailApp(String email) {
    return 'Keine E-Mail-App gefunden. Adresse: $email';
  }

  @override
  String get feedbackAddressCopied => 'Adresse kopiert';

  @override
  String get settingsSupport => 'Unterstützung';

  @override
  String get settingsSupportDeveloper => 'Entwicklung unterstützen';

  @override
  String supportNoBrowser(String url) {
    return 'Link konnte nicht geöffnet werden. $url';
  }

  @override
  String get supportLinkCopied => 'Link kopiert';

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
  String get aboutKanjiVgNotice =>
      'Die Strichreihenfolge-Diagramme verwenden KanjiVG von Ulrich Apel, lizenziert unter Creative Commons Attribution-ShareAlike 3.0 Unported.';

  @override
  String get aboutKanjiVgLink => 'kanjivg.tagaini.net';

  @override
  String get aboutTatoebaNotice =>
      'Beispielsätze stammen von Tatoeba (tatoeba.org), einem gemeinschaftlich erstellten mehrsprachigen Korpus, lizenziert unter Creative Commons Attribution 2.0.';

  @override
  String get aboutTatoebaLink => 'tatoeba.org';

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
  String get practiceEmpty => 'Nichts zu wiederholen · komm morgen wieder!';

  @override
  String get practiceDone => 'Fertig';

  @override
  String get quitPracticeTitle => 'Sitzung verlassen?';

  @override
  String get quitPracticeBody =>
      'Die verbleibenden Elemente werden nicht geübt.';

  @override
  String get quit => 'Verlassen';

  @override
  String get drawingPractice => 'Schreiben üben';

  @override
  String get selfAssessQuestion => 'Hast du es gewusst?';

  @override
  String get ratingAgain => 'Nochmal';

  @override
  String get ratingHard => 'Schwer';

  @override
  String get ratingGood => 'Gut';

  @override
  String get ratingEasy => 'Leicht';

  @override
  String get drawingReference => 'Referenz';

  @override
  String get drawingYourAnswer => 'Deine Antwort';

  @override
  String get drawingCheck => 'Prüfen';

  @override
  String get drawingUndo => 'Rückgängig';

  @override
  String get drawingClear => 'Löschen';

  @override
  String drawingStrokeCount(int count) {
    return '$count Striche';
  }

  @override
  String drawingStrokeResult(int correct, int total) {
    return '$correct / $total Striche korrekt';
  }

  @override
  String get mcqSelectKanaReading => 'Wie lautet die Lesung dieses Kana?';

  @override
  String get mcqSelectMeaning => 'Was bedeutet dieses Kanji?';

  @override
  String get mcqSelectWordMeaning => 'Was bedeutet dieses Wort?';

  @override
  String mcqSelectKanji(String meaning) {
    return 'Welches Kanji steht für: \"$meaning\"?';
  }

  @override
  String get srsStateNew => 'Neu';

  @override
  String get srsStateLearning => 'In Bearbeitung';

  @override
  String get srsStateApprentice => 'Anfänger';

  @override
  String get srsStateFamiliar => 'Vertraut';

  @override
  String get srsStateMastered => 'Gelernt';

  @override
  String get srsStateExpert => 'Experte';

  @override
  String get srsDueToday => 'Heute fällig';

  @override
  String srsDueIn(int days) {
    return 'In $days T.';
  }

  @override
  String nWords(int count) {
    return '$count Wörter';
  }

  @override
  String vocabSubtitle(int total) {
    return '$total Wörter entdecken';
  }

  @override
  String get vocabSubtitleShort => 'Wörter entdecken';

  @override
  String reviewsDue(int count) {
    return '$count Wiederholungen';
  }

  @override
  String nNew(int count) {
    return '$count neu';
  }

  @override
  String get reviewsDueSubtitle => 'Tippen um die Sitzung zu starten';

  @override
  String get reviewNow => 'Jetzt üben';

  @override
  String get studyNow => 'Jetzt lernen';

  @override
  String get reviewAndStudy => 'Üben & lernen';

  @override
  String get viewDetail => 'Details anzeigen';

  @override
  String get allCaughtUp => 'Alles erledigt!';

  @override
  String get allCaughtUpSubtitle =>
      'Komm später für weitere Wiederholungen zurück';

  @override
  String get grammarChapters => 'Themen';

  @override
  String get japaneseBasics => 'Japanische Grundlagen';

  @override
  String get japaneseBasicsSubtitle => 'Sprachliche Grundlagen';

  @override
  String get grammarSubtitle => 'Grundlagen & JLPT N5–N1';

  @override
  String get searchKanji => 'Kanji suchen';

  @override
  String get searchKanjiHint => 'Kanji, Lesung oder Bedeutung…';

  @override
  String get searchKanjiPrompt => 'Nach Kanji, Lesung oder Bedeutung suchen';

  @override
  String get noResults => 'Keine Ergebnisse';

  @override
  String groupN(int n) {
    return 'Gruppe $n';
  }

  @override
  String get practiceSettingsTitle => 'Übungseinstellungen';

  @override
  String get practiceSettingsRecognition => 'Erkennung';

  @override
  String get recognitionStrict => 'Streng';

  @override
  String get recognitionNormal => 'Normal';

  @override
  String get recognitionLenient => 'Großzügig';

  @override
  String get practiceSettingsSessionLength => 'Sitzungslänge';

  @override
  String get practiceSettingsMcqChoices => 'Optionen pro Frage';

  @override
  String get sessionLengthHint => 'Gilt ab der nächsten Sitzung';

  @override
  String get practiceSettingsHint => 'Hinweis';

  @override
  String get hintMeaning => 'Bedeutung';

  @override
  String get hintReadings => 'Lesungen';

  @override
  String get hintBoth => 'Beides';

  @override
  String get ghostKanjiLabel => 'Geist-Kanji';

  @override
  String get ghostKanjiSubtitle => 'Kanji-Umriss beim Zeichnen anzeigen';

  @override
  String get snapToReferenceLabel => 'An Referenz einrasten';

  @override
  String get snapToReferenceSubtitle =>
      'Korrekte Striche durch saubere Referenz ersetzen';

  @override
  String get showStrokeCountLabel => 'Strichanzahl anzeigen';

  @override
  String get showStrokeCountSubtitle =>
      'Anzahl der Striche als Hinweis anzeigen';

  @override
  String get autoAdvanceLabel => 'Auto-Weiter';

  @override
  String get autoAdvanceSubtitle =>
      'Automatisch zum nächsten Kanji wechseln, wenn alles korrekt ist';

  @override
  String get hintUsedFeedback => 'Hinweis benutzt · als falsch markiert';

  @override
  String get flashcardPractice => 'Karteikarten';

  @override
  String get mcqPractice => 'Multiple Choice';

  @override
  String get freePractice => 'Freies Üben';

  @override
  String get sentencePractice => 'Sätze';

  @override
  String get sentenceSettingsLabel => 'Satzübung';

  @override
  String get showMcqFuriganaLabel => 'Furigana in der Aufgabe';

  @override
  String get showMcqFuriganaSubtitle =>
      'Lesung über Kanji im japanischen Wort anzeigen';

  @override
  String get showSentenceFuriganaLabel => 'Furigana im Satz';

  @override
  String get showSentenceFuriganaSubtitle =>
      'Lesung über Kanji im Satz anzeigen';

  @override
  String get showChoiceFuriganaLabel => 'Furigana in Antworten';

  @override
  String get showChoiceFuriganaSubtitle =>
      'Lesung in den Antwortoptionen anzeigen';

  @override
  String get translationModeLabel => 'Übersetzung';

  @override
  String get translationModeAlways => 'Immer';

  @override
  String get translationModeOnDemand => 'Schaltfläche';

  @override
  String get translationModeNever => 'Nie';

  @override
  String get nativeTranslationOnlyLabel => 'Nur meine Sprache';

  @override
  String get nativeTranslationOnlySubtitle =>
      'Sätze ohne Übersetzung in Ihrer Sprache überspringen';

  @override
  String get japanese => 'Japanisch';

  @override
  String get copy => 'Kopieren';

  @override
  String get hide => 'Ausblenden';

  @override
  String get grammarPractice => 'Üben';

  @override
  String get grammarMcqPrompt => 'Was bedeutet dieser Satz?';

  @override
  String get grammarBuilderPrompt => 'Ordne den Satz';

  @override
  String get grammarErrorDetectionPrompt => 'Welcher Satz ist korrekt?';

  @override
  String get example => 'Beispiel';

  @override
  String get showExampleLabel => 'Beispiel anzeigen';

  @override
  String get showExampleSubtitle =>
      'Einen Beispielsatz auf Karteikarten anzeigen';
}
