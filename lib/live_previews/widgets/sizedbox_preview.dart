import 'package:flutter/material.dart';
import 'package:flutter_mastery/core/theme/app_colors.dart';
import 'package:flutter_mastery/core/theme/app_text_styles.dart';

/// The static live preview widget for SizedBox.
class SizedBoxPreview extends StatelessWidget {
  const SizedBoxPreview({super.key});

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

          // SizedBox design matching code.txt
          SizedBox(
            width: 120.0,
            height: 80.0,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Sized Button',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
