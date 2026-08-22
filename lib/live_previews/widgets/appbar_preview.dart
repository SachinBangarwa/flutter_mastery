import 'package:flutter/material.dart';
import 'package:flutter_mastery/core/theme/app_colors.dart';
import 'package:flutter_mastery/core/theme/app_text_styles.dart';

/// The static live preview widget for AppBar.
class AppBarPreview extends StatelessWidget {
  const AppBarPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.darkSurfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Dotted Grid Background
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: GridPaper(
                color: Colors.white,
                divisions: 2,
                subdivisions: 2,
                interval: 40,
              ),
            ),
          ),
          
          Positioned(
            top: 8,
            left: 12,
            child: Text(
              'Preview Canvas',
              style: AppTextStyles.labelSmall(
                color: AppColors.darkTextMuted,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
          ),

          // AppBar design matching code.txt
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AppBar(
                primary: false,
                backgroundColor: AppColors.darkSurface,
                leading: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {},
                ),
                title: const Text('AppBar Title'),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.add_alert),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
