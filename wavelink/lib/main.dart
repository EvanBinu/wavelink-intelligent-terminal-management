import 'package:flutter/material.dart';
import 'package:wavelink/core/constants/app_theme.dart';
import 'package:wavelink/core/constants/app_strings.dart';
import 'package:wavelink/features/splash/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ywvnhsgkubitvvjvngfg.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl3dm5oc2drdWJpdHZ2anZuZ2ZnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI4ODIwNzQsImV4cCI6MjA3ODQ1ODA3NH0.hatvbYqAcWBlZyhqYM6ZLbnWfGK-LsTGvk-ohYJ2Rhw',
  );
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