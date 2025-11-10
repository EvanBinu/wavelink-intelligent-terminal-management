import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:wavelink/core/constants/app_colors.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
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
    final cardColor = _isDarkMode ? darkCardColor : Colors.white.withOpacity(0.2);
    final textColor = _isDarkMode ? darkTextColor : AppColors.navy;
    final hintColor = _isDarkMode ? darkHintColor : Colors.black54;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _isDarkMode ? Colors.blueGrey.shade900 : AppColors.navy,
        title: const Text("Create Account"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [backgroundStart, backgroundEnd],
          ),
        ),
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
                      Icon(Icons.person_add, size: 60, color: textColor),
                      const SizedBox(height: 16),
                      Text(
                        'Create New Account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 32),
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
                      const SizedBox(height: 16),
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
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
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.navy,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Create Account',
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
                          Text('Dark Mode', style: TextStyle(color: hintColor)),
                          Switch(
                            value: _isDarkMode,
                            onChanged: (value) => setState(() => _isDarkMode = value),
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
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
