import 'package:flutter/material.dart';

class AppColors {
  // 🔷 Primary Brand Colors
  static const navy = Color(0xFF003366);
  static const aqua = Color(0xFF00B8D9);
  static const white = Color(0xFFFFFFFF);
  static const gray = Color(0xFFE5E5E5);

  // 🔴 Status & Feedback Colors
  static const red = Color(0xFFFF3B30);
  static const yellow = Color(0xFFFFCC00);
  static const green = Color(0xFF34C759);

  // 🟣 Supporting Colors
  static const lightBlue = Color(0xFF90E0EF);
  static const darkBlue = Color(0xFF001F3F);
  static const amber = Color(0xFFFFA500);
  static const teal = Color(0xFF20C997);

  // ⚪ Surface & Backgrounds
  static const background = Color(0xFFF8F9FA);
  static const surface = Color(0xFFFFFFFF);
  static const shadow = Color(0x1A000000);

  // 🖋 Text Colors
  static const textPrimary = Color(0xFF1C1C1C);
  static const textSecondary = Color(0xFF5F6C7B);
  static const textLight = Color(0xFF9E9E9E);

  // 🌈 Gradients
  static const backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF5F5F5), white],
  );

  static const headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [aqua, navy],
  );

  static const dangerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [red, Color(0xFFB71C1C)],
  );

  static const successGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [green, teal],
  );

  // 🌙 Dark Theme Additions (for Login Screen)
  static const darkBackgroundStart = Color(0xFF0D1B2A);
  static const darkBackgroundEnd = Color(0xFF1B263B);
  static const darkCard = Color(0xFF1B2A47);
  static const darkText = Colors.white;
  static const darkHint = Colors.white70;

  // ⚫ Neutral Variants
  static const black87 = Colors.black87;
  static const black54 = Colors.black54;
  static const white70 = Colors.white70;
  static const whiteTransparent = Color(0x33FFFFFF); // 20% white opacity
  static const grey300 = Color(0xFFE0E0E0);
  static const blueGrey = Color(0xFF607D8B);
}
