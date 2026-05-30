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
  String get sectionCharacters => 'Characters';

  @override
  String get sectionGrammar => 'Grammar';

  @override
  String get tabHiragana => 'Hiragana';

  @override
  String get tabKatakana => 'Katakana';

  @override
  String get tabKanji => 'Kanji';

  @override
  String get known => 'Known';

  @override
  String get notKnown => 'Not known';
}
