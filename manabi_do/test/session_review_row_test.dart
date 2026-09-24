import 'package:flutter/material.dart' hide Card;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fsrs/fsrs.dart' show Rating;
import 'package:manabi_do/core/models/practice_answer.dart';
import 'package:manabi_do/core/theme/app_theme.dart';
import 'package:manabi_do/l10n/app_localizations.dart';
import 'package:manabi_do/presentation/screens/practice/session_review_screen.dart';
import 'package:manabi_do/presentation/widgets/exercise/session_review_row.dart';

/// Free practice passes no `onRegrade`, so the grade buttons must not be built
/// at all. They used to be, and tapping one threw a null check — the callback
/// was gated in the header but not in the panel.
void main() {
  Widget host({void Function(Rating)? onRegrade}) => MaterialApp(
    theme: AppTheme.light,
    locale: const Locale('en'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en')],
    home: Scaffold(
      body: SingleChildScrollView(
        child: SessionReviewRow(
          summary: const PracticeSummary(
            item: '山',
            question: _drawPrompt,
            answer: 'mountain',
            kindLabel: _writingLabel,
            selfAssessed: true,
          ),
          rating: Rating.again,
          mistakes: 2,
          card: null,
          isExpanded: true,
          onToggle: () {},
          onRegrade: onRegrade,
        ),
      ),
    ),
  );

  testWidgets('no grade buttons when the grade cannot be changed', (
    tester,
  ) async {
    await tester.pumpWidget(host());
    await tester.pumpAndSettle();

    expect(find.text('Change the grade'), findsNothing);
    expect(find.text('Again'), findsOneWidget); // the rating pill, not a button
    expect(find.text('Hard'), findsNothing);
    expect(find.text('Easy'), findsNothing);
  });

  testWidgets('grade buttons appear and fire when re-grading is allowed', (
    tester,
  ) async {
    Rating? picked;
    await tester.pumpWidget(host(onRegrade: (r) => picked = r));
    await tester.pumpAndSettle();

    expect(find.text('Change the grade'), findsOneWidget);
    expect(find.text('Hard'), findsOneWidget);

    await tester.tap(find.text('Easy'));
    await tester.pump();
    expect(picked, Rating.easy);
  });

  _screenGroup();
}

String _drawPrompt(AppLocalizations l) => l.reviewDrawPrompt('mountain');
String _writingLabel(AppLocalizations l) => l.reviewKindKanjiWriting;

/// The screen is prop-driven, so a re-grade has to arrive as a new `answers`
/// list. It regressed once: the route captured the list when it was pushed, so
/// the open review kept showing the old grade until it was closed and reopened.
void _screenGroup() {
  SessionAnswer answer(Rating rating) => SessionAnswer(
    srsType: 'kanji',
    id: 1,
    card: null,
    rating: rating,
    summary: const PracticeSummary(
      item: '山',
      question: _drawPrompt,
      answer: 'mountain',
      kindLabel: _writingLabel,
      selfAssessed: true,
    ),
  );

  Widget host(List<SessionAnswer> answers) => MaterialApp(
    theme: AppTheme.light,
    locale: const Locale('en'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en')],
    home: SessionReviewScreen(answers: answers, total: 1),
  );

  testWidgets('a changed grade shows without reopening the screen', (
    tester,
  ) async {
    await tester.pumpWidget(host([answer(Rating.again)]));
    await tester.pumpAndSettle();
    expect(find.text('Again'), findsOneWidget);
    expect(find.text('Good'), findsNothing);

    await tester.pumpWidget(host([answer(Rating.good)]));
    await tester.pumpAndSettle();
    expect(find.text('Good'), findsOneWidget);
    expect(find.text('Again'), findsNothing);
  });
}
