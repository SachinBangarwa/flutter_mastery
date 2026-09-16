import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../controllers/floatoon_controller.dart';

/// The visual interactive character widget with Lottie animation,
/// drag physics, size shrink on touch, and smooth directional flipping.
class FloatoonWidget extends StatelessWidget {
  final FloatoonController controller;
  final String lottieAssetPath;
  final VoidCallback? onTap;

  const FloatoonWidget({
    super.key,
    required this.controller,
    this.lottieAssetPath = 'assets/Tourists on the road.json',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final offset = controller.offset;
        final isFacingRight = controller.isFacingRight;
        final isDragging = controller.isDragging;
        final size = controller.characterSize;

        return Positioned(
          left: offset.dx,
          top: offset.dy,
          width: size.width,
          height: size.height,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            onPanStart: (details) =>
                controller.onDragStart(details.globalPosition),
            onPanUpdate: (details) =>
                controller.onDragUpdate(details.globalPosition, details.delta),
            onPanEnd: (details) =>
                controller.onDragEnd(details.velocity.pixelsPerSecond),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Main character with size shrink on touch and smooth direction flip
                AnimatedScale(
                  // Size shrinks when user touches / drags
                  scale: isDragging ? 0.82 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutBack,
                  child: TweenAnimationBuilder<double>(
                    // Smooth horizontal direction flip
                    tween: Tween<double>(
                      begin: isFacingRight ? 1.0 : -1.0,
                      end: isFacingRight ? 1.0 : -1.0,
                    ),
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeInOutBack,
                    builder: (context, scaleX, child) {
                      return Transform.scale(
                        scaleX: scaleX,
                        alignment: Alignment.center,
                        child: child,
                      );
                    },
                    child: SizedBox(
                      width: size.width,
                      height: size.height,
                      child: Lottie.asset(lottieAssetPath, fit: BoxFit.contain),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
