import 'package:flutter/material.dart';
import 'package:wavelink/core/constants/app_theme.dart';
import 'package:wavelink/core/constants/app_strings.dart';
import 'package:wavelink/features/splash/splash_screen.dart';

void main() {
  runApp(const WaveLinkApp());
}

class WaveLinkApp extends StatelessWidget {
  const WaveLinkApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}