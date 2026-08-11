import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mastery/models/topic_model.dart';

class TopicContentService {
  // Registry of category to its constituent topic IDs.
  static const Map<String, List<String>> _categoryTopics = {
    'widgets': ['container', 'text', 'card', 'icon', 'image', 'buttons', 'textfield'],
  };

  /// Resolves the category for a topic ID dynamically.
  String getCategoryForTopic(String topicId) {
    final normalizedId = topicId.toLowerCase();
    for (final entry in _categoryTopics.entries) {
      if (entry.value.contains(normalizedId)) {
        return entry.key;
      }
    }
    return 'widgets';
  }

  /// Loads the metadata config (`info.json`) for a specific topic under a category.
  Future<TopicModel> getTopicInfo(String category, String topicId) async {
    final path = 'assets/topics/${category.toLowerCase()}/${topicId.toLowerCase()}/info.json';
    final jsonStr = await rootBundle.loadString(path);
    final Map<String, dynamic> jsonMap = json.decode(jsonStr);
    return TopicModel.fromJson(jsonMap);
  }

  /// Retrieves all available topics within a category.
  Future<List<TopicModel>> getTopicsForCategory(String category) async {
    final normalizedCategory = category.toLowerCase();
    final topicIds = _categoryTopics[normalizedCategory] ?? [];
    final List<TopicModel> topics = [];
    
    for (final id in topicIds) {
      try {
        final topic = await getTopicInfo(normalizedCategory, id);
        topics.add(topic);
      } catch (e) {
        if (kDebugMode) {
          print('Failed to load topic "$id" in category "$category": $e');
        }
      }
    }
    return topics;
  }

  /// Loads a specific markdown content file (e.g. explanation.md) for a topic.
  Future<String> loadMarkdownContent(String category, String topicId, String fileName) async {
    try {
      final path = 'assets/topics/${category.toLowerCase()}/${topicId.toLowerCase()}/$fileName';
      return await rootBundle.loadString(path);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load markdown asset "$fileName" for topic "$topicId": $e');
      }
      return '### Content Unavailable\nThe content file "$fileName" could not be loaded.';
    }
  }
}
