import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract class AppTextStyles {
  AppTextStyles._();

  static TextStyle get _baseStyle => GoogleFonts.plusJakartaSans();
  static TextStyle get _codeBaseStyle => GoogleFonts.jetBrainsMono();

  static TextStyle displayLarge({Color? color, double? fontSize}) =>
      _baseStyle.copyWith(
        fontSize: fontSize ?? 28.0,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
        color: color ?? AppColors.darkTextPrimary,
      );

  static TextStyle displayMedium({Color? color, double? fontSize}) =>
      _baseStyle.copyWith(
        fontSize: fontSize ?? 24.0,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.3,
        color: color ?? AppColors.darkTextPrimary,
      );

  static TextStyle displaySmall({Color? color, double? fontSize}) =>
      _baseStyle.copyWith(
        fontSize: fontSize ?? 20.0,
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.darkTextPrimary,
      );

  static TextStyle headingLarge({Color? color, double? fontSize}) =>
      _baseStyle.copyWith(
        fontSize: fontSize ?? 18.0,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.darkTextPrimary,
      );

  static TextStyle headingMedium({Color? color, double? fontSize}) =>
      _baseStyle.copyWith(
        fontSize: fontSize ?? 16.0,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.darkTextPrimary,
      );

  static TextStyle headingSmall({Color? color, double? fontSize}) =>
      _baseStyle.copyWith(
        fontSize: fontSize ?? 15.0,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.darkTextPrimary,
      );

  static TextStyle bodyLarge({Color? color, double? fontSize}) =>
      _baseStyle.copyWith(
        fontSize: fontSize ?? 16.0,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.darkTextPrimary,
      );

  static TextStyle bodyMedium({Color? color, double? fontSize}) =>
      _baseStyle.copyWith(
        fontSize: fontSize ?? 14.0,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.darkTextSecondary,
      );

  static TextStyle bodySmall({Color? color, double? fontSize}) =>
      _baseStyle.copyWith(
        fontSize: fontSize ?? 13.0,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.darkTextMuted,
      );

  static TextStyle labelLarge({Color? color, double? fontSize}) =>
      _baseStyle.copyWith(
        fontSize: fontSize ?? 14.0,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.darkTextSecondary,
      );

  static TextStyle labelMedium({Color? color, double? fontSize}) =>
      _baseStyle.copyWith(
        fontSize: fontSize ?? 12.0,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.darkTextSecondary,
      );

  static TextStyle labelSmall({Color? color, double? fontSize}) =>
      _baseStyle.copyWith(
        fontSize: fontSize ?? 11.0,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.darkTextMuted,
      );

  static TextStyle codeStyle({Color? color, double? fontSize}) =>
      _codeBaseStyle.copyWith(
        fontSize: fontSize ?? 13.0,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: color ?? AppColors.codeText,
      );
}
