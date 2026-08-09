import 'package:flutter/material.dart';
import 'package:flutter_mastery/core/theme/app_colors.dart';
import 'package:flutter_mastery/core/theme/app_text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<_CategoryData> _categories = const [
    _CategoryData(
      title: 'Widgets',
      subtitle: 'Explore all widgets',
      icon: Icons.widgets_rounded,
      gradient: AppColors.gradientWidgets,
      accentColor: AppColors.categoryWidgets,
    ),
    _CategoryData(
      title: 'Dart',
      subtitle: 'Learn Dart language',
      icon: Icons.code_rounded,
      gradient: AppColors.gradientDart,
      accentColor: AppColors.categoryDart,
    ),
    _CategoryData(
      title: 'State Mgmt',
      subtitle: 'Provider, Riverpod, Bloc',
      icon: Icons.account_tree_rounded,
      gradient: AppColors.gradientStateMgmt,
      accentColor: AppColors.categoryStateMgmt,
    ),
    _CategoryData(
      title: 'Firebase',
      subtitle: 'Authentication, Firestore & more',
      icon: Icons.local_fire_department_rounded,
      gradient: AppColors.gradientFirebase,
      accentColor: AppColors.categoryFirebase,
    ),
    _CategoryData(
      title: 'Packages',
      subtitle: 'Useful Flutter packages',
      icon: Icons.inventory_2_rounded,
      gradient: AppColors.gradientPackages,
      accentColor: AppColors.categoryPackages,
    ),
    _CategoryData(
      title: 'UI/UX',
      subtitle: 'Design beautiful interfaces',
      icon: Icons.palette_rounded,
      gradient: AppColors.gradientUiUx,
      accentColor: AppColors.categoryUiUx,
    ),
    _CategoryData(
      title: 'Interview',
      subtitle: 'Top questions & answers',
      icon: Icons.quiz_rounded,
      gradient: AppColors.gradientInterview,
      accentColor: AppColors.categoryInterview,
    ),
    _CategoryData(
      title: 'Projects',
      subtitle: 'Real world projects',
      icon: Icons.folder_special_rounded,
      gradient: AppColors.gradientProjects,
      accentColor: AppColors.categoryProjects,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Top App Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Home',
                      style: AppTextStyles.displayMedium(
                        color: AppColors.darkTextPrimary,
                      ).copyWith(fontWeight: FontWeight.bold),
                    ),
                    Stack(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notifications_none_rounded,
                            color: AppColors.darkTextPrimary,
                            size: 26,
                          ),
                        ),
                        Positioned(
                          right: 12,
                          top: 12,
                          child: Container(
                            height: 8,
                            width: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Search Bar Input Field
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.darkBorder,
                      width: 1.0,
                    ),
                  ),
                  child: TextField(
                    style: AppTextStyles.bodyMedium(
                      color: AppColors.darkTextPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search anything...',
                      hintStyle: AppTextStyles.bodyMedium(
                        color: AppColors.darkTextMuted,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.darkTextMuted,
                        size: 22,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.tune_rounded,
                          color: AppColors.darkTextMuted,
                          size: 20,
                        ),
                        onPressed: () {},
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),

            // 8 Category Grid Cards
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = _categories[index];
                    return _CategoryCard(data: item);
                  },
                  childCount: _categories.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.15,
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryData {
  final String title;
  final String subtitle;
  final IconData icon;
  final LinearGradient gradient;
  final Color accentColor;

  const _CategoryData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.accentColor,
  });
}

class _CategoryCard extends StatelessWidget {
  final _CategoryData data;

  const _CategoryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.darkBorder,
          width: 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Opening ${data.title}...')),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Circular Gradient Icon Container
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    gradient: data.gradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: data.accentColor.withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    data.icon,
                    color: Colors.white,
                    size: 22,
                  ),
                ),

                // Title & Subtitle Labels
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: AppTextStyles.headingSmall(
                        color: AppColors.darkTextPrimary,
                      ).copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      data.subtitle,
                      style: AppTextStyles.labelSmall(
                        color: AppColors.darkTextMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
