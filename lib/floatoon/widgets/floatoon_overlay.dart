import 'package:flutter/material.dart';
import '../controllers/floatoon_controller.dart';
import 'floatoon_widget.dart';

/// A pure in-app overlay widget that floats the Floatoon character on top of any
/// screen or the entire MaterialApp without requiring Android SYSTEM_ALERT_WINDOW permissions.
///
/// Gestures outside the Floatoon pass seamlessly to underlying widgets (buttons, scrolls, inputs).
class FloatoonOverlay extends StatefulWidget {
  final Widget child;
  final FloatoonController controller;
  final String lottieAssetPath;
  final VoidCallback? onCharacterTap;
  final bool enabled;

  const FloatoonOverlay({
    super.key,
    required this.child,
    required this.controller,
    this.lottieAssetPath = 'assets/Tourists on the road.json',
    this.onCharacterTap,
    this.enabled = true,
  });

  @override
  State<FloatoonOverlay> createState() => _FloatoonOverlayState();
}

class _FloatoonOverlayState extends State<FloatoonOverlay>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.controller.initTicker(this);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final Size size = Size(constraints.maxWidth, constraints.maxHeight);
        widget.controller.updateScreenSize(size);

        return Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            // Underlying application content (receives normal touches)
            widget.child,

            // Floating in-app character overlay (only the character consumes touches)
            if (widget.enabled)
              FloatoonWidget(
                controller: widget.controller,
                lottieAssetPath: widget.lottieAssetPath,
                onTap: widget.onCharacterTap,
              ),
          ],
        );
      },
    );
  }
}
