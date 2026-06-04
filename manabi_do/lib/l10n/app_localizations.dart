import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('fr'),
  ];

  /// The name of the application
  ///
  /// In en, this message translates to:
  /// **'Manabi Do'**
  String get appTitle;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Learn Japanese — offline, at your pace'**
  String get tagline;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @signInWithApple.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get signInWithApple;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as guest →'**
  String get continueAsGuest;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @sectionGrammar.
  ///
  /// In en, this message translates to:
  /// **'Grammar'**
  String get sectionGrammar;

  /// No description provided for @sectionCharacters.
  ///
  /// In en, this message translates to:
  /// **'Characters'**
  String get sectionCharacters;

  /// No description provided for @sectionVocabulary.
  ///
  /// In en, this message translates to:
  /// **'Vocabulary'**
  String get sectionVocabulary;

  /// No description provided for @tabHiragana.
  ///
  /// In en, this message translates to:
  /// **'Hiragana'**
  String get tabHiragana;

  /// No description provided for @tabKatakana.
  ///
  /// In en, this message translates to:
  /// **'Katakana'**
  String get tabKatakana;

  /// No description provided for @tabKanji.
  ///
  /// In en, this message translates to:
  /// **'Kanji'**
  String get tabKanji;

  /// No description provided for @known.
  ///
  /// In en, this message translates to:
  /// **'Known'**
  String get known;

  /// No description provided for @knownCheck.
  ///
  /// In en, this message translates to:
  /// **'Known ✓'**
  String get knownCheck;

  /// No description provided for @markAsKnown.
  ///
  /// In en, this message translates to:
  /// **'Mark as known'**
  String get markAsKnown;

  /// No description provided for @notKnown.
  ///
  /// In en, this message translates to:
  /// **'Not known'**
  String get notKnown;

  /// No description provided for @statusNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Not started'**
  String get statusNotStarted;

  /// No description provided for @exampleWords.
  ///
  /// In en, this message translates to:
  /// **'Example Words'**
  String get exampleWords;

  /// No description provided for @readings.
  ///
  /// In en, this message translates to:
  /// **'Readings'**
  String get readings;

  /// No description provided for @difficultyLevel.
  ///
  /// In en, this message translates to:
  /// **'Difficulty {level}'**
  String difficultyLevel(int level);

  /// No description provided for @chapterN.
  ///
  /// In en, this message translates to:
  /// **'Chapter {number}'**
  String chapterN(String number);

  /// No description provided for @nLessons.
  ///
  /// In en, this message translates to:
  /// **'{count} lessons'**
  String nLessons(int count);

  /// No description provided for @multipleChoice.
  ///
  /// In en, this message translates to:
  /// **'Multiple Choice'**
  String get multipleChoice;

  /// No description provided for @practice.
  ///
  /// In en, this message translates to:
  /// **'Practice →'**
  String get practice;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @nextLesson.
  ///
  /// In en, this message translates to:
  /// **'Next lesson →'**
  String get nextLesson;

  /// No description provided for @correct.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get correct;

  /// No description provided for @missed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get missed;

  /// No description provided for @markedKnown.
  ///
  /// In en, this message translates to:
  /// **'Marked known'**
  String get markedKnown;

  /// No description provided for @timeSpent.
  ///
  /// In en, this message translates to:
  /// **'Time spent'**
  String get timeSpent;

  /// No description provided for @flashcardDefaultPrompt.
  ///
  /// In en, this message translates to:
  /// **'What does this mean?'**
  String get flashcardDefaultPrompt;

  /// No description provided for @tapToReveal.
  ///
  /// In en, this message translates to:
  /// **'Tap to reveal'**
  String get tapToReveal;

  /// No description provided for @flashcardNotYet.
  ///
  /// In en, this message translates to:
  /// **'✗  Not yet'**
  String get flashcardNotYet;

  /// No description provided for @flashcardGotIt.
  ///
  /// In en, this message translates to:
  /// **'✓  Got it'**
  String get flashcardGotIt;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navVocab.
  ///
  /// In en, this message translates to:
  /// **'Vocab'**
  String get navVocab;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;

  /// No description provided for @greetingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s study some Japanese'**
  String get greetingSubtitle;

  /// No description provided for @streakLabel.
  ///
  /// In en, this message translates to:
  /// **'day streak'**
  String get streakLabel;

  /// No description provided for @streakSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep it up!'**
  String get streakSubtitle;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @strokeOrderPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'▶ Stroke order animation'**
  String get strokeOrderPlaceholder;

  /// No description provided for @strokeOrder.
  ///
  /// In en, this message translates to:
  /// **'Stroke Order'**
  String get strokeOrder;

  /// No description provided for @selectLevel.
  ///
  /// In en, this message translates to:
  /// **'Select a Level'**
  String get selectLevel;

  /// No description provided for @onyomi.
  ///
  /// In en, this message translates to:
  /// **'onyomi'**
  String get onyomi;

  /// No description provided for @kunyomi.
  ///
  /// In en, this message translates to:
  /// **'kunyomi'**
  String get kunyomi;

  /// No description provided for @noExampleWordsFound.
  ///
  /// In en, this message translates to:
  /// **'No example words found'**
  String get noExampleWordsFound;

  /// No description provided for @posNoun.
  ///
  /// In en, this message translates to:
  /// **'Noun'**
  String get posNoun;

  /// No description provided for @posVerb.
  ///
  /// In en, this message translates to:
  /// **'Verb'**
  String get posVerb;

  /// No description provided for @posAdverb.
  ///
  /// In en, this message translates to:
  /// **'Adverb'**
  String get posAdverb;

  /// No description provided for @posNaAdjective.
  ///
  /// In en, this message translates to:
  /// **'Na-adjective'**
  String get posNaAdjective;

  /// No description provided for @posIAdjective.
  ///
  /// In en, this message translates to:
  /// **'I-adjective'**
  String get posIAdjective;

  /// No description provided for @posNoAdjective.
  ///
  /// In en, this message translates to:
  /// **'No-adjective'**
  String get posNoAdjective;

  /// No description provided for @posExpression.
  ///
  /// In en, this message translates to:
  /// **'Expression'**
  String get posExpression;

  /// No description provided for @posConjunction.
  ///
  /// In en, this message translates to:
  /// **'Conjunction'**
  String get posConjunction;

  /// No description provided for @posInterjection.
  ///
  /// In en, this message translates to:
  /// **'Interjection'**
  String get posInterjection;

  /// No description provided for @posPronoun.
  ///
  /// In en, this message translates to:
  /// **'Pronoun'**
  String get posPronoun;

  /// No description provided for @posNumeral.
  ///
  /// In en, this message translates to:
  /// **'Numeral'**
  String get posNumeral;

  /// No description provided for @posPrefix.
  ///
  /// In en, this message translates to:
  /// **'Prefix'**
  String get posPrefix;

  /// No description provided for @posSuffix.
  ///
  /// In en, this message translates to:
  /// **'Suffix'**
  String get posSuffix;

  /// No description provided for @posParticle.
  ///
  /// In en, this message translates to:
  /// **'Particle'**
  String get posParticle;

  /// No description provided for @posCounter.
  ///
  /// In en, this message translates to:
  /// **'Counter'**
  String get posCounter;

  /// No description provided for @posAuxiliaryVerb.
  ///
  /// In en, this message translates to:
  /// **'Aux. verb'**
  String get posAuxiliaryVerb;

  /// No description provided for @posAuxiliary.
  ///
  /// In en, this message translates to:
  /// **'Auxiliary'**
  String get posAuxiliary;

  /// No description provided for @posPreNounAdj.
  ///
  /// In en, this message translates to:
  /// **'Pre-noun adj.'**
  String get posPreNounAdj;

  /// No description provided for @posAdjIxClass.
  ///
  /// In en, this message translates to:
  /// **'Adj. (ii/yoi)'**
  String get posAdjIxClass;

  /// No description provided for @posPrenominalAdj.
  ///
  /// In en, this message translates to:
  /// **'Prenominal adj.'**
  String get posPrenominalAdj;

  /// No description provided for @posNounSuffix.
  ///
  /// In en, this message translates to:
  /// **'Noun suffix'**
  String get posNounSuffix;

  /// No description provided for @posNounPrefix.
  ///
  /// In en, this message translates to:
  /// **'Noun prefix'**
  String get posNounPrefix;

  /// No description provided for @posSuruSpecial.
  ///
  /// In en, this message translates to:
  /// **'Suru verb (special)'**
  String get posSuruSpecial;

  /// No description provided for @posSuruIrregular.
  ///
  /// In en, this message translates to:
  /// **'Suru verb (irreg.)'**
  String get posSuruIrregular;

  /// No description provided for @levelN5.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get levelN5;

  /// No description provided for @levelN4.
  ///
  /// In en, this message translates to:
  /// **'Elementary'**
  String get levelN4;

  /// No description provided for @levelN3.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get levelN3;

  /// No description provided for @levelN2.
  ///
  /// In en, this message translates to:
  /// **'Upper-Intermediate'**
  String get levelN2;

  /// No description provided for @levelN1.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get levelN1;

  /// No description provided for @charactersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Kana · Kanji N5–N1 · {total} kana'**
  String charactersSubtitle(int total);

  /// No description provided for @charactersSubtitleShort.
  ///
  /// In en, this message translates to:
  /// **'Kana · Kanji N5–N1'**
  String get charactersSubtitleShort;

  /// No description provided for @nKanji.
  ///
  /// In en, this message translates to:
  /// **'{count} kanji'**
  String nKanji(int count);

  /// No description provided for @knownProgress.
  ///
  /// In en, this message translates to:
  /// **'{known} / {total} known'**
  String knownProgress(int known, int total);

  /// No description provided for @kanaRowVowels.
  ///
  /// In en, this message translates to:
  /// **'Vowels'**
  String get kanaRowVowels;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light mode'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get settingsThemeDark;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String aboutVersion(String version);

  /// No description provided for @aboutDataSources.
  ///
  /// In en, this message translates to:
  /// **'Data sources'**
  String get aboutDataSources;

  /// No description provided for @aboutEdrdgNotice.
  ///
  /// In en, this message translates to:
  /// **'This app uses JMdict and KANJIDIC2, published by the Electronic Dictionary Research and Development Group (EDRDG) under a Creative Commons Attribution-ShareAlike 4.0 International licence.'**
  String get aboutEdrdgNotice;

  /// No description provided for @aboutEdrdgLink.
  ///
  /// In en, this message translates to:
  /// **'edrdg.org'**
  String get aboutEdrdgLink;

  /// No description provided for @aboutOpenSourceLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open source licenses'**
  String get aboutOpenSourceLicenses;

  /// No description provided for @practiceSessionDone.
  ///
  /// In en, this message translates to:
  /// **'Session complete'**
  String get practiceSessionDone;

  /// No description provided for @practiceReviewed.
  ///
  /// In en, this message translates to:
  /// **'{count} reviewed'**
  String practiceReviewed(int count);

  /// No description provided for @practiceGotIt.
  ///
  /// In en, this message translates to:
  /// **'{count} got it'**
  String practiceGotIt(int count);

  /// No description provided for @practiceNotYet.
  ///
  /// In en, this message translates to:
  /// **'{count} not yet'**
  String practiceNotYet(int count);

  /// No description provided for @practiceEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing to review — come back tomorrow!'**
  String get practiceEmpty;

  /// No description provided for @practiceDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get practiceDone;

  /// No description provided for @srsStateNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get srsStateNew;

  /// No description provided for @srsStateLearning.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get srsStateLearning;

  /// No description provided for @srsStateApprentice.
  ///
  /// In en, this message translates to:
  /// **'Apprentice'**
  String get srsStateApprentice;

  /// No description provided for @srsStateFamiliar.
  ///
  /// In en, this message translates to:
  /// **'Familiar'**
  String get srsStateFamiliar;

  /// No description provided for @srsStateMastered.
  ///
  /// In en, this message translates to:
  /// **'Mastered'**
  String get srsStateMastered;

  /// No description provided for @srsStateExpert.
  ///
  /// In en, this message translates to:
  /// **'Expert'**
  String get srsStateExpert;

  /// No description provided for @srsDueToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get srsDueToday;

  /// No description provided for @srsDueIn.
  ///
  /// In en, this message translates to:
  /// **'Due in {days}d'**
  String srsDueIn(int days);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
