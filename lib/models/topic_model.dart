class TopicModel {
  final String id;
  final String title;
  final String subtitle;
  final String category;
  final String difficulty;
  final List<String> tags;
  final List<String> searchKeywords;
  final String previewType;

  TopicModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.difficulty,
    required this.tags,
    required this.searchKeywords,
    required this.previewType,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      category: json['category'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      searchKeywords: (json['searchKeywords'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      previewType: json['previewType'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'category': category,
      'difficulty': difficulty,
      'tags': tags,
      'searchKeywords': searchKeywords,
      'previewType': previewType,
    };
  }
}
