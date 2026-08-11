import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mastery/core/theme/app_colors.dart';
import 'package:flutter_mastery/core/theme/app_text_styles.dart';
import 'package:flutter_mastery/services/topic_content_service.dart';

class TopicCodeView extends StatefulWidget {
  final String category;
  final String topicId;
  final TopicContentService contentService;

  const TopicCodeView({
    super.key,
    required this.category,
    required this.topicId,
    required this.contentService,
  });

  @override
  State<TopicCodeView> createState() => _TopicCodeViewState();
}

class _TopicCodeViewState extends State<TopicCodeView> {
  late Future<String> _codeFuture;

  @override
  void initState() {
    super.initState();
    _codeFuture = widget.contentService.loadMarkdownContent(
      widget.category,
      widget.topicId,
      'code.txt',
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _codeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading code snippet',
              style: AppTextStyles.bodyMedium(color: AppColors.error),
            ),
          );
        }

        final codeText = snapshot.data ?? '';

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'DART SOURCE CODE',
                    style: AppTextStyles.labelMedium(color: AppColors.darkTextSecondary).copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Material(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: codeText));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Code copied to clipboard!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          children: [
                            const Icon(Icons.copy_rounded, color: Colors.white, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              'Copy Code',
                              style: AppTextStyles.labelMedium(color: Colors.white).copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: DartSyntaxHighlighter(code: codeText),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// A lightweight regex-based syntax highlighter for generated Flutter Dart code.
class DartSyntaxHighlighter extends StatelessWidget {
  final String code;

  const DartSyntaxHighlighter({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    final List<TextSpan> spans = [];

    // Matches strings, numeric values, keywords, classes, and generic text tokens
    final regExp = RegExp(
      r"('(?:[^'\\]|\\.)*'|\x22(?:[^\x22\\]|\\.)*\x22)" // 1. Strings
      r"|(\b\d+(?:\.\d+)?\b)" // 2. Numbers
      r"|(\b(?:const|final|true|false|child|decoration|width|height|margin|padding|alignment|color|border|borderRadius|boxShadow|blurRadius|offset)\b)" // 3. Keywords & Properties
      r"|(\b(?:Container|BoxDecoration|Color|Colors|Border|BorderRadius|BoxShadow|Offset|EdgeInsets|Text|TextStyle|Center)\b)" // 4. Flutter Classes
      r"|([^\s'\x220-9a-zA-Z()\[\]{}:.,@]+|\s+|[()\[\]{}:.,@]|[a-zA-Z_]\w*)", // 5. Normal text
      multiLine: true,
    );

    final matches = regExp.allMatches(code);
    for (final match in matches) {
      if (match.group(1) != null) {
        spans.add(TextSpan(
          text: match.group(1),
          style: const TextStyle(color: AppColors.codeString),
        ));
      } else if (match.group(2) != null) {
        spans.add(TextSpan(
          text: match.group(2),
          style: const TextStyle(color: AppColors.codeNumber),
        ));
      } else if (match.group(3) != null) {
        spans.add(TextSpan(
          text: match.group(3),
          style: const TextStyle(color: AppColors.codeKeyword),
        ));
      } else if (match.group(4) != null) {
        spans.add(TextSpan(
          text: match.group(4),
          style: const TextStyle(color: AppColors.codeClass),
        ));
      } else {
        spans.add(TextSpan(
          text: match.group(5),
          style: const TextStyle(color: AppColors.codeText),
        ));
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.codeBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: SelectableText.rich(
        TextSpan(
          children: spans,
          style: AppTextStyles.codeStyle(),
        ),
      ),
    );
  }
}
