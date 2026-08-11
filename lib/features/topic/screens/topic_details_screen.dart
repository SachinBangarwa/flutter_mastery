import 'package:flutter/material.dart';
import 'package:flutter_mastery/core/theme/app_colors.dart';
import 'package:flutter_mastery/core/theme/app_text_styles.dart';
import 'package:flutter_mastery/features/topic/widgets/topic_tabs.dart';
import 'package:flutter_mastery/features/topic/widgets/topic_code_view.dart';
import 'package:flutter_mastery/features/topic/widgets/topic_explanation_view.dart';
import 'package:flutter_mastery/features/topic/widgets/topic_interview_view.dart';
import 'package:flutter_mastery/features/topic/widgets/topic_practice_view.dart';
import 'package:flutter_mastery/features/topic/widgets/topic_assignment_view.dart';
import 'package:flutter_mastery/live_previews/preview_registry.dart';
import 'package:flutter_mastery/models/topic_model.dart';
import 'package:flutter_mastery/services/topic_content_service.dart';

class TopicDetailsScreen extends StatefulWidget {
  final String topicId;
  final String? category;

  const TopicDetailsScreen({
    super.key,
    required this.topicId,
    this.category,
  });

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
    'Practice',
    'Assignment',
  ];

  @override
  void initState() {
    super.initState();
    _category = widget.category ?? _contentService.getCategoryForTopic(widget.topicId);
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
            appBar: AppBar(
              backgroundColor: AppColors.darkSurface,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: AppColors.darkTextPrimary),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: AppColors.darkBackground,
            appBar: AppBar(
              backgroundColor: AppColors.darkSurface,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: AppColors.darkTextPrimary),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Center(
              child: Text(
                'Error loading topic details: ${snapshot.error}',
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
              icon: const Icon(Icons.arrow_back_rounded, color: AppColors.darkTextPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              topic.title,
              style: AppTextStyles.displaySmall(color: AppColors.darkTextPrimary).copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  color: _isBookmarked ? AppColors.primary : AppColors.darkTextPrimary,
                ),
                onPressed: () {
                  setState(() {
                    _isBookmarked = !_isBookmarked;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _isBookmarked
                            ? 'Bookmarked ${topic.title}'
                            : 'Removed ${topic.title} from bookmarks',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                color: AppColors.darkBorder,
                height: 1,
              ),
            ),
          ),
          body: Column(
            children: [
              // Horizontal Custom Segmented/Tab Selector
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
              Expanded(
                child: _buildSelectedTabView(topic),
              ),
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
      case 5:
        return TopicPracticeView(
          category: _category,
          topicId: topic.id,
          contentService: _contentService,
        );
      case 6:
        return TopicAssignmentView(
          category: _category,
          topicId: topic.id,
          contentService: _contentService,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildOverviewTab(TopicModel topic) {
    final String topicId = topic.id.toLowerCase();
    final List<Widget> propertyCards = [];
    
    if (topicId == 'text') {
      propertyCards.addAll([
        _buildPropertyInfoCard(
          'data (string)',
          'The raw string text to display on the screen.',
        ),
        _buildPropertyInfoCard(
          'style',
          'Accepts a TextStyle widget to apply colors, font sizes, weights, and letter spacing.',
        ),
        _buildPropertyInfoCard(
          'textAlign',
          'Controls how the text is aligned horizontally within its layout box.',
        ),
        _buildPropertyInfoCard(
          'overflow',
          'Configures truncation behavior (e.g. ellipsis) if text runs past constraints.',
        ),
      ]);
    } else if (topicId == 'card') {
      propertyCards.addAll([
        _buildPropertyInfoCard(
          'elevation',
          'Sets the elevation depth to cast a standard drop shadow beneath the card.',
        ),
        _buildPropertyInfoCard(
          'color',
          'Sets the background color of the card surface.',
        ),
        _buildPropertyInfoCard(
          'shape',
          'Defines the corner rounding (borderRadius) and optional border outlines.',
        ),
        _buildPropertyInfoCard(
          'clipBehavior',
          'Determines how child content is clipped to match the card\'s rounded corners.',
        ),
      ]);
    } else {
      // Default: container
      propertyCards.addAll([
        _buildPropertyInfoCard(
          'width & height',
          'Sets the explicit bounds of the box. By default, it sizes to fit the child.',
        ),
        _buildPropertyInfoCard(
          'padding',
          'Adds empty spacing inside the boundary, pushing the child inward.',
        ),
        _buildPropertyInfoCard(
          'decoration',
          'Styles the background color, border, border radius, and box shadow using BoxDecoration.',
        ),
        _buildPropertyInfoCard(
          'alignment',
          'Determines where the child is positioned within the container.',
        ),
      ]);
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Styled Card for metadata description
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        topic.difficulty.toUpperCase(),
                        style: AppTextStyles.labelSmall(color: AppColors.primary).copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.darkSurfaceVariant,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.darkBorder),
                      ),
                      child: Text(
                        'WIDGETS',
                        style: AppTextStyles.labelSmall(color: AppColors.darkTextSecondary).copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  topic.title,
                  style: AppTextStyles.headingLarge(color: AppColors.darkTextPrimary).copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  topic.subtitle,
                  style: AppTextStyles.bodyMedium(color: AppColors.darkTextSecondary).copyWith(
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),

          // Live preview header
          Text(
            'Widget Visual Preview',
            style: AppTextStyles.headingLarge(color: AppColors.darkTextPrimary).copyWith(
              fontWeight: FontWeight.bold,
            ),
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

          // Important Properties List
          Text(
            'Key Properties Used',
            style: AppTextStyles.headingLarge(color: AppColors.darkTextPrimary).copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...propertyCards,
          
          const SizedBox(height: 20),

          // Tags section
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: topic.tags.map((t) {
              return Chip(
                backgroundColor: AppColors.darkSurface,
                side: const BorderSide(color: AppColors.darkBorder),
                label: Text(
                  '#$t',
                  style: AppTextStyles.labelSmall(color: AppColors.darkTextSecondary),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyInfoCard(String name, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline_rounded, color: AppColors.primary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$name: ',
                    style: AppTextStyles.bodyMedium(color: AppColors.darkTextPrimary).copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: description,
                    style: AppTextStyles.bodyMedium(color: AppColors.darkTextSecondary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertiesTab(TopicModel topic) {
    final String topicId = topic.id.toLowerCase();
    
    if (topicId == 'text') {
      return ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        children: [
          Text(
            'Text Properties Detail',
            style: AppTextStyles.headingLarge(color: AppColors.darkTextPrimary).copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Comprehensive reference guide of standard properties in a Text widget.',
            style: AppTextStyles.bodyMedium(color: AppColors.darkTextSecondary),
          ),
          const Divider(color: AppColors.darkBorder, height: 32),

          _buildDetailPropertyTile(
            title: 'style',
            usage: 'style: TextStyle(fontSize: 16, color: Colors.blue)',
            description: 'Defines typography styling including color, font size, weight, letter spacing, decoration, shadows, and word spacing.',
          ),
          _buildDetailPropertyTile(
            title: 'textAlign',
            usage: 'textAlign: TextAlign.center',
            description: 'Aligns the text horizontally within its parent constraints. Values include left, right, center, and justify.',
          ),
          _buildDetailPropertyTile(
            title: 'overflow',
            usage: 'overflow: TextOverflow.ellipsis',
            description: 'Configures how to render text that overflows the parent boundaries (e.g. clip, ellipsis, fade).',
          ),
          _buildDetailPropertyTile(
            title: 'maxLines',
            usage: 'maxLines: 2',
            description: 'Limits the maximum number of text lines. Often used with overflow.ellipsis to show truncated text cleanly.',
          ),
        ],
      );
    } else if (topicId == 'card') {
      return ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        children: [
          Text(
            'Card Properties Detail',
            style: AppTextStyles.headingLarge(color: AppColors.darkTextPrimary).copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Comprehensive reference guide of standard properties in a Card widget.',
            style: AppTextStyles.bodyMedium(color: AppColors.darkTextSecondary),
          ),
          const Divider(color: AppColors.darkBorder, height: 32),

          _buildDetailPropertyTile(
            title: 'elevation',
            usage: 'elevation: 4.0',
            description: 'Controls the size of the shadow beneath the card, creating depth and a floating Material Design visual effect.',
          ),
          _buildDetailPropertyTile(
            title: 'color & shadowColor',
            usage: 'color: Colors.grey\nshadowColor: Colors.blueAccent',
            description: 'color changes the card background surface color. shadowColor changes the color tint of the cast drop shadow.',
          ),
          _buildDetailPropertyTile(
            title: 'shape',
            usage: 'shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))',
            description: 'Configures corner rounding (BorderRadius) and borders/lines along the card outline.',
          ),
          _buildDetailPropertyTile(
            title: 'clipBehavior',
            usage: 'clipBehavior: Clip.antiAlias',
            description: 'Determines if and how elements (like images or background decorations) are clipped to match the card\'s rounded corners.',
          ),
        ],
      );
    } else {
      // Default: Container properties
      return ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        children: [
          Text(
            'Container Properties Detail',
            style: AppTextStyles.headingLarge(color: AppColors.darkTextPrimary).copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Comprehensive reference guide of standard properties in a Container widget.',
            style: AppTextStyles.bodyMedium(color: AppColors.darkTextSecondary),
          ),
          const Divider(color: AppColors.darkBorder, height: 32),

          _buildDetailPropertyTile(
            title: 'color & decoration',
            usage: 'color: Colors.blue\ndecoration: BoxDecoration(color: Colors.blue)',
            description: 'Used to specify background fills. Keep in mind that specifying both color directly on the Container and a decoration throws an error.',
          ),
          _buildDetailPropertyTile(
            title: 'padding & margin',
            usage: 'padding: EdgeInsets.all(12.0)\nmargin: EdgeInsets.all(16.0)',
            description: 'Padding controls the space inside the Container boundary relative to the child, while Margin controls the space around the Container wrapper.',
          ),
          _buildDetailPropertyTile(
            title: 'alignment',
            usage: 'alignment: Alignment.center',
            description: 'Positions the child widget inside the boundaries of the Container. Uses pre-defined offsets like Alignment.center, Alignment.topRight, or custom values.',
          ),
          _buildDetailPropertyTile(
            title: 'constraints',
            usage: 'constraints: BoxConstraints.expand(height: 150)',
            description: 'Sets additional boundary limitations (minWidth, maxWidth, minHeight, maxHeight) on how the Container can size itself inside its parent.',
          ),
          _buildDetailPropertyTile(
            title: 'transform',
            usage: 'transform: Matrix4.rotationZ(0.1)',
            description: 'Applies visual transformations to the Container before paint, including scaling, translation, shear, and rotation.',
          ),
        ],
      );
    }
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
            style: AppTextStyles.headingMedium(color: AppColors.primary).copyWith(
              fontWeight: FontWeight.bold,
            ),
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
