import 'package:flutter/material.dart';
import '../controllers/floatoon_controller.dart';
import 'floatoon_widget.dart';

/// A pure in-app overlay widget that floats single or dual Floatoon companion characters
/// on top of any screen or the entire MaterialApp without requiring Android SYSTEM_ALERT_WINDOW permissions.
///
/// Supports two paired characters with dynamic following and couple actions (Hug, Kiss, Propose).
/// Gestures outside the Floatoon pass seamlessly to underlying widgets (buttons, scrolls, inputs).
class FloatoonOverlay extends StatefulWidget {
  final Widget child;
  final FloatoonController controller;
  final FloatoonController? partnerController;
  final String lottieAssetPath;
  final String? partnerLottieAssetPath;
  final String? actionAssetPath;
  final VoidCallback? onCharacterTap;
  final bool enabled;

  const FloatoonOverlay({
    super.key,
    required this.child,
    required this.controller,
    this.partnerController,
    this.lottieAssetPath = 'assets/Tourists on the road.json',
    this.partnerLottieAssetPath = 'assets/Love.gif',
    this.actionAssetPath,
    this.onCharacterTap,
    this.enabled = true,
  });

  @override
  State<FloatoonOverlay> createState() => _FloatoonOverlayState();
}

class _FloatoonOverlayState extends State<FloatoonOverlay>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _initTickers();
  }

  @override
  void didUpdateWidget(covariant FloatoonOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller ||
        oldWidget.partnerController != widget.partnerController) {
      _initTickers();
    }
  }

  void _initTickers() {
    widget.controller.initTicker(this);
    widget.partnerController?.initTicker(this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final Size size = Size(constraints.maxWidth, constraints.maxHeight);
          widget.controller.updateScreenSize(size);
          widget.partnerController?.updateScreenSize(size);

          return Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.none,
            children: [
              // Underlying application content (receives normal touches)
              widget.child,

              // Character 1 (User / Local avatar)
              if (widget.enabled)
                FloatoonWidget(
                  controller: widget.controller,
                  partnerController: widget.partnerController,
                  assetPath: widget.lottieAssetPath,
                  actionAssetPath: widget.actionAssetPath,
                  onTap: widget.onCharacterTap,
                ),

              // Character 2 (Partner avatar, if paired)
              if (widget.enabled && widget.partnerController != null)
                FloatoonWidget(
                  controller: widget.partnerController!,
                  partnerController: widget.controller,
                  assetPath: widget.partnerLottieAssetPath ?? 'assets/Love.gif',
                  actionAssetPath: widget.actionAssetPath,
                ),
            ],
          );
        },
      ),
    );
  }
}
