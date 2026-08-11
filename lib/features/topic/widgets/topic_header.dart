import 'package:flutter/material.dart';
import 'package:flutter_mastery/core/theme/app_colors.dart';
import 'package:flutter_mastery/core/theme/app_text_styles.dart';
import 'package:flutter_mastery/models/topic_model.dart';

class TopicHeader extends StatefulWidget {
  final TopicModel topic;

  const TopicHeader({super.key, required this.topic});

  @override
  State<TopicHeader> createState() => _TopicHeaderState();
}

class _TopicHeaderState extends State<TopicHeader> {
  bool _isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    final diffColor = _getDifficultyColor(widget.topic.difficulty);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      decoration: const BoxDecoration(
        color: AppColors.darkSurface,
        border: Border(
          bottom: BorderSide(color: AppColors.darkBorder, width: 1.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category and Difficulty Badges
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      widget.topic.category.toUpperCase(),
                      style: AppTextStyles.labelSmall(color: AppColors.primary).copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: diffColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: diffColor.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      widget.topic.difficulty.toUpperCase(),
                      style: AppTextStyles.labelSmall(color: diffColor).copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),

              // Bookmark button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isBookmarked = !_isBookmarked;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _isBookmarked
                              ? 'Saved "${widget.topic.title}" to bookmarks!'
                              : 'Removed "${widget.topic.title}" from bookmarks.',
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.darkSurfaceVariant,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.darkBorder),
                    ),
                    child: Icon(
                      _isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                      color: _isBookmarked ? AppColors.primary : AppColors.darkTextSecondary,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Text(
            widget.topic.title,
            style: AppTextStyles.displayMedium(color: AppColors.darkTextPrimary).copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 6),
          
          Text(
            widget.topic.subtitle,
            style: AppTextStyles.bodyMedium(color: AppColors.darkTextSecondary),
          ),
        ],
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
