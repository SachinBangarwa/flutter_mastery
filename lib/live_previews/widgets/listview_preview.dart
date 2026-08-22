import 'package:flutter/material.dart';
import 'package:flutter_mastery/core/theme/app_colors.dart';
import 'package:flutter_mastery/core/theme/app_text_styles.dart';

/// The static live preview widget for ListView.
class ListViewPreview extends StatelessWidget {
  const ListViewPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
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

          // ListView design matching code.txt
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 40,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withValues(alpha: 0.1 * (index + 2)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Entry $index',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
