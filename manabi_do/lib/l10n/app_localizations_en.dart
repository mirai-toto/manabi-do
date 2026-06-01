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
  String get navMore => 'More';

  @override
  String get navHome => 'Home';

  @override
  String get navVocab => 'Vocab';

  @override
  String get greetingMorning => 'Good morning 👋';

  @override
  String get greetingAfternoon => 'Good afternoon 👋';

  @override
  String get greetingEvening => 'Good evening 👋';

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
}
