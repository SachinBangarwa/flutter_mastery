import 'package:flutter/material.dart';
import 'package:flutter_mastery/live_previews/widgets/container_preview.dart';
import 'package:flutter_mastery/live_previews/widgets/text_preview.dart';
import 'package:flutter_mastery/live_previews/widgets/card_preview.dart';

/// Registry mapping preview types from `info.json` (e.g. `"container"`) to the corresponding preview widget.
Widget getTopicPreview(String previewType) {
  switch (previewType.toLowerCase()) {
    case 'container':
      return const ContainerPreview();
    case 'text':
      return const TextPreview();
    case 'card':
      return const CardPreview();
    default:
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Live preview not available for this widget.',
            style: TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      );
  }
}
