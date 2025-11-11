import 'dart:ui'; // Still needed for ImageFilter (oops, no, I removed it. Let's remove this import)
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

// ✅ REMOVED SingleTickerProviderStateMixin
class _LoginScreenState extends State<LoginScreen> {
  String selectedRole = 'Admin';
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isDarkMode = false;

  final Color darkBackground = const Color(0xFF0D1B2A);
  final Color darkCardColor = const Color(0xFF1B263B);
  final Color darkTextColor = Colors.white;
  final Color darkHintColor = Colors.white70;

  final Color lightBackground = Colors.grey[100]!;
  final Color lightCardColor = Colors.white;
  final Color lightTextColor = AppColors.navy;
  final Color lightHintColor = Colors.black54;

  // ✅ REMOVED wave controller

  @override
  void initState() {
    super.initState();
    // ✅ REMOVED controller init
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Simplified colors for professional look
    final scaffoldBackgroundColor =
        _isDarkMode ? darkBackground : lightBackground;
    final cardColor = _isDarkMode ? darkCardColor : lightCardColor;
    final textColor = _isDarkMode ? darkTextColor : lightTextColor;
    final hintColor = _isDarkMode ? darkHintColor : lightHintColor;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor, // ✅ Set solid background
      // ✅ REMOVED Stack
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            // ✅ REPLACED glassmorphism with a standard Card
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: cardColor,
              child: Container(
                padding: const EdgeInsets.all(32),
                constraints: const BoxConstraints(
                  maxWidth: 400,
                ), // Max width for tablet
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ✅ CHANGED Icon to be more professional
                    Icon(Icons.lock_outline, size: 60, color: textColor),
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

                    // ✅ REPLACED custom buttons with SegmentedButton
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'Admin', label: Text('Admin')),
                        ButtonSegment(
                          value: 'Employee',
                          label: Text('Employee'),
                        ),
                        ButtonSegment(
                          value: 'Passenger',
                          label: Text('Passenger'),
                        ),
                      ],
                      selected: {selectedRole},
                      onSelectionChanged: (Set<String> newSelection) {
                        setState(() {
                          selectedRole = newSelection.first;
                          _emailController.clear();
                          _passwordController.clear();
                        });
                      },
                      style: SegmentedButton.styleFrom(
                        backgroundColor:
                            _isDarkMode ? Colors.grey[800] : Colors.grey[200],
                        selectedBackgroundColor:
                            _isDarkMode ? AppColors.aqua : AppColors.navy,
                        selectedForegroundColor: Colors.white,
                        foregroundColor: hintColor,
                      ),
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
    );
  }

  // ✅ REMOVED _buildWaveBackground()

  // --- This helper function is unchanged ---

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

  // ✅ REMOVED _animatedRoleButton()

  // --- This helper function is unchanged ---

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
    // ✅ REMOVED wave controller dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

// ✅ REMOVED _WavePainter class
