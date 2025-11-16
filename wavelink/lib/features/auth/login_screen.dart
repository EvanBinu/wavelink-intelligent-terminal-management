import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wavelink/core/constants/app_colors.dart';
import 'package:wavelink/core/utils/navigation_helper.dart';
import 'package:wavelink/core/utils/password_utils.dart';

import 'package:wavelink/features/admin/admin_dashboard.dart';
import 'package:wavelink/features/employee/employee_dashboard.dart';
import 'package:wavelink/features/passenger/passenger_dashboard.dart';
import 'package:wavelink/features/auth/forgot_password_screen.dart';
import 'package:wavelink/features/auth/create_account_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isDarkMode = false;
  bool _isLoading = false;

  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    final backgroundStart =
        _isDarkMode ? AppColors.darkBackgroundStart : AppColors.aqua;
    final backgroundEnd =
        _isDarkMode ? AppColors.darkBackgroundEnd : AppColors.navy;

    final cardColor = _isDarkMode
        ? AppColors.darkCard.withOpacity(0.7)
        : AppColors.whiteTransparent;

    final textColor =
        _isDarkMode ? AppColors.darkText : AppColors.textPrimary;

    final hintColor =
        _isDarkMode ? AppColors.darkHint : AppColors.black54;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [backgroundStart, backgroundEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.waves, size: 60, color: textColor),
                        const SizedBox(height: 16),
                        Text(
                          'Welcome to WAVELINK',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Email field
                        TextField(
                          controller: _emailController,
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: hintColor),
                            prefixIcon: Icon(Icons.email, color: hintColor),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: hintColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.aqua),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Password field
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: hintColor),
                            prefixIcon: Icon(Icons.lock, color: hintColor),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: hintColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.aqua),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ForgotPasswordScreen(),
                                ),
                              );
                            },
                            child: Text('Forgot Password?', style: TextStyle(color: hintColor)),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Login button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.navy,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Create account link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("New here?", style: TextStyle(color: hintColor)),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const CreateAccountPage()),
                              ),
                              child: const Text(
                                "Create Account",
                                style: TextStyle(
                                  color: AppColors.aqua,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Dark mode switch
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Dark Mode", style: TextStyle(color: hintColor)),
                            Switch(
                              value: _isDarkMode,
                              onChanged: (value) {
                                setState(() => _isDarkMode = value);
                              },
                              activeColor: AppColors.aqua,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// LOGIN FUNCTION (PBKDF2 ONLY)
  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter email & password")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await _supabase
          .from('users')
          .select()
          .eq('email', email)
          .maybeSingle();

      print("📥 Email entered: $email");
      print("📦 DB user: $user");

      if (user == null) {
        throw Exception("Invalid email or password");
      }

      final storedHash = user['password'];
      print("🔐 Stored hash: $storedHash");

      final bool ok = await checkPasswordHash(password, storedHash);

      print("🔍 Password match? → $ok");

      if (!ok) {
        throw Exception("Invalid email or password");
      }

      // Role detection
      final role = (user['role'] ?? 'passenger').toLowerCase();
      Widget screen;

      switch (role) {
        case 'admin':
          screen = const AdminDashboardScreen();
          break;
        case 'employee':
          screen = const EmployeeDashboardScreen();
          break;
        default:
          screen = const PassengerDashboardScreen();
      }

      if (mounted) NavigationHelper.replaceWith(context, screen);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: $e")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
