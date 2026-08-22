import 'package:flutter/material.dart';
import 'package:flutter_mastery/core/theme/app_colors.dart';
import 'package:flutter_mastery/core/theme/app_text_styles.dart';

/// The static live preview widget for Row.
class RowPreview extends StatelessWidget {
  const RowPreview({super.key});

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

          // Row design matching code.txt
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
