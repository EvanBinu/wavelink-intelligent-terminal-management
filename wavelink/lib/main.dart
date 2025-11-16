import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:wavelink/core/constants/app_theme.dart';
import 'package:wavelink/core/constants/app_strings.dart';
import 'package:wavelink/features/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://zaxkcgsttfokrgrftlct.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpheGtjZ3N0dGZva3JncmZ0bGN0Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MjcwMTM5MiwiZXhwIjoyMDc4Mjc3MzkyfQ.UpkwTT3TlPlg_rD5JsGEoq_vhX5D3EPx5OEsmnIZQ9k',
  );

  runApp(const WaveLinkApp());
}

class WaveLinkApp extends StatelessWidget {
  const WaveLinkApp({super.key});

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
