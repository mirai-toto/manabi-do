import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import '../services/writing_session_service.dart';

export '../services/writing_session_service.dart' show WritingSessionArgs;

// ── Provider ──────────────────────────────────────────────────────────────────

/// Loads and shuffles the kanji queue for a writing session.
/// autoDispose ensures the list is regenerated (and reshuffled) each time
/// the screen is entered or [ref.invalidate] is called (on restart).
final writingKanjiProvider = FutureProvider.autoDispose
    .family<List<(Kanji, String)>, WritingSessionArgs>(
      (ref, args) =>
          ref.read(writingSessionServiceProvider).buildQueue(args: args),
    );
