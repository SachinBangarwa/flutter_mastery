import 'package:flutter/material.dart';
import 'package:flutter_mastery/core/theme/app_colors.dart';
import 'package:flutter_mastery/core/theme/app_text_styles.dart';

class TopicTabs extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final List<String> tabs;

  const TopicTabs({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.tabs,
  });

  @override
  State<TopicTabs> createState() => _TopicTabsState();
}

class _TopicTabsState extends State<TopicTabs> {
  late final ScrollController _scrollController;
  final List<GlobalKey> _keys = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _keys.addAll(List.generate(widget.tabs.length, (index) => GlobalKey()));
    
    // Scroll selected tab into view after rendering
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToTab(widget.selectedIndex);
    });
  }

  @override
  void didUpdateWidget(covariant TopicTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _scrollToTab(widget.selectedIndex);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTab(int index) {
    if (index < 0 || index >= _keys.length) return;
    final context = _keys[index].currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 250),
        alignment: 0.5,
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.darkSurface,
        border: Border(
          bottom: BorderSide(color: AppColors.darkBorder, width: 1.0),
        ),
      ),
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: widget.tabs.length,
        itemBuilder: (context, index) {
          final isSelected = index == widget.selectedIndex;
          final tabText = widget.tabs[index];

          return Padding(
            key: _keys[index],
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
            child: Material(
              color: isSelected ? AppColors.primary : AppColors.darkSurfaceVariant,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                onTap: () => widget.onTabSelected(index),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.primaryLight : AppColors.darkBorder,
                      width: 1.0,
                    ),
                  ),
                  child: Text(
                    tabText,
                    style: AppTextStyles.labelMedium(
                      color: isSelected ? Colors.white : AppColors.darkTextSecondary,
                    ).copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
