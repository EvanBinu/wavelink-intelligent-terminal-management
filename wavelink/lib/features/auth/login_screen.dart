import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:wavelink/core/constants/app_colors.dart';
import 'package:wavelink/core/utils/navigation_helper.dart';
import 'package:wavelink/features/admin/admin_dashboard.dart';
import 'package:wavelink/features/employee/employee_dashboard.dart';
import 'package:wavelink/features/passenger/passenger_dashboard.dart';
import 'package:wavelink/features/auth/forgot_password_screen.dart';
import 'package:wavelink/features/auth/create_account_page.dart';
import 'package:wavelink/features/auth/auth_service.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final AuthService _authService = AuthService();
  
  String selectedRole = 'Admin';
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void login() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    try {
      await _authService.signInWithEmail(email, password);
      if (mounted) {
        _handleLogin();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  bool _isDarkMode = false;
  final Color darkBackgroundStart = const Color(0xFF0D1B2A);
  final Color darkBackgroundEnd = const Color(0xFF1B263B);
  final Color darkCardColor = const Color(0xFF1B2A47).withOpacity(0.7);
  final Color darkTextColor = Colors.white;
  final Color darkHintColor = Colors.white70;

  @override
  Widget build(BuildContext context) {
    final backgroundStart = _isDarkMode ? darkBackgroundStart : AppColors.aqua;
    final backgroundEnd = _isDarkMode ? darkBackgroundEnd : AppColors.navy;
    final cardColor =
        _isDarkMode ? darkCardColor : Colors.white.withOpacity(0.2);
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

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _animatedRoleButton('Admin'),
                            _animatedRoleButton('Employee'),
                            _animatedRoleButton('Passenger'),
                          ],
                        ),
                        const SizedBox(height: 24),

                        _buildPrimaryLoginField(textColor, hintColor),

                        if (selectedRole != 'Admin') const SizedBox(height: 16),

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
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(color: hintColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

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

                        // ✅ HIDE Create Account when ADMIN selected
                        if (selectedRole != 'Admin')
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
                                      builder: (_) => const CreateAccountPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Create Account',
                                  style: TextStyle(
                                    color: AppColors.aqua,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Dark Mode',
                              style: TextStyle(color: hintColor),
                            ),
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

  Widget _buildPrimaryLoginField(Color textColor, Color hintColor) {
    String labelText;
    IconData iconData;

    switch (selectedRole) {
      case 'Employee':
        labelText = 'Employee Email ID';
        iconData = Icons.email;
        break;
      case 'Passenger':
        labelText = 'Username or Email';
        iconData = Icons.person;
        break;
      case 'Admin':
      default:
        return const SizedBox.shrink();
    }

    return TextField(
      controller: _emailController,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: hintColor),
        prefixIcon: Icon(iconData, color: hintColor),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: hintColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.aqua),
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
          setState(() {
            selectedRole = role;
            _emailController.clear();
            _passwordController.clear();
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient:
                isSelected
                    ? LinearGradient(colors: [startColor, endColor])
                    : null,
            color:
                isSelected
                    ? null
                    : (_isDarkMode ? Colors.blueGrey : Colors.grey[300]),
            borderRadius: BorderRadius.circular(30),
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: startColor.withOpacity(0.5),
                        offset: const Offset(0, 4),
                        blurRadius: 10,
                      ),
                    ]
                    : [],
          ),
          alignment: Alignment.center,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              color:
                  isSelected
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
