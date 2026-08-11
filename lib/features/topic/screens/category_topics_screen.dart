import 'package:flutter/material.dart';
import 'package:flutter_mastery/core/theme/app_colors.dart';
import 'package:flutter_mastery/core/theme/app_text_styles.dart';
import 'package:flutter_mastery/features/topic/screens/topic_details_screen.dart';
import 'package:flutter_mastery/models/topic_model.dart';
import 'package:flutter_mastery/services/topic_content_service.dart';

class CategoryTopicsScreen extends StatefulWidget {
  final String category;

  const CategoryTopicsScreen({super.key, required this.category});

  @override
  State<CategoryTopicsScreen> createState() => _CategoryTopicsScreenState();
}

class _CategoryTopicsScreenState extends State<CategoryTopicsScreen> {
  final TopicContentService _contentService = TopicContentService();
  late Future<List<TopicModel>> _topicsFuture;

  @override
  void initState() {
    super.initState();
    _topicsFuture = _contentService.getTopicsForCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.darkTextPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.category,
          style: AppTextStyles.displaySmall(
            color: AppColors.darkTextPrimary,
          ).copyWith(fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.darkBorder, height: 1),
        ),
      ),
      body: FutureBuilder<List<TopicModel>>(
        future: _topicsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load topics.',
                style: AppTextStyles.bodyMedium(color: AppColors.error),
              ),
            );
          }

          final topics = snapshot.data ?? [];

          if (topics.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'No topics available under category "${widget.category}" yet.',
                  style: AppTextStyles.bodyMedium(
                    color: AppColors.darkTextSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20.0),
            physics: const BouncingScrollPhysics(),
            itemCount: topics.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final topic = topics[index];
              return _TopicCard(
                topic: topic,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TopicDetailsScreen(
                        category: widget.category,
                        topicId: topic.id,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final TopicModel topic;
  final VoidCallback onTap;

  const _TopicCard({required this.topic, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final diffColor = _getDifficultyColor(topic.difficulty);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Difficulty Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: diffColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: diffColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        topic.difficulty.toUpperCase(),
                        style: AppTextStyles.labelSmall(
                          color: diffColor,
                        ).copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.darkTextMuted,
                      size: 16,
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Topic Title
                Text(
                  topic.title,
                  style: AppTextStyles.headingLarge(
                    color: AppColors.darkTextPrimary,
                  ).copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 6),

                // Topic Subtitle
                Text(
                  topic.subtitle,
                  style: AppTextStyles.bodyMedium(
                    color: AppColors.darkTextSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 14),

                // Tags
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: topic.tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.darkSurfaceVariant,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.darkBorder),
                      ),
                      child: Text(
                        '#$tag',
                        style: AppTextStyles.labelSmall(
                          color: AppColors.darkTextSecondary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return AppColors.success;
      case 'intermediate':
        return AppColors.warning;
      case 'advanced':
        return AppColors.error;
      default:
        return AppColors.success;
    }
  }
}
