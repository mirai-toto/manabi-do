import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manabi_do/core/providers/locale_provider.dart';
import 'package:manabi_do/core/theme/app_theme.dart';
import 'package:manabi_do/data/database/app_database.dart';
import 'package:manabi_do/presentation/providers/vocabulary_provider.dart';
import 'package:manabi_do/presentation/widgets/characters/kanji_example_words.dart';
import 'package:manabi_do/core/text/sentence_language.dart';
import 'package:manabi_do/l10n/app_localizations.dart';
import 'package:manabi_do/presentation/widgets/common/label/translation_fallback_info.dart';

void main() {
  test('readerLanguageName names the reader language', () {
    expect(readerLanguageName('fr'), 'Français');
    expect(readerLanguageName('de'), 'Deutsch');
    expect(readerLanguageName('en'), 'English');
  });

  testWidgets('the mark renders an icon', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('fr'),
        home: const Scaffold(
          body: TranslationFallbackInfo(language: 'Français'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.info_outline_rounded), findsOneWidget);
  });

  testWidgets('only the untranslated example word is marked', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          localeProvider.overrideWith(_FakeLocale.new),
          localizedKanjiVocabularyProvider((kanjiId: 27598)).overrideWith(
            (ref) async => [
              (
                entry: _entry(1, '毎日'),
                meaning: 'chaque jour',
                translated: true,
              ),
              (
                entry: _entry(2, '毎回'),
                meaning: 'every time',
                translated: false,
              ),
            ],
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('fr'),
          home: const Scaffold(
            body: SingleChildScrollView(
              child: KanjiExampleWords(kanji: _kanji),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.info_outline_rounded), findsOneWidget);
  });

  testWidgets('a truncated meaning still shows the mark', (tester) async {
    // A trailing mark is dropped from layout entirely when the line is
    // clipped — its rect comes back NaN — so this asserts the mark is really
    // laid out inside the box, not merely present in the tree.
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('fr'),
        home: const Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              key: Key('box'),
              width: 90,
              child: TranslatedText(
                'once; one time; one round; one game; once more; one more time',
                missingLanguage: 'Français',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final Rect box = tester.getRect(find.byKey(const Key('box')));
    final Rect mark = tester.getRect(find.byIcon(Icons.info_outline_rounded));
    expect(mark.left.isFinite, isTrue, reason: 'the mark was never laid out');
    expect(mark.right, lessThanOrEqualTo(box.right + 0.5));
    expect(mark.bottom, lessThanOrEqualTo(box.bottom + 0.5));
  });

  testWidgets('TranslatedText shows the mark only when asked', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('fr'),
        home: const Scaffold(
          body: Column(
            children: [
              TranslatedText('plain', missingLanguage: null),
              TranslatedText('marked', missingLanguage: 'Français'),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.info_outline_rounded), findsOneWidget);
  });
}

/// The real question: does the section heading mark itself when the provider
/// reports a word it could not translate?
class _FakeLocale extends LocaleNotifier {
  @override
  Locale build() => const Locale('fr');
}

const _kanji = Kanji(
  id: 27598,
  character: '毎',
  meaning: 'every',
  onReading: 'マイ',
  kunReading: '',
  jlptLevel: 'N5',
);

VocabularyEntry _entry(int id, String word) => VocabularyEntry(
  id: id,
  word: word,
  reading: '',
  meaning: 'every time',
  difficulty: id,
  vocabularyLevel: 1,
  groupIndex: 1,
  partOfSpeech: '',
  difficultySource: 'jmdict',
);
