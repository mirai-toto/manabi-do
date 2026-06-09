import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GrammarChapter {
  final String title;
  final String content;
  const GrammarChapter({required this.title, required this.content});
}

final grammarChaptersProvider = FutureProvider.family<List<GrammarChapter>, String>(
  (ref, level) async {
    final raw = await rootBundle.loadString('assets/grammar/$level.md');
    return _parseChapters(raw);
  },
);

List<GrammarChapter> _parseChapters(String raw) {
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
