import 'package:flutter/material.dart';
import 'package:wavelink/core/constants/app_colors.dart';
import 'package:wavelink/features/auth/login_screen.dart';
import 'package:wavelink/core/utils/navigation_helper.dart';
import 'package:wavelink/features/auth/create_account_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final List<Color> gradientColors = _isDarkMode
        ? [AppColors.darkBlue, AppColors.navy, AppColors.aqua.withOpacity(0.5)]
        : [AppColors.navy, AppColors.aqua, AppColors.lightBlue];

    final textColor = _isDarkMode ? AppColors.white : AppColors.textPrimary;
    final buttonPrimary = _isDarkMode ? AppColors.navy : AppColors.aqua;
    final buttonTextColor = _isDarkMode ? AppColors.white : AppColors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text('WaveLink'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: textColor,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                'WaveLink',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 100),
              _buildButton(
                title: 'Log In',
                bgColor: buttonPrimary,
                textColor: buttonTextColor,
                onTap: () {
                  NavigationHelper.push(context, const LoginScreen());
                },
              ),
              const SizedBox(height: 20),
              _buildButton(
                title: 'Get Started',
                bgColor: AppColors.textPrimary,
                textColor: AppColors.white,
                onTap: () {
                  NavigationHelper.push(context, const CreateAccountPage());
                },
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Dark Mode',
                    style: TextStyle(color: textColor.withOpacity(0.8)),
                  ),
                  Switch(
                    value: _isDarkMode,
                    onChanged: (value) {
                      setState(() => _isDarkMode = value);
                    },
                    activeColor: AppColors.aqua,
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String title,
    required Color bgColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 220,
      height: 50,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
        ),
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
