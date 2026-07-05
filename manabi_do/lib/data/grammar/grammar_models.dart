class GrammarBlock {
  final String type;
  final Map<String, dynamic> data;

  const GrammarBlock({required this.type, required this.data});

  factory GrammarBlock.fromJson(Map<String, dynamic> json) {
    return GrammarBlock(
      type: json['type'] as String,
      data: Map<String, dynamic>.from(json),
    );
  }
}

class GrammarLesson {
  final String id;
  final String title;
  final List<GrammarBlock> blocks;

  const GrammarLesson({
    required this.id,
    required this.title,
    required this.blocks,
  });

  factory GrammarLesson.fromJson(Map<String, dynamic> json) {
    return GrammarLesson(
      id: json['id'] as String,
      title: json['title'] as String,
      blocks: (json['blocks'] as List<dynamic>)
          .map((b) => GrammarBlock.fromJson(Map<String, dynamic>.from(b)))
          .toList(),
    );
  }
}
