import 'package:flutter/material.dart';

abstract class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF0066FF);
  static const Color primaryDark = Color(0xFF0052CC);
  static const Color primaryLight = Color(0xFF3385FF);
  static const Color accent = Color(0xFF38BDF8);

  static const Color darkBackground = Color(0xFF0D111D);
  static const Color darkSurface = Color(0xFF161C2E);
  static const Color darkSurfaceVariant = Color(0xFF1E2640);
  static const Color darkBorder = Color(0xFF232D48);

  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);

  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFE2E8F0);

  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  static const Color categoryWidgets = Color(0xFF2563EB);
  static const LinearGradient gradientWidgets = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color categoryDart = Color(0xFF0284C7);
  static const LinearGradient gradientDart = LinearGradient(
    colors: [Color(0xFF0284C7), Color(0xFF0EA5E9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color categoryStateMgmt = Color(0xFF7C3AED);
  static const LinearGradient gradientStateMgmt = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color categoryFirebase = Color(0xFFEA580C);
  static const LinearGradient gradientFirebase = LinearGradient(
    colors: [Color(0xFFEA580C), Color(0xFFEF4444)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color categoryPackages = Color(0xFFD97706);
  static const LinearGradient gradientPackages = LinearGradient(
    colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color categoryUiUx = Color(0xFF9333EA);
  static const LinearGradient gradientUiUx = LinearGradient(
    colors: [Color(0xFF9333EA), Color(0xFFC084FC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color categoryInterview = Color(0xFF4F46E5);
  static const LinearGradient gradientInterview = LinearGradient(
    colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color categoryProjects = Color(0xFF0D9488);
  static const LinearGradient gradientProjects = LinearGradient(
    colors: [Color(0xFF0D9488), Color(0xFF14B8A6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color codeBackground = Color(0xFF0B0F19);
  static const Color codeText = Color(0xFFE2E8F0);
  static const Color codeKeyword = Color(0xFF38BDF8);
  static const Color codeClass = Color(0xFF4ADE80);
  static const Color codeString = Color(0xFFFBBF24);
  static const Color codeNumber = Color(0xFFF472B6);

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
}
