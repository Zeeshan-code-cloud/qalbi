
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/theme_controller.dart';

class AppColors {
  AppColors._();

  // Brand Colors
  static const Color primary = Color(0xFF064E3B);
  static const Color primaryLight = Color(0xFF0D6B50);
  static const Color primaryDark = Color(0xFF032F25);

  static const Color secondary = Color(0xFFC49A50);
  static const Color goldLight = Color(0xFFF0DDB0);
  static const Color goldDark = Color(0xFF9C762F);

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFF9F5EA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF3EEE3);
  static const Color lightText = Color(0xFF172B25);
  static const Color lightSecondaryText = Color(0xFF77766F);
  static const Color lightBorder = Color(0xFFE5D8C2);
  static const Color lightDivider = Color(0xFFECE5D9);
  static const Color lightGold = Color(0xFFF9F5EA);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF071B17);
  static const Color darkSurface = Color(0xFF102923);
  static const Color darkCard = Color(0xFF18352D);
  static const Color darkText = Color(0xFFF7F0DF);
  static const Color darkSecondaryText = Color(0xFFB6C2B8);
  static const Color darkBorder = Color(0xFF395448);
  static const Color darkDivider = Color(0xFF294238);

  // Status Colors
  static const Color success = Color(0xFF2E8B57);
  static const Color error = Color(0xFFD9534F);
  static const Color warning = Color(0xFFE0A13A);
  static const Color info = Color(0xFF4387B5);

  // Theme-aware Getters & Setters
  static bool get isDark {
    if (Get.isRegistered<ThemeController>()) {
      return Get.find<ThemeController>().isDark.value;
    }
    return Get.isDarkMode;
  }

  static set isDark(bool value) {
    if (Get.isRegistered<ThemeController>()) {
      Get.find<ThemeController>().setTheme(value);
    } else {
      Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    }
  }

  static Color get background =>
      isDark ? darkBackground : lightBackground;

  static Color get surface =>
      isDark ? darkSurface : lightSurface;

  static Color get card =>
      isDark ? darkCard : lightCard;

  static Color get text =>
      isDark ? darkText : lightText;

  static Color get secondaryText =>
      isDark ? darkSecondaryText : lightSecondaryText;

  static Color get border =>
      isDark ? darkBorder : lightBorder;

  static Color get divider =>
      isDark ? darkDivider : lightDivider;

  static Color get primaryColor =>
      isDark ? const Color(0xFF2CA780) : primary;

  static Color get accent =>
      isDark ? goldLight : secondary;

  static Color get icon =>
      isDark ? darkText : primary;

  static Color get inputFill =>
      isDark ? darkSurface : const Color(0xFFF5F0E6);

  static Color get shadow =>
      isDark ? Colors.black26 : Colors.black12;

  static Color get onPrimary => Colors.white;

  // Islamic App Specific Colors
  static Color get prayerHighlight =>
      isDark ? const Color(0xFF214C3D) : const Color(0xFFE6EFE7);

  static Color get quranHighlight =>
      isDark ? const Color(0xFF453A25) : const Color(0xFFF5EBD5);

  static Color get tasbeehBead =>
      isDark ? goldLight : secondary;

  static Color get notificationBackground =>
      isDark ? const Color(0xFF1C382F) : const Color(0xFFEAF1E9);

  // Gradients
  static LinearGradient get primaryGradient => LinearGradient(
    colors: isDark
        ? [const Color(0xFF145B45), darkBackground]
        : [const Color(0xFF0D6B50), primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get goldGradient => LinearGradient(
    colors: isDark
        ? [goldLight, secondary]
        : [goldLight, goldDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
