import 'package:flutter/material.dart';
import 'package:flutter_mastery/core/theme/app_colors.dart';
import 'package:flutter_mastery/core/theme/app_text_styles.dart';

/// The static live preview widget for DropdownButton.
class DropdownButtonPreview extends StatefulWidget {
  const DropdownButtonPreview({super.key});

  @override
  State<DropdownButtonPreview> createState() => _DropdownButtonPreviewState();
}

class _DropdownButtonPreviewState extends State<DropdownButtonPreview> {
  String _selectedValue = 'Option 1';

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

          // DropdownButton design matching code.txt
          DropdownButton<String>(
            value: _selectedValue,
            dropdownColor: AppColors.darkSurface,
            icon: const Icon(Icons.arrow_downward_rounded, color: Colors.blueAccent),
            elevation: 16,
            style: const TextStyle(color: Colors.blueAccent, fontSize: 16),
            underline: Container(
              height: 2,
              color: Colors.blueAccent,
            ),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedValue = newValue;
                });
              }
            },
            items: <String>['Option 1', 'Option 2', 'Option 3']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
