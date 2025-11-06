import 'package:flutter/material.dart';
import 'package:wavelink/core/constants/app_colors.dart';
import 'package:wavelink/core/utils/navigation_helper.dart';
import 'package:wavelink/features/admin/admin_dashboard.dart';
import 'package:wavelink/features/employee/employee_dashboard.dart';
import 'package:wavelink/features/passenger/passenger_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String selectedRole = 'Admin';
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.aqua, AppColors.navy],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.waves,
                        size: 60,
                        color: AppColors.navy,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Welcome to WAVELINK',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          _buildRoleButton('Admin'),
                          const SizedBox(width: 8),
                          _buildRoleButton('Employee'),
                          const SizedBox(width: 8),
                          _buildRoleButton('Passenger'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email / Phone',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('Forgot Password?'),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => _handleLogin(),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Dark Mode'),
                          Switch(
                            value: _isDarkMode,
                            onChanged: (value) {
                              setState(() => _isDarkMode = value);
                            },
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
    );
  }

  Widget _buildRoleButton(String role) {
    final isSelected = selectedRole == role;
    return Expanded(
      child: ElevatedButton(
        onPressed: () => setState(() => selectedRole = role),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppColors.aqua : Colors.grey[300],
          foregroundColor: isSelected ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(role),
      ),
    );
  }

  void _handleLogin() {
    Widget dashboard;
    switch (selectedRole) {
      case 'Admin':
        dashboard = const AdminDashboard();
        break;
      case 'Employee':
        dashboard = const EmployeeDashboard();
        break;
      case 'Passenger':
        dashboard = const PassengerDashboard();
        break;
      default:
        dashboard = const AdminDashboard();
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


