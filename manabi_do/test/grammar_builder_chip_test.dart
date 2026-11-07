import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:manabi_do/core/theme/app_palette.dart';
import 'package:manabi_do/core/theme/app_theme.dart';
import 'package:manabi_do/l10n/app_localizations.dart';
import 'package:manabi_do/presentation/widgets/exercise/grammar_builder_body.dart';

/// The sentence builder's word chips mix kana-only parts ("テレビを") with
/// `{kanji|reading}` parts ("{見|み}ながら"). The pill must be one height for
/// both: a kana-only word centres itself, while a word with furigana keeps the
/// reading above the base line.
void main() {
  testWidgets('builder chips keep one height and centre a kana word', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(AppPalette.fallback),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(
          body: GrammarBuilderBody(
            parts: const ['テレビを', '{見|み}ながら'],
            translation: 'I eat dinner while watching TV.',
            index: 0,
            total: 2,
            color: const Color(0xFF5C6BC0),
            fourPointGrading: true,
            onAnswer: (_, {given, mistakes}) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final kanaChip = tester.getRect(find.bySemanticsLabel('テレビを'));
    final annotatedChip = tester.getRect(find.bySemanticsLabel('{見|み}ながら'));
    expect(kanaChip.height, moreOrLessEquals(annotatedChip.height, epsilon: 1));

    // The kana-only word is centred in its pill.
    final kanaText = tester.getRect(find.text('テレビを'));
    expect(
      kanaText.top - kanaChip.top,
      moreOrLessEquals(kanaChip.bottom - kanaText.bottom, epsilon: 1),
    );
  });
}
