class TopicProperty {
  final String name;
  final String usage;
  final String description;

  TopicProperty({
    required this.name,
    required this.usage,
    required this.description,
  });

  factory TopicProperty.fromJson(Map<String, dynamic> json) {
    return TopicProperty(
      name: json['name'] as String? ?? '',
      usage: json['usage'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'usage': usage,
      'description': description,
    };
  }
}

class TopicModel {
  final String id;
  final String title;
  final String subtitle;
  final String category;
  final String difficulty;
  final List<String> tags;
  final List<String> searchKeywords;
  final String previewType;
  final List<TopicProperty> properties;

  TopicModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.difficulty,
    required this.tags,
    required this.searchKeywords,
    required this.previewType,
    required this.properties,
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
      properties: (json['properties'] as List<dynamic>?)
              ?.map((e) => TopicProperty.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
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
      'properties': properties.map((e) => e.toJson()).toList(),
    };
  }
}
