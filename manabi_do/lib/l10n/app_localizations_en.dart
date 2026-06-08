// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Manabi Do';

  @override
  String get tagline => 'Learn Japanese — offline, at your pace';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signInWithApple => 'Sign in with Apple';

  @override
  String get continueAsGuest => 'Continue as guest →';

  @override
  String get or => 'or';

  @override
  String get sectionGrammar => 'Grammar';

  @override
  String get sectionCharacters => 'Characters';

  @override
  String get sectionVocabulary => 'Vocabulary';

  @override
  String get tabHiragana => 'Hiragana';

  @override
  String get tabKatakana => 'Katakana';

  @override
  String get tabKanji => 'Kanji';

  @override
  String get known => 'Known';

  @override
  String get knownCheck => 'Known ✓';

  @override
  String get markAsKnown => 'Mark as known';

  @override
  String get notKnown => 'Not known';

  @override
  String get skipKana => 'Skip (exclude from practice)';

  @override
  String get skippedKana => 'Skipped';

  @override
  String get statusNotStarted => 'Not started';

  @override
  String get exampleWords => 'Example Words';

  @override
  String get readings => 'Readings';

  @override
  String difficultyLevel(int level) {
    return 'Difficulty $level';
  }

  @override
  String chapterN(String number) {
    return 'Chapter $number';
  }

  @override
  String nLessons(int count) {
    return '$count lessons';
  }

  @override
  String get multipleChoice => 'Multiple Choice';

  @override
  String get practice => 'Practice →';

  @override
  String get retry => 'Retry';

  @override
  String get nextLesson => 'Next lesson →';

  @override
  String get correct => 'Correct';

  @override
  String get missed => 'Missed';

  @override
  String get markedKnown => 'Marked known';

  @override
  String get timeSpent => 'Time spent';

  @override
  String get flashcardDefaultPrompt => 'What does this mean?';

  @override
  String get tapToReveal => 'Tap to reveal';

  @override
  String get flashcardNotYet => '✗  Not yet';

  @override
  String get flashcardGotIt => '✓  Got it';

  @override
  String get navSettings => 'Settings';

  @override
  String get navHome => 'Home';

  @override
  String get navVocab => 'Vocab';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get greetingSubtitle => 'Let\'s study some Japanese';

  @override
  String get streakLabel => 'day streak';

  @override
  String get streakSubtitle => 'Keep it up!';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get strokeOrderPlaceholder => '▶ Stroke order animation';

  @override
  String get strokeOrder => 'Stroke Order';

  @override
  String get selectLevel => 'Select a Level';

  @override
  String get onyomi => 'onyomi';

  @override
  String get kunyomi => 'kunyomi';

  @override
  String get noExampleWordsFound => 'No example words found';

  @override
  String get posNoun => 'Noun';

  @override
  String get posVerb => 'Verb';

  @override
  String get posAdverb => 'Adverb';

  @override
  String get posNaAdjective => 'Na-adjective';

  @override
  String get posIAdjective => 'I-adjective';

  @override
  String get posNoAdjective => 'No-adjective';

  @override
  String get posExpression => 'Expression';

  @override
  String get posConjunction => 'Conjunction';

  @override
  String get posInterjection => 'Interjection';

  @override
  String get posPronoun => 'Pronoun';

  @override
  String get posNumeral => 'Numeral';

  @override
  String get posPrefix => 'Prefix';

  @override
  String get posSuffix => 'Suffix';

  @override
  String get posParticle => 'Particle';

  @override
  String get posCounter => 'Counter';

  @override
  String get posAuxiliaryVerb => 'Aux. verb';

  @override
  String get posAuxiliary => 'Auxiliary';

  @override
  String get posPreNounAdj => 'Pre-noun adj.';

  @override
  String get posAdjIxClass => 'Adj. (ii/yoi)';

  @override
  String get posPrenominalAdj => 'Prenominal adj.';

  @override
  String get posNounSuffix => 'Noun suffix';

  @override
  String get posNounPrefix => 'Noun prefix';

  @override
  String get posSuruSpecial => 'Suru verb (special)';

  @override
  String get posSuruIrregular => 'Suru verb (irreg.)';

  @override
  String get levelN5 => 'Beginner';

  @override
  String get levelN4 => 'Elementary';

  @override
  String get levelN3 => 'Intermediate';

  @override
  String get levelN2 => 'Upper-Intermediate';

  @override
  String get levelN1 => 'Advanced';

  @override
  String charactersSubtitle(int total) {
    return 'Kana · Kanji N5–N1 · $total kana';
  }

  @override
  String get charactersSubtitleShort => 'Kana · Kanji N5–N1';

  @override
  String nKanji(int count) {
    return '$count kanji';
  }

  @override
  String knownProgress(int known, int total) {
    return '$known / $total known';
  }

  @override
  String get kanaRowVowels => 'Vowels';

  @override
  String get settingsData => 'Data';

  @override
  String get settingsResetProgress => 'Reset all progress';

  @override
  String get resetProgressTitle => 'Reset all progress?';

  @override
  String get resetProgressBody =>
      'All SRS cards and known states will be permanently deleted.';

  @override
  String get resetKanaTitle => 'Reset this kana?';

  @override
  String get resetKanaBody =>
      'SRS data and known state for this character will be permanently deleted.';

  @override
  String get resetConfirm => 'Reset';

  @override
  String get cancel => 'Cancel';

  @override
  String get settingsPractice => 'Practice';

  @override
  String get settingsPracticeNewCards => 'New cards per day';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get aboutTitle => 'About';

  @override
  String aboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String get aboutDataSources => 'Data sources';

  @override
  String get aboutEdrdgNotice =>
      'This app uses JMdict and KANJIDIC2, published by the Electronic Dictionary Research and Development Group (EDRDG) under a Creative Commons Attribution-ShareAlike 4.0 International licence.';

  @override
  String get aboutEdrdgLink => 'edrdg.org';

  @override
  String get aboutOpenSourceLicenses => 'Open source licenses';

  @override
  String get practiceSessionDone => 'Session complete';

  @override
  String practiceReviewed(int count) {
    return '$count reviewed';
  }

  @override
  String practiceGotIt(int count) {
    return '$count got it';
  }

  @override
  String practiceNotYet(int count) {
    return '$count not yet';
  }

  @override
  String get practiceEmpty => 'Nothing to review — come back tomorrow!';

  @override
  String get practiceDone => 'Done';

  @override
  String get drawingPractice => 'Practice Drawing';

  @override
  String get selfAssessQuestion => 'Did you get it right?';

  @override
  String get ratingAgain => 'Again';

  @override
  String get ratingHard => 'Hard';

  @override
  String get ratingGood => 'Good';

  @override
  String get ratingEasy => 'Easy';

  @override
  String get drawingReference => 'Reference';

  @override
  String get drawingYourAnswer => 'Your answer';

  @override
  String get drawingCheck => 'Check';

  @override
  String get drawingUndo => 'Undo';

  @override
  String get drawingClear => 'Clear';

  @override
  String drawingStrokeCount(int count) {
    return '$count strokes';
  }

  @override
  String drawingStrokeResult(int correct, int total) {
    return '$correct / $total strokes correct';
  }

  @override
  String get mcqSelectMeaning => 'What does this kanji mean?';

  @override
  String get mcqSelectWordMeaning => 'What does this word mean?';

  @override
  String mcqSelectKanji(String meaning) {
    return 'Select the kanji for: \"$meaning\"';
  }

  @override
  String get srsStateNew => 'New';

  @override
  String get srsStateLearning => 'Learning';

  @override
  String get srsStateApprentice => 'Apprentice';

  @override
  String get srsStateFamiliar => 'Familiar';

  @override
  String get srsStateMastered => 'Mastered';

  @override
  String get srsStateExpert => 'Expert';

  @override
  String get srsDueToday => 'Due today';

  @override
  String srsDueIn(int days) {
    return 'Due in ${days}d';
  }

  @override
  String nWords(int count) {
    return '$count words';
  }

  @override
  String vocabSubtitle(int total) {
    return '$total words to discover';
  }

  @override
  String get vocabSubtitleShort => 'Words to discover';

  @override
  String reviewsDue(int count) {
    return '$count reviews waiting';
  }

  @override
  String get reviewsDueSubtitle => 'Tap to start your session';

  @override
  String get reviewNow => 'Review now';

  @override
  String get allCaughtUp => 'All caught up!';

  @override
  String get allCaughtUpSubtitle => 'Come back later for more reviews';
}
