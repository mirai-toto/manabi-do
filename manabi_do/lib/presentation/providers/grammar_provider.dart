import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/locale_provider.dart';
import '../../data/grammar/grammar_models.dart';

export '../../data/grammar/grammar_models.dart';

class GrammarChapter {
  final String title;

  // Markdown path: non-empty, lessons is empty.
  final String content;

  // JSON path: non-empty, content is empty.
  final List<GrammarLesson> lessons;

  const GrammarChapter({
    required this.title,
    this.content = '',
    this.lessons = const [],
  });

  bool get isJson => lessons.isNotEmpty;
}

Future<String> _loadAssetWithFallback(String primary, String fallback) async {
  try {
    return await rootBundle.loadString(primary);
  } catch (_) {
    return rootBundle.loadString(fallback);
  }
}

// ── Markdown provider (N5, still MD-based) ────────────────────────────────────

final grammarChaptersProvider =
    FutureProvider.family<List<GrammarChapter>, String>((ref, level) async {
      final lang = ref.watch(localeProvider).languageCode;
      final raw = lang == 'en'
          ? await rootBundle.loadString('assets/grammar/$level.md')
          : await _loadAssetWithFallback(
              'assets/grammar/${level}_$lang.md',
              'assets/grammar/$level.md',
            );
      return _parseMarkdownChapters(raw);
    });

List<GrammarChapter> _parseMarkdownChapters(String raw) {
  final chapters = <GrammarChapter>[];
  final lines = raw.split('\n');
  int? startLine;
  String? currentTitle;

  for (int i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (line.startsWith('## ')) {
      if (currentTitle != null && startLine != null) {
        final content = lines.sublist(startLine, i).join('\n').trim();
        chapters.add(GrammarChapter(title: currentTitle, content: content));
      }
      currentTitle = line.substring(3).trim();
      startLine = i;
    }
  }
  if (currentTitle != null && startLine != null) {
    final content = lines.sublist(startLine).join('\n').trim();
    chapters.add(GrammarChapter(title: currentTitle, content: content));
  }
  return chapters;
}

// ── JSON provider (basics, and future levels) ─────────────────────────────────

final grammarJsonChaptersProvider =
    FutureProvider.family<List<GrammarChapter>, String>((ref, level) async {
      final lang = ref.watch(localeProvider).languageCode;
      final raw = lang == 'en'
          ? await rootBundle.loadString('assets/grammar/$level.json')
          : await _loadAssetWithFallback(
              'assets/grammar/${level}_$lang.json',
              'assets/grammar/$level.json',
            );
      final data = jsonDecode(raw) as Map<String, dynamic>;
      return (data['chapters'] as List<dynamic>).map((c) {
        final lessons = (c['lessons'] as List<dynamic>)
            .map((l) => GrammarLesson.fromJson(Map<String, dynamic>.from(l)))
            .toList();
        return GrammarChapter(title: c['title'] as String, lessons: lessons);
      }).toList();
    });
