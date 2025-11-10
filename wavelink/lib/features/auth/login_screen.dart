import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:wavelink/core/constants/app_colors.dart';
import 'package:wavelink/core/utils/navigation_helper.dart';
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
  String selectedRole = 'Admin';
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isDarkMode = false;

  final Color darkBackgroundStart = const Color(0xFF0D1B2A); 
  final Color darkBackgroundEnd = const Color(0xFF1B263B);   
  final Color darkCardColor = const Color(0xFF1B2A47).withOpacity(0.7);
  final Color darkTextColor = Colors.white;
  final Color darkHintColor = Colors.white70;

  @override
  Widget build(BuildContext context) {
    final backgroundStart =
        _isDarkMode ? darkBackgroundStart : AppColors.aqua;
    final backgroundEnd =
        _isDarkMode ? darkBackgroundEnd : AppColors.navy;
    final cardColor = _isDarkMode
        ? darkCardColor
        : Colors.white.withOpacity(0.2);
    final textColor = _isDarkMode ? darkTextColor : AppColors.navy;
    final hintColor = _isDarkMode ? darkHintColor : Colors.black54;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [backgroundStart, backgroundEnd],
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
                        color: Colors.white.withOpacity(0.2),
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

                        // Animated Role Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _animatedRoleButton('Admin'),
                            _animatedRoleButton('Employee'),
                            _animatedRoleButton('Passenger'),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Email Field
                        TextField(
                          controller: _emailController,
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            labelText: 'Email / Phone',
                            labelStyle: TextStyle(color: hintColor),
                            prefixIcon: Icon(Icons.person, color: hintColor),
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

                        // Password Field
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

                        // Forgot Password Link
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const ForgotPasswordPage()),
                              );
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(color: hintColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.navy,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Create Account Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'New here? ',
                              style: TextStyle(color: hintColor),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const CreateAccountPage()),
                                );
                              },
                              child: Text(
                                'Create Account',
                                style: TextStyle(
                                    color: AppColors.aqua,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Dark Mode Switch
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Dark Mode', style: TextStyle(color: hintColor)),
                            Switch(
                              value: _isDarkMode,
                              onChanged: (value) {
                                setState(() => _isDarkMode = value);
                              },
                              activeColor: AppColors.aqua,
                              inactiveThumbColor: Colors.grey[300],
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

  Widget _animatedRoleButton(String role) {
    final bool isSelected = selectedRole == role;
    final Color startColor =
        _isDarkMode ? Colors.blueAccent.shade700 : AppColors.aqua;
    final Color endColor =
        _isDarkMode ? Colors.lightBlue.shade400 : AppColors.navy;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => selectedRole = role);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(colors: [startColor, endColor])
                : null,
            color: isSelected
                ? null
                : (_isDarkMode ? Colors.blueGrey : Colors.grey[300]),
            borderRadius: BorderRadius.circular(30),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: startColor.withOpacity(0.5),
                      offset: const Offset(0, 4),
                      blurRadius: 10,
                    )
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : (_isDarkMode ? Colors.white70 : Colors.black87),
              fontWeight: FontWeight.bold,
            ),
            child: Text(role),
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    Widget dashboard;
    switch (selectedRole) {
      case 'Admin':
        dashboard = const AdminDashboardScreen();
        break;
      case 'Employee':
        dashboard = const EmployeeDashboardScreen();
        break;
      case 'Passenger':
        dashboard = const PassengerDashboardScreen();
        break;
      default:
        dashboard = const AdminDashboardScreen();
    }
    NavigationHelper.replaceWith(context, dashboard);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
