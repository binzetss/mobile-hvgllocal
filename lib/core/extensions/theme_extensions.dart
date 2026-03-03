import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

extension AppThemeExtension on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get bgColor => isDark ? Colors.black : const Color(0xFFF0F2F5);

  Color get cardColor => isDark ? const Color(0xFF1C1C1E) : Colors.white;

  Color get surfaceColor => isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF7F8FA);

  Color get borderColor => isDark ? const Color(0xFF38383A) : const Color(0xFFE4E6EB);

  Color get textPrimary => isDark ? Colors.white : const Color(0xFF050505);
  Color get textSecondary => isDark ? const Color(0xFF8E8E93) : const Color(0xFF65676B);

  Color get primaryColor => isDark ? const Color(0xFF4599FF) : AppColors.primary;

  Color get menuBgColor => isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF0F2F5);
}
