class GrammarLesson {
  final int id;
  final String locale;
  final String chapter;
  final String title;
  final String contentMd;
  final int orderIndex;
  final Map<String, dynamic> metadata;

  const GrammarLesson({
    required this.id,
    required this.locale,
    required this.chapter,
    required this.title,
    required this.contentMd,
    required this.orderIndex,
    required this.metadata,
  });
}
