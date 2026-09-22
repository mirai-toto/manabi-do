import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsrs/fsrs.dart' show Rating;

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/l10n.dart';
import '../../providers/practice_session_provider.dart';
import '../../widgets/widgets.dart';
import '../characters/kanji/kanji_detail_screen.dart';

/// Everything answered so far in the current session, with the grade of any of
/// them open to being changed.
///
/// Pushed from the session app bar and reads the same provider the session
/// does, so a re-grade is reflected the moment the user comes back.
class SessionReviewScreen extends ConsumerStatefulWidget {
  /// Whether grades are written through to the SRS. False for free practice,
  /// where re-grading only moves the session's own score.
  final bool persistSrs;

  const SessionReviewScreen({super.key, required this.persistSrs});

  @override
  ConsumerState<SessionReviewScreen> createState() =>
      _SessionReviewScreenState();
}

class _SessionReviewScreenState extends ConsumerState<SessionReviewScreen> {
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

  void _regrade(int index, Rating rating) => ref
      .read(practiceSessionProvider.notifier)
      .regrade(index, rating, persistSrs: widget.persistSrs);

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
    final session = ref.watch(practiceSessionProvider);
    final answers = session.answers;
    final total = session.queue?.length ?? answers.length;

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
                l.sessionReviewCount(answers.length, total),
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
                  onRegrade: (rating) => _regrade(i, rating),
                  onDetailTap: _detailTapFor(a.srsType, a.id),
                );
              },
            ),
    );
  }
}
