import 'package:flutter/material.dart';
import '../floatoon.dart';

/// Static demo screen demonstrating Floatoon floating above normal app UI
class FloatoonDemoScreen extends StatefulWidget {
  const FloatoonDemoScreen({super.key});

  @override
  State<FloatoonDemoScreen> createState() => _FloatoonDemoScreenState();
}

class _FloatoonDemoScreenState extends State<FloatoonDemoScreen> {
  late FloatoonController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FloatoonController(characterSize: const Size(60, 60));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      // FloatoonOverlay floats the Lottie companion seamlessly over the static UI
      body: FloatoonOverlay(
        controller: _controller,
        lottieAssetPath: 'assets/Tourists on the road.json',
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
                          "Welcome Back",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Sachin",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: const Color(
                        0xFF6366F1,
                      ).withValues(alpha: 0.15),
                      child: const Icon(
                        Icons.person_rounded,
                        color: Color(0xFF6366F1),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Featured Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.22),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "COMPANION ACTIVE",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        "Your In-App Pet\nis Floating Around",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Drag Floatoon anywhere or watch it fly smoothly across the screen.",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.88),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Quick Overview Section
                const Text(
                  "Dashboard",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        icon: Icons.timer_outlined,
                        title: "Active Time",
                        value: "2h 45m",
                        color: const Color(0xFF10B981),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildMetricCard(
                        icon: Icons.favorite_border_rounded,
                        title: "Happiness",
                        value: "98%",
                        color: const Color(0xFFEC4899),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        icon: Icons.flight_takeoff_rounded,
                        title: "Flight Mode",
                        value: "Smooth",
                        color: const Color(0xFF3B82F6),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildMetricCard(
                        icon: Icons.auto_awesome_rounded,
                        title: "Routine",
                        value: "5 Actions",
                        color: const Color(0xFF8B5CF6),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Recent Activities List
                const Text(
                  "Recent Activities",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 12),

                _buildActivityTile(
                  icon: Icons.directions_walk_rounded,
                  title: "Bottom Walk",
                  subtitle: "Completed stroll rounds",
                  time: "Just now",
                ),
                _buildActivityTile(
                  icon: Icons.flight_takeoff_rounded,
                  title: "Flight to Top",
                  subtitle: "Flew upwards to ceiling",
                  time: "3m ago",
                ),
                _buildActivityTile(
                  icon: Icons.arrow_downward_rounded,
                  title: "Gravity Drop",
                  subtitle: "Dropped smoothly to floor",
                  time: "5m ago",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF6366F1), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}
