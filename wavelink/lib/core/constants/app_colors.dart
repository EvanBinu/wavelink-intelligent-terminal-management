import 'package:flutter/material.dart';

class AppColors {
  // 🔷 Primary Brand Colors
  static const navy = Color(0xFF003366);        // Deep trust blue
  static const aqua = Color(0xFF00B8D9);        // Modern accent blue
  static const white = Color(0xFFFFFFFF);
  static const gray = Color(0xFFE5E5E5);

  // 🔴 Status & Feedback Colors
  static const red = Color(0xFFFF3B30);         // Danger / Error
  static const yellow = Color(0xFFFFCC00);      // Warning / Pending
  static const green = Color(0xFF34C759);       // Success / Complete

  // 🟣 Supporting Colors
  static const lightBlue = Color(0xFF90E0EF);   // Info / secondary highlight
  static const darkBlue = Color(0xFF001F3F);    // Darker navy for contrast
  static const amber = Color(0xFFFFA500);       // Alert / notice
  static const teal = Color(0xFF20C997);        // Calm success / neutral action

  // ⚪ Surface & Backgrounds
  static const background = Color(0xFFF8F9FA);  // General app background
  static const surface = Color(0xFFFFFFFF);     // Cards, tiles, containers
  static const shadow = Color(0x1A000000);      // 10% black opacity

  // 🖋 Text Colors
  static const textPrimary = Color(0xFF1C1C1C); // Dark readable text
  static const textSecondary = Color(0xFF5F6C7B); // Muted labels, subtitles
  static const textLight = Color(0xFF9E9E9E);   // Disabled or hint text

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
  
}
