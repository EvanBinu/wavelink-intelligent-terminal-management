import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:wavelink/core/constants/app_theme.dart';
import 'package:wavelink/core/constants/app_strings.dart';
import 'package:wavelink/features/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load Supabase keys from txt file
  final secretFile = await rootBundle.loadString('assets/secrets/supabase_keys.txt');

  final lines = secretFile.split('\n');

  String supabaseUrl = "";
  String supabaseAnonKey = "";

  for (var line in lines) {
    if (line.startsWith("SUPABASE_URL")) {
      supabaseUrl = line.split("=")[1].trim();
    } else if (line.startsWith("SUPABASE_ANON_KEY")) {
      supabaseAnonKey = line.split("=")[1].trim();
    }
  }

  // Initialize Supabase with loaded values
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
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
