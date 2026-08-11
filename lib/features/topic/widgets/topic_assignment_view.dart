import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_mastery/core/theme/app_colors.dart';
import 'package:flutter_mastery/core/theme/app_text_styles.dart';
import 'package:flutter_mastery/services/topic_content_service.dart';

class TopicAssignmentView extends StatefulWidget {
  final String category;
  final String topicId;
  final TopicContentService contentService;

  const TopicAssignmentView({
    super.key,
    required this.category,
    required this.topicId,
    required this.contentService,
  });

  @override
  State<TopicAssignmentView> createState() => _TopicAssignmentViewState();
}

class _TopicAssignmentViewState extends State<TopicAssignmentView> {
  late Future<String> _contentFuture;

  @override
  void initState() {
    super.initState();
    _contentFuture = widget.contentService.loadMarkdownContent(
      widget.category,
      widget.topicId,
      'assignment.md',
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _contentFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading assignment instructions',
              style: AppTextStyles.bodyMedium(color: AppColors.error),
            ),
          );
        }

        final markdownData = snapshot.data ?? '';

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: MarkdownBody(
            data: markdownData,
            selectable: true,
            styleSheet: MarkdownStyleSheet(
              p: AppTextStyles.bodyMedium(color: AppColors.darkTextSecondary).copyWith(height: 1.6),
              h1: AppTextStyles.displaySmall(color: AppColors.darkTextPrimary).copyWith(
                fontWeight: FontWeight.bold,
                height: 2.0,
              ),
              h2: AppTextStyles.headingLarge(color: AppColors.darkTextPrimary).copyWith(
                fontWeight: FontWeight.bold,
                height: 1.8,
              ),
              h3: AppTextStyles.headingMedium(color: AppColors.primary).copyWith(
                fontWeight: FontWeight.bold,
                height: 1.6,
              ),
              listBullet: AppTextStyles.bodyMedium(color: AppColors.primary),
              code: AppTextStyles.codeStyle(color: AppColors.accent).copyWith(
                backgroundColor: AppColors.darkSurfaceVariant,
              ),
              codeblockPadding: const EdgeInsets.all(12),
              codeblockDecoration: BoxDecoration(
                color: AppColors.codeBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.darkBorder),
              ),
              blockquoteDecoration: BoxDecoration(
                color: AppColors.darkSurfaceVariant,
                borderRadius: BorderRadius.circular(8),
                border: const Border(
                  left: BorderSide(color: AppColors.primary, width: 4),
                ),
              ),
              blockquotePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              blockquote: AppTextStyles.bodyMedium(color: AppColors.darkTextPrimary),
            ),
          ),
        );
      },
    );
  }
}
