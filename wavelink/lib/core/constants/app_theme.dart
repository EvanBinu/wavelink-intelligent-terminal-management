import 'package:flutter/material.dart';
import 'package:wavelink/core/constants/app_colors.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      primaryColor: AppColors.navy,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.navy,
        secondary: AppColors.aqua,
      ),
      fontFamily: 'Poppins',
      useMaterial3: true,
    );
  }

  static ThemeData dark() {
    return ThemeData.dark().copyWith(
      primaryColor: AppColors.aqua,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.aqua,
        secondary: AppColors.navy,
      ),
    );
  }
}


