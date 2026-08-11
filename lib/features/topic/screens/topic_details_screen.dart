import 'package:flutter/material.dart';
import 'package:flutter_mastery/core/theme/app_colors.dart';
import 'package:flutter_mastery/core/theme/app_text_styles.dart';
import 'package:flutter_mastery/features/topic/widgets/topic_tabs.dart';
import 'package:flutter_mastery/features/topic/widgets/topic_code_view.dart';
import 'package:flutter_mastery/features/topic/widgets/topic_explanation_view.dart';
import 'package:flutter_mastery/features/topic/widgets/topic_interview_view.dart';
import 'package:flutter_mastery/live_previews/preview_registry.dart';
import 'package:flutter_mastery/models/topic_model.dart';
import 'package:flutter_mastery/services/topic_content_service.dart';

class TopicDetailsScreen extends StatefulWidget {
  final String topicId;
  final String? category;

  const TopicDetailsScreen({super.key, required this.topicId, this.category});

  @override
  State<TopicDetailsScreen> createState() => _TopicDetailsScreenState();
}

class _TopicDetailsScreenState extends State<TopicDetailsScreen> {
  final TopicContentService _contentService = TopicContentService();
  late final String _category;
  late final Future<TopicModel> _topicFuture;

  int _selectedTabIndex = 0;
  bool _isBookmarked = false;

  final List<String> _tabs = const [
    'Overview',
    'Properties',
    'Code',
    'Explanation',
    'Interview',
  ];

  @override
  void initState() {
    super.initState();
    _category =
        widget.category ?? _contentService.getCategoryForTopic(widget.topicId);
    _topicFuture = _contentService.getTopicInfo(_category, widget.topicId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TopicModel>(
      future: _topicFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: AppColors.darkBackground,
            body: const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        } else if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            backgroundColor: AppColors.darkBackground,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Center(
              child: Text(
                'Topic details not found.',
                style: AppTextStyles.bodyMedium(color: AppColors.error),
              ),
            ),
          );
        }

        final topic = snapshot.data!;

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
              topic.title,
              style: AppTextStyles.headingMedium(
                color: AppColors.darkTextPrimary,
              ).copyWith(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _isBookmarked
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: _isBookmarked
                      ? AppColors.primary
                      : AppColors.darkTextSecondary,
                ),
                onPressed: () {
                  setState(() {
                    _isBookmarked = !_isBookmarked;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _isBookmarked
                            ? 'Bookmarked successfully!'
                            : 'Bookmark removed.',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              // Premium horizontal tab selector
              TopicTabs(
                selectedIndex: _selectedTabIndex,
                onTabSelected: (index) {
                  setState(() {
                    _selectedTabIndex = index;
                  });
                },
                tabs: _tabs,
              ),

              // Dynamic view panel based on selection
              Expanded(child: _buildSelectedTabView(topic)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSelectedTabView(TopicModel topic) {
    switch (_selectedTabIndex) {
      case 0:
        return _buildOverviewTab(topic);
      case 1:
        return _buildPropertiesTab(topic);
      case 2:
        return TopicCodeView(
          category: _category,
          topicId: topic.id,
          contentService: _contentService,
        );
      case 3:
        return TopicExplanationView(
          category: _category,
          topicId: topic.id,
          contentService: _contentService,
        );
      case 4:
        return TopicInterviewView(
          category: _category,
          topicId: topic.id,
          contentService: _contentService,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildOverviewTab(TopicModel topic) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Styled Card for description
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        topic.difficulty.toUpperCase(),
                        style: AppTextStyles.labelSmall(
                          color: AppColors.primary,
                        ).copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
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
                        topic.category.toUpperCase(),
                        style: AppTextStyles.labelSmall(
                          color: AppColors.darkTextSecondary,
                        ).copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  topic.title,
                  style: AppTextStyles.headingLarge(
                    color: AppColors.darkTextPrimary,
                  ).copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  topic.subtitle,
                  style: AppTextStyles.bodyMedium(
                    color: AppColors.darkTextSecondary,
                  ).copyWith(height: 1.5),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Live preview header
          Text(
            'Widget Visual Preview',
            style: AppTextStyles.headingLarge(
              color: AppColors.darkTextPrimary,
            ).copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'This is a visual representation of the Widget design.',
            style: AppTextStyles.bodySmall(color: AppColors.darkTextMuted),
          ),
          const SizedBox(height: 12),

          // Actual live preview widget
          getTopicPreview(topic.previewType),

          const SizedBox(height: 24),

          // Tags section
          Wrap(
            spacing: 8,
            runSpacing: -4,
            children: topic.tags.map((t) {
              return Chip(
                backgroundColor: AppColors.darkSurface,
                side: const BorderSide(color: AppColors.darkBorder),
                label: Text(
                  '#$t',
                  style: AppTextStyles.labelSmall(
                    color: AppColors.darkTextSecondary,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertiesTab(TopicModel topic) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20.0),
      children: [
        Text(
          '${topic.title} Properties Detail',
          style: AppTextStyles.headingLarge(
            color: AppColors.darkTextPrimary,
          ).copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          'Comprehensive reference guide of standard properties in a ${topic.title} widget.',
          style: AppTextStyles.bodyMedium(color: AppColors.darkTextSecondary),
        ),
        const Divider(color: AppColors.darkBorder, height: 32),

        if (topic.properties.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                'No properties reference available for this widget.',
                style: AppTextStyles.bodyMedium(color: AppColors.darkTextMuted),
              ),
            ),
          )
        else
          ...topic.properties.map(
            (prop) => _buildDetailPropertyTile(
              title: prop.name,
              usage: prop.usage,
              description: prop.description,
            ),
          ),
      ],
    );
  }

  Widget _buildDetailPropertyTile({
    required String title,
    required String usage,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.headingMedium(
              color: AppColors.primary,
            ).copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: AppTextStyles.bodyMedium(color: AppColors.darkTextSecondary),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.codeBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              usage,
              style: AppTextStyles.codeStyle(color: AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }
}
