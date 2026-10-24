import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../controllers/floatoon_controller.dart';
import '../models/floatoon_action.dart';

/// The visual interactive character widget supporting both Lottie and GIF/Image animations,
/// drag physics, size shrink on touch, target tracking animations, and couple actions (Hug, Kiss, Propose).
class FloatoonWidget extends StatelessWidget {
  final FloatoonController controller;
  final FloatoonController? partnerController;
  final String assetPath;
  final String? actionAssetPath;
  final VoidCallback? onTap;
  final bool showNameTag;

  const FloatoonWidget({
    super.key,
    required this.controller,
    this.partnerController,
    this.assetPath = 'assets/Tourists on the road.json',
    this.actionAssetPath,
    this.onTap,
    this.showNameTag = true,
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
        final state = controller.state;
        final activeAction = controller.activeAction;
        final isInteracting = state == FloatoonState.interacting;
        final isFollowing = state == FloatoonState.following;

        return Positioned(
          left: offset.dx,
          top: offset.dy,
          width: size.width,
          height: size.height,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            onTapDown: (details) {
              if (!controller.isControlsDisabled) {
                controller.onDragStart(details.globalPosition);
              }
            },
            onTapUp: (details) {
              if (!controller.isControlsDisabled) {
                controller.onDragEnd(Offset.zero);
              }
            },
            onTapCancel: () {
              if (!controller.isControlsDisabled) {
                controller.onDragEnd(Offset.zero);
              }
            },
            onPanStart: (details) =>
                controller.onDragStart(details.globalPosition),
            onPanUpdate: (details) =>
                controller.onDragUpdate(details.globalPosition, details.delta),
            onPanEnd: (details) =>
                controller.onDragEnd(details.velocity.pixelsPerSecond),
            onPanCancel: () => controller.onDragEnd(Offset.zero),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Active Action Banner (e.g. "Hugging... 🤗" or "Kissing... 💋")
                if (isInteracting && activeAction != null)
                  Positioned(
                    bottom: size.height + 14,
                    child: _buildInteractionBadge(activeAction),
                  ),

                // Following indicator (e.g. "Going for Hug 🤗")
                if (isFollowing && activeAction != null)
                  Positioned(
                    bottom: size.height + 10,
                    child: _buildFollowingBadge(activeAction),
                  ),

                // Name tag badge (e.g. "You" or "Partner")
                if (showNameTag && !isInteracting && !isFollowing)
                  Positioned(
                    top: -16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.60),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        controller.displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                // Main character with size shrink on touch and smooth direction flip
                AnimatedScale(
                  scale: isDragging ? 0.82 : (isInteracting ? 1.15 : 1.0),
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
                      child: _buildCharacterGraphic(isInteracting),
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

  /// Renders either Lottie, GIF, or custom Action Graphic seamlessly
  Widget _buildCharacterGraphic(bool isInteracting) {
    final String pathToUse = (isInteracting && actionAssetPath != null)
        ? actionAssetPath!
        : assetPath;

    if (pathToUse.toLowerCase().endsWith('.json')) {
      return Transform.scale(
        scale: 1.25,
        child: Lottie.asset(
          pathToUse,
          fit: BoxFit.contain,
        ),
      );
    } else {
      // GIF or regular raster image
      return Image.asset(
        pathToUse,
        fit: BoxFit.contain,
      );
    }
  }

  /// Celebratory active interaction badge
  Widget _buildInteractionBadge(FloatoonAction action) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEC4899), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEC4899).withValues(alpha: 0.50),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(action.emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          Text(
            action.activeStatusText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Approaching / tracking badge
  Widget _buildFollowingBadge(FloatoonAction action) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF4F46E5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(action.emoji, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(
            "Tracking...",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
