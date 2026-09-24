import 'package:flutter/material.dart' hide Card;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fsrs/fsrs.dart' show Rating;
import 'package:manabi_do/core/models/practice_answer.dart';
import 'package:manabi_do/core/theme/app_theme.dart';
import 'package:manabi_do/l10n/app_localizations.dart';
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
}

String _drawPrompt(AppLocalizations l) => l.reviewDrawPrompt('mountain');
String _writingLabel(AppLocalizations l) => l.reviewKindKanjiWriting;
