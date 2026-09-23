import 'package:flutter/material.dart' hide Card;
import 'package:fsrs/fsrs.dart' show Rating;

import '../../../core/models/practice_answer.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../widgets/widgets.dart';
import '../characters/kanji/kanji_detail_screen.dart';

/// Everything answered so far in a session, with the grade of any of them open
/// to being changed where the session has grades to change.
///
/// Takes its answers rather than reading a provider, because the two kinds of
/// session keep them in different places: a review session in
/// `practiceSessionProvider`, a writing session in its own state.
class SessionReviewScreen extends StatefulWidget {
  final List<SessionAnswer> answers;

  /// How many items the session holds in total, for the "8 of 20" counter.
  final int total;

  /// Null where nothing can be re-graded, which is every free-practice session:
  /// there is no SRS row to rewrite and no score to move.
  final void Function(int index, Rating rating)? onRegrade;

  const SessionReviewScreen({
    super.key,
    required this.answers,
    required this.total,
    this.onRegrade,
  });

  @override
  State<SessionReviewScreen> createState() => _SessionReviewScreenState();
}

class _SessionReviewScreenState extends State<SessionReviewScreen> {
  /// One row open at a time, so a long panel never buries the rest of the list.
  int? _expandedIndex;

  final Map<int, GlobalKey> _rowKeys = {};

  GlobalKey _keyFor(int index) => _rowKeys.putIfAbsent(index, GlobalKey.new);

  void _toggle(int index) {
    setState(() => _expandedIndex = _expandedIndex == index ? null : index);
    if (_expandedIndex != index) return;
    // Bring the row just opened to the top, so its panel grows downward into
    // empty space rather than pushing the row it belongs to out of sight.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final rowContext = _keyFor(index).currentContext;
      if (rowContext == null) return;
      Scrollable.ensureVisible(
        rowContext,
        alignment: 0,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
    });
  }

  /// Kanji is the only item with a screen of its own, so it is the only one
  /// that gets a detail link.
  VoidCallback? _detailTapFor(String srsType, int id) => srsType == 'kanji'
      ? () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => KanjiDetailScreen(kanjiId: id),
          ),
        )
      : null;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final l = context.l10n;
    final answers = widget.answers;

    return Scaffold(
      backgroundColor: t.surface,
      appBar: AppBar(
        backgroundColor: t.surface,
        elevation: 0,
        title: Text(
          l.sessionReview,
          style: AppTextStyles.title.copyWith(color: t.onSurface),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppDimens.spaceMd),
            child: Center(
              child: Text(
                l.sessionReviewCount(answers.length, widget.total),
                style: AppTextStyles.bodySmall.copyWith(
                  color: t.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
      body: answers.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.spaceLg),
                child: Text(
                  l.sessionReviewEmpty,
                  style: AppTextStyles.body.copyWith(color: t.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppDimens.spaceMd),
              itemCount: answers.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: AppDimens.spaceSm),
              itemBuilder: (context, i) {
                final a = answers[i];
                return SessionReviewRow(
                  key: _keyFor(i),
                  summary: a.summary,
                  rating: a.rating,
                  given: a.given,
                  mistakes: a.mistakes,
                  card: a.card,
                  isExpanded: _expandedIndex == i,
                  onToggle: () => _toggle(i),
                  onRegrade: widget.onRegrade == null
                      ? null
                      : (rating) => widget.onRegrade!(i, rating),
                  onDetailTap: _detailTapFor(a.srsType, a.id),
                );
              },
            ),
    );
  }
}
