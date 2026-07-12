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
  String get tagline => 'Apprends le japonais · hors ligne, à ton rythme';

  @override
  String get signInWithGoogle => 'Connecte-toi avec Google';

  @override
  String get signInWithApple => 'Connecte-toi avec Apple';

  @override
  String get continueAsGuest => 'Continuer sans compte →';

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
  String get kana => 'Kana';

  @override
  String get skipKana => 'Passer (ignorer pour les révisions)';

  @override
  String get skippedKana => 'Ignoré';

  @override
  String get statusNotStarted => 'Pas encore commencé';

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
  String get sentenceFillIn => 'Phrase';

  @override
  String get sentenceFillInPrompt => 'Complétez la phrase';

  @override
  String get practice => 'S\'entraîner →';

  @override
  String get sessionComplete => 'Séance terminée !';

  @override
  String get retry => 'Réessayer';

  @override
  String get nextLesson => 'Leçon suivante →';

  @override
  String get dailyTraining => 'Entraînement quotidien';

  @override
  String get writingPractice => 'Pratique de l\'écriture';

  @override
  String get next => 'Suivant →';

  @override
  String kanjiPracticed(int count) {
    return '$count kanji pratiqués';
  }

  @override
  String get correct => 'Correct';

  @override
  String get missed => 'Raté';

  @override
  String get timeSpent => 'Temps passé';

  @override
  String get flashcardDefaultPrompt => 'C\'est quoi ?';

  @override
  String get flashcardJapaneseQuestion => 'Comment dit-on ça en japonais ?';

  @override
  String get tapToReveal => 'Appuie pour révéler';

  @override
  String get tapToHide => 'Appuie pour masquer';

  @override
  String get flashcardNotYet => '✗  Pas encore';

  @override
  String get flashcardGotIt => '✓  Je sais';

  @override
  String get navSettings => 'Paramètres';

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
  String get greetingSubtitle => 'Un peu de japonais ?';

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

  @override
  String get posNoun => 'Nom';

  @override
  String get posVerb => 'Verbe';

  @override
  String get posAdverb => 'Adverbe';

  @override
  String get posNaAdjective => 'Adjectif na';

  @override
  String get posIAdjective => 'Adjectif i';

  @override
  String get posNoAdjective => 'Adjectif no';

  @override
  String get posExpression => 'Expression';

  @override
  String get posConjunction => 'Conjonction';

  @override
  String get posInterjection => 'Interjection';

  @override
  String get posPronoun => 'Pronom';

  @override
  String get posNumeral => 'Numéral';

  @override
  String get posPrefix => 'Préfixe';

  @override
  String get posSuffix => 'Suffixe';

  @override
  String get posParticle => 'Particule';

  @override
  String get posCounter => 'Compteur';

  @override
  String get posAuxiliaryVerb => 'Verbe aux.';

  @override
  String get posAuxiliary => 'Auxiliaire';

  @override
  String get posPreNounAdj => 'Adj. pré-nominal';

  @override
  String get posAdjIxClass => 'Adj. (ii/yoi)';

  @override
  String get posPrenominalAdj => 'Adj. prénominal';

  @override
  String get posNounSuffix => 'Suffixe nominal';

  @override
  String get posNounPrefix => 'Préfixe nominal';

  @override
  String get posSuruSpecial => 'Verbe suru (spécial)';

  @override
  String get posSuruIrregular => 'Verbe suru (irrég.)';

  @override
  String get levelN5 => 'Débutant';

  @override
  String get levelN4 => 'Élémentaire';

  @override
  String get levelN3 => 'Intermédiaire';

  @override
  String get levelN2 => 'Intermédiaire supérieur';

  @override
  String get levelN1 => 'Avancé';

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
  String get kanaRowVowels => 'Voyelles';

  @override
  String get settingsData => 'Données';

  @override
  String get settingsResetProgress => 'Réinitialiser la progression';

  @override
  String get resetProgressTitle => 'Réinitialiser toute la progression ?';

  @override
  String get resetProgressBody =>
      'Toutes les cartes SRS seront définitivement supprimées.';

  @override
  String get resetKanaTitle => 'Réinitialiser ce kana ?';

  @override
  String get resetKanaBody =>
      'Les données SRS de ce caractère seront définitivement supprimées.';

  @override
  String get resetConfirm => 'Réinitialiser';

  @override
  String get cancel => 'Annuler';

  @override
  String get settingsPractice => 'Entraînement';

  @override
  String get settingsPracticeNewCharacters => 'Nouveaux caractères par jour';

  @override
  String get settingsPracticeNewVocab => 'Nouveau vocabulaire par jour';

  @override
  String get settingsAppearance => 'Apparence';

  @override
  String get settingsThemeSystem => 'Système';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get aboutTitle => 'À propos';

  @override
  String aboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String get aboutDataSources => 'Sources de données';

  @override
  String get aboutEdrdgNotice =>
      'Cette application utilise JMdict et KANJIDIC2, publiés par l\'Electronic Dictionary Research and Development Group (EDRDG) sous licence Creative Commons Attribution-ShareAlike 4.0 International.';

  @override
  String get aboutEdrdgLink => 'edrdg.org';

  @override
  String get aboutKanjiVgNotice =>
      'Les diagrammes d\'ordre des traits utilisent KanjiVG d\'Ulrich Apel, sous licence Creative Commons Attribution-ShareAlike 3.0 non transposé.';

  @override
  String get aboutKanjiVgLink => 'kanjivg.tagaini.net';

  @override
  String get aboutTatoebaNotice =>
      'Les exemples de phrases proviennent de Tatoeba (tatoeba.org), un corpus multilingue communautaire, sous licence Creative Commons Attribution 2.0.';

  @override
  String get aboutTatoebaLink => 'tatoeba.org';

  @override
  String get aboutOpenSourceLicenses => 'Licences open source';

  @override
  String get practiceSessionDone => 'Session terminée !';

  @override
  String practiceReviewed(int count) {
    return '$count révisées';
  }

  @override
  String practiceGotIt(int count) {
    return '$count réussies';
  }

  @override
  String practiceNotYet(int count) {
    return '$count à revoir';
  }

  @override
  String get practiceEmpty => 'Rien à revoir · reviens demain !';

  @override
  String get practiceDone => 'Terminer';

  @override
  String get quitPracticeTitle => 'Quitter la session ?';

  @override
  String get quitPracticeBody => 'Les éléments restants ne seront pas révisés.';

  @override
  String get quit => 'Quitter';

  @override
  String get drawingPractice => 'S\'entraîner à tracer';

  @override
  String get selfAssessQuestion => 'Tu l\'as eu ?';

  @override
  String get ratingAgain => 'Raté';

  @override
  String get ratingHard => 'Dur';

  @override
  String get ratingGood => 'Bien';

  @override
  String get ratingEasy => 'Facile';

  @override
  String get drawingReference => 'Référence';

  @override
  String get drawingYourAnswer => 'Ta réponse';

  @override
  String get drawingCheck => 'Vérifier';

  @override
  String get drawingUndo => 'Annuler';

  @override
  String get drawingClear => 'Effacer';

  @override
  String drawingStrokeCount(int count) {
    return '$count traits';
  }

  @override
  String drawingStrokeResult(int correct, int total) {
    return '$correct / $total traits corrects';
  }

  @override
  String get mcqSelectKanaReading => 'Quelle est la lecture de ce kana ?';

  @override
  String get mcqSelectMeaning => 'Ce kanji veut dire ?';

  @override
  String get mcqSelectWordMeaning => 'Que signifie ce mot ?';

  @override
  String mcqSelectKanji(String meaning) {
    return 'Quel kanji pour \"$meaning\" ?';
  }

  @override
  String get srsStateNew => 'Nouveau';

  @override
  String get srsStateLearning => 'En cours';

  @override
  String get srsStateApprentice => 'Apprenti';

  @override
  String get srsStateFamiliar => 'Familier';

  @override
  String get srsStateMastered => 'Maîtrisé';

  @override
  String get srsStateExpert => 'Expert';

  @override
  String get srsDueToday => 'À revoir aujourd\'hui';

  @override
  String srsDueIn(int days) {
    return 'Dans ${days}j';
  }

  @override
  String nWords(int count) {
    return '$count mots';
  }

  @override
  String vocabSubtitle(int total) {
    return '$total mots à découvrir';
  }

  @override
  String get vocabSubtitleShort => 'Mots à découvrir';

  @override
  String reviewsDue(int count) {
    return '$count révisions';
  }

  @override
  String nNew(int count) {
    return '$count nouveau';
  }

  @override
  String get reviewsDueSubtitle => 'Appuyez pour commencer la session';

  @override
  String get reviewNow => 'Réviser';

  @override
  String get studyNow => 'Étudier';

  @override
  String get reviewAndStudy => 'Réviser & étudier';

  @override
  String get viewDetail => 'Voir le détail';

  @override
  String get allCaughtUp => 'Tout est à jour !';

  @override
  String get allCaughtUpSubtitle =>
      'Revenez plus tard pour de nouvelles révisions';

  @override
  String get grammarChapters => 'Chapitres';

  @override
  String get japaneseBasics => 'Bases du japonais';

  @override
  String get japaneseBasicsSubtitle => 'Fondamentaux de la langue';

  @override
  String get grammarSubtitle => 'Bases & JLPT N5–N1';

  @override
  String get grammarLockedTitle => 'La grammaire arrive bientôt';

  @override
  String get grammarLockedSubtitle =>
      'Nous travaillons activement sur la section grammaire. Restez connecté !';

  @override
  String get searchKanji => 'Rechercher un kanji';

  @override
  String get searchKanjiHint => 'Kanji, lecture ou signification…';

  @override
  String get searchKanjiPrompt =>
      'Rechercher par kanji, lecture ou signification';

  @override
  String get noResults => 'Aucun résultat';

  @override
  String groupN(int n) {
    return 'Groupe $n';
  }

  @override
  String get practiceSettingsTitle => 'Réglages de pratique';

  @override
  String get practiceSettingsRecognition => 'Reconnaissance';

  @override
  String get recognitionStrict => 'Strict';

  @override
  String get recognitionNormal => 'Normal';

  @override
  String get recognitionLenient => 'Tolérant';

  @override
  String get practiceSettingsSessionLength => 'Durée de session';

  @override
  String get practiceSettingsMcqChoices => 'Options par question';

  @override
  String get sessionLengthHint => 'Prend effet à la prochaine session';

  @override
  String get practiceSettingsHint => 'Indice';

  @override
  String get hintMeaning => 'Signification';

  @override
  String get hintReadings => 'Lectures';

  @override
  String get hintBoth => 'Les deux';

  @override
  String get ghostKanjiLabel => 'Kanji fantôme';

  @override
  String get ghostKanjiSubtitle =>
      'Afficher le contour du kanji pendant le tracé';

  @override
  String get snapToReferenceLabel => 'Accrocher à la référence';

  @override
  String get snapToReferenceSubtitle =>
      'Remplacer les traits corrects par la référence propre';

  @override
  String get showStrokeCountLabel => 'Afficher le nombre de traits';

  @override
  String get showStrokeCountSubtitle =>
      'Afficher le nombre de traits comme indice';

  @override
  String get autoAdvanceLabel => 'Avance automatique';

  @override
  String get autoAdvanceSubtitle =>
      'Passer au kanji suivant automatiquement quand tout est correct';

  @override
  String get hintUsedFeedback => 'Indice utilisé · marqué comme raté';

  @override
  String get flashcardPractice => 'Cartes mémoire';

  @override
  String get mcqPractice => 'Choix multiple';

  @override
  String get freePractice => 'Entraînement libre';

  @override
  String get sentencePractice => 'Phrases';

  @override
  String get sentenceSettingsLabel => 'Exercice de phrases';

  @override
  String get showMcqFuriganaLabel => 'Furigana dans l\'énoncé';

  @override
  String get showMcqFuriganaSubtitle =>
      'Afficher la lecture au-dessus des kanji du mot';

  @override
  String get showSentenceFuriganaLabel => 'Furigana dans la phrase';

  @override
  String get showSentenceFuriganaSubtitle =>
      'Afficher la lecture au-dessus des kanji';

  @override
  String get showChoiceFuriganaLabel => 'Furigana dans les choix';

  @override
  String get showChoiceFuriganaSubtitle =>
      'Afficher la lecture dans les options de réponse';

  @override
  String get translationModeLabel => 'Traduction';

  @override
  String get translationModeAlways => 'Toujours';

  @override
  String get translationModeOnDemand => 'Bouton';

  @override
  String get translationModeNever => 'Jamais';

  @override
  String get nativeTranslationOnlyLabel => 'Ma langue uniquement';

  @override
  String get nativeTranslationOnlySubtitle =>
      'Ignorer les phrases sans traduction dans votre langue';

  @override
  String get japanese => 'Japonais';

  @override
  String get copy => 'Copier';
}
