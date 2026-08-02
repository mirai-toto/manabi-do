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
  String get tagline => 'Learn Japanese · offline, at your pace';

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
  String get kana => 'Kana';

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
  String get sentenceFillIn => 'Sentence';

  @override
  String get sentenceFillInPrompt => 'Fill in the blank';

  @override
  String get practice => 'Practice →';

  @override
  String get sessionComplete => 'Session complete!';

  @override
  String get retry => 'Retry';

  @override
  String get nextLesson => 'Next lesson →';

  @override
  String get dailyTraining => 'Daily Training';

  @override
  String get writingPractice => 'Writing Practice';

  @override
  String get next => 'Next →';

  @override
  String kanjiPracticed(int count) {
    return '$count kanji practiced';
  }

  @override
  String get correct => 'Correct';

  @override
  String get missed => 'Missed';

  @override
  String get timeSpent => 'Time spent';

  @override
  String get flashcardDefaultPrompt => 'What does this mean?';

  @override
  String get flashcardJapaneseQuestion => 'How do you say this in Japanese?';

  @override
  String get tapToReveal => 'Tap to reveal';

  @override
  String get tapToHide => 'Tap to hide';

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
  String get kanaRowVowels => 'Vowels';

  @override
  String get settingsData => 'Data';

  @override
  String get settingsResetProgress => 'Reset all progress';

  @override
  String get resetProgressTitle => 'Reset all progress?';

  @override
  String get resetProgressBody => 'All SRS cards will be permanently deleted.';

  @override
  String get resetKanaTitle => 'Reset this kana?';

  @override
  String get resetKanaBody =>
      'SRS data for this character will be permanently deleted.';

  @override
  String get resetConfirm => 'Reset';

  @override
  String get cancel => 'Cancel';

  @override
  String get settingsPractice => 'Practice';

  @override
  String get settingsPracticeNewCharacters => 'New characters per day';

  @override
  String get settingsPracticeNewVocab => 'New vocabulary per day';

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
  String get aboutKanjiVgNotice =>
      'Kanji stroke order diagrams use KanjiVG by Ulrich Apel, licensed under Creative Commons Attribution-ShareAlike 3.0 Unported.';

  @override
  String get aboutKanjiVgLink => 'kanjivg.tagaini.net';

  @override
  String get aboutTatoebaNotice =>
      'Example sentences are sourced from Tatoeba (tatoeba.org), a community-built multilingual corpus, licensed under Creative Commons Attribution 2.0.';

  @override
  String get aboutTatoebaLink => 'tatoeba.org';

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
  String get practiceEmpty => 'Nothing to review · come back tomorrow!';

  @override
  String get practiceDone => 'Done';

  @override
  String get quitPracticeTitle => 'Leave session?';

  @override
  String get quitPracticeBody => 'Your remaining items won\'t be reviewed.';

  @override
  String get quit => 'Leave';

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
  String get mcqSelectKanaReading => 'What is the reading of this kana?';

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
    return '$count reviews';
  }

  @override
  String nNew(int count) {
    return '$count new';
  }

  @override
  String get reviewsDueSubtitle => 'Tap to start your session';

  @override
  String get reviewNow => 'Review now';

  @override
  String get studyNow => 'Study now';

  @override
  String get reviewAndStudy => 'Review & study';

  @override
  String get viewDetail => 'View detail';

  @override
  String get allCaughtUp => 'All caught up!';

  @override
  String get allCaughtUpSubtitle => 'Come back later for more reviews';

  @override
  String get grammarChapters => 'Chapters';

  @override
  String get japaneseBasics => 'Japanese Basics';

  @override
  String get japaneseBasicsSubtitle => 'Language fundamentals';

  @override
  String get grammarSubtitle => 'Basics & JLPT N5–N1';

  @override
  String get grammarLockedTitle => 'Grammar is coming soon';

  @override
  String get grammarLockedSubtitle =>
      'We\'re actively working on the grammar section. Stay tuned!';

  @override
  String get searchKanji => 'Search kanji';

  @override
  String get searchKanjiHint => 'Kanji, reading, or meaning…';

  @override
  String get searchKanjiPrompt => 'Search by kanji, reading, or meaning';

  @override
  String get noResults => 'No results';

  @override
  String groupN(int n) {
    return 'Group $n';
  }

  @override
  String get practiceSettingsTitle => 'Practice settings';

  @override
  String get practiceSettingsRecognition => 'Recognition';

  @override
  String get recognitionStrict => 'Strict';

  @override
  String get recognitionNormal => 'Normal';

  @override
  String get recognitionLenient => 'Lenient';

  @override
  String get practiceSettingsSessionLength => 'Session length';

  @override
  String get practiceSettingsMcqChoices => 'Options per question';

  @override
  String get sessionLengthHint => 'Takes effect next session';

  @override
  String get practiceSettingsHint => 'Hint';

  @override
  String get hintMeaning => 'Meaning';

  @override
  String get hintReadings => 'Readings';

  @override
  String get hintBoth => 'Both';

  @override
  String get ghostKanjiLabel => 'Ghost kanji';

  @override
  String get ghostKanjiSubtitle => 'Show kanji outline while drawing';

  @override
  String get snapToReferenceLabel => 'Snap to reference';

  @override
  String get snapToReferenceSubtitle =>
      'Replace correct strokes with clean reference';

  @override
  String get showStrokeCountLabel => 'Show stroke count';

  @override
  String get showStrokeCountSubtitle => 'Display number of strokes as a hint';

  @override
  String get autoAdvanceLabel => 'Auto-advance';

  @override
  String get autoAdvanceSubtitle =>
      'Move to next kanji automatically when all correct';

  @override
  String get hintUsedFeedback => 'Hint used · marked as missed';

  @override
  String get flashcardPractice => 'Flashcard';

  @override
  String get mcqPractice => 'Multiple Choice';

  @override
  String get freePractice => 'Free Practice';

  @override
  String get sentencePractice => 'Sentences';

  @override
  String get sentenceSettingsLabel => 'Sentence exercise';

  @override
  String get showMcqFuriganaLabel => 'Furigana in prompt';

  @override
  String get showMcqFuriganaSubtitle =>
      'Show reading above kanji in the Japanese word';

  @override
  String get showSentenceFuriganaLabel => 'Furigana in question';

  @override
  String get showSentenceFuriganaSubtitle =>
      'Show reading above kanji in the sentence';

  @override
  String get showChoiceFuriganaLabel => 'Furigana in choices';

  @override
  String get showChoiceFuriganaSubtitle =>
      'Show reading above kanji in answer options';

  @override
  String get translationModeLabel => 'Translation';

  @override
  String get translationModeAlways => 'Always';

  @override
  String get translationModeOnDemand => 'Button';

  @override
  String get translationModeNever => 'Never';

  @override
  String get nativeTranslationOnlyLabel => 'My language only';

  @override
  String get nativeTranslationOnlySubtitle =>
      'Skip sentences with no translation in your language';

  @override
  String get japanese => 'Japanese';

  @override
  String get copy => 'Copy';

  @override
  String get hide => 'Hide';

  @override
  String get grammarPractice => 'Practice';

  @override
  String get grammarMcqPrompt => 'What does this sentence mean?';

  @override
  String get grammarBuilderPrompt => 'Arrange the sentence';

  @override
  String get grammarErrorDetectionPrompt => 'Which sentence is correct?';

  @override
  String get example => 'Example';

  @override
  String get showExampleLabel => 'Show example';

  @override
  String get showExampleSubtitle => 'Display an example sentence on flashcards';
}
