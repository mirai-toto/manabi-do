// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Manabi Do';

  @override
  String get tagline => 'Apprends le japonais — hors ligne, à ton rythme';

  @override
  String get signInWithGoogle => 'Se connecter avec Google';

  @override
  String get signInWithApple => 'Se connecter avec Apple';

  @override
  String get continueAsGuest => 'Continuer en tant qu\'invité →';

  @override
  String get or => 'ou';

  @override
  String get sectionGrammar => 'Grammaire';

  @override
  String get sectionCharacters => 'Caractères';

  @override
  String get sectionVocabulary => 'Vocabulaire';

  @override
  String get tabHiragana => 'Hiragana';

  @override
  String get tabKatakana => 'Katakana';

  @override
  String get tabKanji => 'Kanji';

  @override
  String get known => 'Appris';

  @override
  String get knownCheck => 'Appris ✓';

  @override
  String get markAsKnown => 'Marquer comme appris';

  @override
  String get notKnown => 'Non appris';

  @override
  String get statusNotStarted => 'Non commencé';

  @override
  String get exampleWords => 'Exemples';

  @override
  String get readings => 'Lectures';

  @override
  String difficultyLevel(int level) {
    return 'Difficulté $level';
  }

  @override
  String chapterN(String number) {
    return 'Chapitre $number';
  }

  @override
  String nLessons(int count) {
    return '$count leçons';
  }

  @override
  String get multipleChoice => 'Choix multiple';

  @override
  String get practice => 'Pratiquer →';

  @override
  String get retry => 'Réessayer';

  @override
  String get nextLesson => 'Leçon suivante →';

  @override
  String get correct => 'Correct';

  @override
  String get missed => 'Manqué';

  @override
  String get markedKnown => 'Marqué appris';

  @override
  String get timeSpent => 'Temps passé';

  @override
  String get flashcardDefaultPrompt => 'Que signifie ceci ?';

  @override
  String get tapToReveal => 'Appuyer pour révéler';

  @override
  String get flashcardNotYet => '✗  Pas encore';

  @override
  String get flashcardGotIt => '✓  Je sais';

  @override
  String get navMore => 'Plus';

  @override
  String get navHome => 'Accueil';

  @override
  String get navVocab => 'Vocab';

  @override
  String get greetingMorning => 'Bonjour';

  @override
  String get greetingAfternoon => 'Bon après-midi';

  @override
  String get greetingEvening => 'Bonsoir';

  @override
  String get greetingSubtitle => 'Étudions le japonais';

  @override
  String get streakLabel => 'jours de suite';

  @override
  String get streakSubtitle => 'Continue comme ça !';

  @override
  String get comingSoon => 'Bientôt disponible';

  @override
  String get strokeOrderPlaceholder => '▶ Animation de l\'ordre des traits';

  @override
  String get strokeOrder => 'Ordre des traits';

  @override
  String get selectLevel => 'Choisir un niveau';

  @override
  String get onyomi => 'onyomi';

  @override
  String get kunyomi => 'kunyomi';

  @override
  String get noExampleWordsFound => 'Aucun exemple trouvé';
}
