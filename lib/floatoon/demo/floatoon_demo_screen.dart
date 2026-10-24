import 'package:flutter/material.dart';
import '../floatoon.dart';

/// Interactive demo screen demonstrating two-user Floatoon companions floating
/// above normal app UI with dynamic target tracking, couple actions (Hug, Kiss, Propose),
/// and WebSocket payload inspection.
class FloatoonDemoScreen extends StatefulWidget {
  const FloatoonDemoScreen({super.key});

  @override
  State<FloatoonDemoScreen> createState() => _FloatoonDemoScreenState();
}

class _FloatoonDemoScreenState extends State<FloatoonDemoScreen> {
  late FloatoonController _userController;
  late FloatoonController _partnerController;
  late FloatoonWebSocketBridge _wsBridge;

  bool _isPairMode = true;
  String _lastWsMessage = "Waiting for action...";

  @override
  void initState() {
    super.initState();

    _userController = FloatoonController(
      id: 'user_1',
      displayName: 'You',
      startsOnLeft: true,
      characterSize: const Size(60, 60),
    );

    _partnerController = FloatoonController(
      id: 'user_2',
      displayName: 'Partner',
      startsOnLeft: false, // Starts on right wall
      characterSize: const Size(60, 60),
    );

    _wsBridge = FloatoonWebSocketBridge(
      localController: _userController,
      partnerController: _partnerController,
      sendRawMessage: (jsonStr) {
        setState(() {
          _lastWsMessage = jsonStr;
        });
      },
    );

    _userController.onActionStarted = (action, source, target) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${source.displayName} is ${action.label.toLowerCase()}ing with ${target.displayName}! ${action.emoji}",
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF8B5CF6),
        ),
      );
    };
  }

  @override
  void dispose() {
    _userController.dispose();
    _partnerController.dispose();
    super.dispose();
  }

  void _triggerAction(FloatoonAction action) {
    if (!_isPairMode) {
      setState(() => _isPairMode = true);
    }
    _wsBridge.sendAction(action);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      // FloatoonOverlay floats the Lottie & GIF companions seamlessly over the static UI
      body: FloatoonOverlay(
        controller: _userController,
        partnerController: _isPairMode ? _partnerController : null,
        lottieAssetPath: 'assets/Tourists on the road.json', // Lottie vector
        partnerLottieAssetPath: 'assets/Love.gif', // Animated GIF asset
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top App Bar / Profile Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Couple Companion System",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Sachin & Partner",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    // Mode Toggle Badge
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isPairMode = !_isPairMode;
                        });
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _isPairMode
                              ? const Color(0xFF6366F1).withValues(alpha: 0.15)
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _isPairMode
                                ? const Color(0xFF6366F1).withValues(alpha: 0.4)
                                : Colors.transparent,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isPairMode
                                  ? Icons.favorite_rounded
                                  : Icons.person_rounded,
                              size: 16,
                              color: _isPairMode
                                  ? const Color(0xFF6366F1)
                                  : Colors.grey.shade700,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _isPairMode ? "2 Characters" : "1 Character",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: _isPairMode
                                    ? const Color(0xFF6366F1)
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Interactive Action Control Panel
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4F46E5).withValues(alpha: 0.35),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "INTERACTION CONTROLS",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const Text(
                            "Select action below",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Target Tracking & Actions\nHug, Kiss & Propose",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Click an action below to send it to your partner. One character will actively follow the other, lock close up, and perform the action!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildActionButton(
                            action: FloatoonAction.hug,
                            onTap: () => _triggerAction(FloatoonAction.hug),
                          ),
                          _buildActionButton(
                            action: FloatoonAction.kiss,
                            onTap: () => _triggerAction(FloatoonAction.kiss),
                          ),
                          _buildActionButton(
                            action: FloatoonAction.propose,
                            onTap: () => _triggerAction(FloatoonAction.propose),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // // WebSocket Payload Inspector
                // Container(
                //   width: double.infinity,
                //   padding: const EdgeInsets.all(16),
                //   decoration: BoxDecoration(
                //     color: const Color(0xFF0F172A),
                //     borderRadius: BorderRadius.circular(16),
                //     border: Border.all(
                //       color: Colors.white.withValues(alpha: 0.1),
                //     ),
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Row(
                //         children: [
                //           Container(
                //             width: 8,
                //             height: 8,
                //             decoration: const BoxDecoration(
                //               color: Color(0xFF10B981),
                //               shape: BoxShape.circle,
                //             ),
                //           ),
                //           const SizedBox(width: 8),
                //           const Text(
                //             "WebSocket Payload Preview",
                //             style: TextStyle(
                //               color: Colors.white,
                //               fontSize: 12,
                //               fontWeight: FontWeight.bold,
                //             ),
                //           ),
                //         ],
                //       ),
                //       const SizedBox(height: 8),
                //       Text(
                //         _lastWsMessage,
                //         style: const TextStyle(
                //           color: Color(0xFF94A3B8),
                //           fontFamily: 'monospace',
                //           fontSize: 11,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 24),

                // Realtime Distance & Status Bar
                ListenableBuilder(
                  listenable: Listenable.merge([
                    _userController,
                    _partnerController,
                  ]),
                  builder: (context, _) {
                    return Row(
                      children: [
                        Expanded(
                          child: _buildStatusCard(
                            title: "You (Lottie)",
                            status: _userController.state.name,
                            isFacingRight: _userController.isFacingRight,
                            color: const Color(0xFF6366F1),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatusCard(
                            title: "Partner (GIF)",
                            status: _partnerController.state.name,
                            isFacingRight: _partnerController.isFacingRight,
                            color: const Color(0xFFEC4899),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Quick Activity Feed
                const Text(
                  "Architecture Highlights",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 12),

                _buildFeatureTile(
                  icon: Icons.track_changes_rounded,
                  title: "Dynamic Target Tracking",
                  subtitle:
                      "If partner moves or is dragged, the pursuer recalculates and keeps following!",
                  color: const Color(0xFF4F46E5),
                ),
                _buildFeatureTile(
                  icon: Icons.lock_clock_rounded,
                  title: "Control Disable on Close Contact",
                  subtitle:
                      "When characters touch, movement locks and action badge displays for 3.5s.",
                  color: const Color(0xFFEC4899),
                ),
                _buildFeatureTile(
                  icon: Icons.swap_horiz_rounded,
                  title: "Dual Asset Engine (Lottie + GIF)",
                  subtitle:
                      "Seamlessly renders Lottie JSON and animated GIFs/images with identical physics.",
                  color: const Color(0xFF10B981),
                ),
                _buildFeatureTile(
                  icon: Icons.wifi_tethering_rounded,
                  title: "WebSocket Bridge Included",
                  subtitle:
                      "Plug-and-play FloatoonWebSocketBridge for real-time multiplayer syncing.",
                  color: const Color(0xFFF59E0B),
                ),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required FloatoonAction action,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.20),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(action.emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              "Send ${action.label}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard({
    required String title,
    required String status,
    required bool isFacingRight,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "State: $status",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
          Text(
            "Facing: ${isFacingRight ? 'Right ➡️' : 'Left ⬅️'}",
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
