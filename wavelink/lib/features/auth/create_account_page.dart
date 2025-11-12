import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:wavelink/core/constants/app_colors.dart';
import 'package:wavelink/features/auth/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// General account creation screen (NOT for Admin usage)
class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage>
    with SingleTickerProviderStateMixin {
  // Auth service
  final AuthService _authService = AuthService();
  
  // Role selection
  String _selectedRole = 'Passenger'; // Default role

  // Common controllers
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _aadhar = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  // Role-specific controllers
  final _employeeId = TextEditingController();
  final _username = TextEditingController();

  late final AnimationController _bg;
  bool _isDark = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _bg = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bg.dispose();
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _aadhar.dispose();
    _password.dispose();
    _confirm.dispose();
    _employeeId.dispose();
    _username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _bg,
            builder:
                (_, __) => CustomPaint(
                  size: Size(size.width, size.height),
                  painter: _BlobPainter(
                    t: _bg.value,
                    base1: AppColors.navy,
                    base2: AppColors.aqua,
                  ),
                ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: const SizedBox.expand(),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: _buildCard(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:
            _isDark
                ? Colors.white.withOpacity(0.06)
                : Colors.white.withOpacity(0.55),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Create account',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: _isDark ? Colors.white : Colors.black,
                ), // Changed
              ),
              Row(
                children: [
                  Icon(
                    Icons.dark_mode,
                    size: 18,
                    color: _isDark ? Colors.white70 : Colors.black87,
                  ), // Changed
                  Switch(
                    value: _isDark,
                    onChanged: (v) => setState(() => _isDark = v),
                    activeColor: AppColors.aqua,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // --- Role Selector ---
          Row(
            children: [
              _roleButton('Passenger'),
              const SizedBox(width: 12),
              _roleButton('Employee'),
            ],
          ),
          const SizedBox(height: 16),

          // --- Dynamic Form Fields ---
          ..._buildFormFields(),

          const SizedBox(height: 12),
          _glassField(
            controller: _password,
            hint: 'Password',
            icon: Icons.lock_outline,
            obscureText: true,
          ),
          const SizedBox(height: 12),
          _glassField(
            controller: _confirm,
            hint: 'Confirm password',
            icon: Icons.lock_reset_outlined,
            obscureText: true,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.aqua,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: Colors.grey,
              ),
              onPressed: _isLoading ? null : _handleSignUp,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Create account'),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Back to login',
              style: TextStyle(
                color: _isDark ? AppColors.aqua : AppColors.navy,
              ), // Changed
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the list of form fields based on the selected role.
  List<Widget> _buildFormFields() {
    if (_selectedRole == 'Passenger') {
      return [
        _glassField(
          controller: _name,
          hint: 'Name',
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 12),
        _glassField(
          controller: _email,
          hint: 'Email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        _glassField(
          controller: _username,
          hint: 'Username',
          icon: Icons.alternate_email,
        ),
        const SizedBox(height: 12),
        _glassField(
          controller: _phone,
          hint: 'Mobile Number',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 12),
        _glassField(
          controller: _aadhar,
          hint: 'Aadhar Number',
          icon: Icons.badge_outlined,
          keyboardType: TextInputType.number,
        ),
      ];
    } else {
      // Employee fields
      return [
        _glassField(
          controller: _employeeId,
          hint: 'Employee ID',
          icon: Icons.badge_outlined,
        ),
        const SizedBox(height: 12),
        _glassField(
          controller: _name,
          hint: 'Employee Name',
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 12),
        _glassField(
          controller: _email,
          hint: 'Employee Email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        _glassField(
          controller: _phone,
          hint: 'Employee Phone Number',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 12),
        _glassField(
          controller: _aadhar,
          hint: 'Employee Aadhar Number',
          icon: Icons.badge_outlined,
          keyboardType: TextInputType.number,
        ),
      ];
    }
  }

  /// A button for role selection.
  Widget _roleButton(String role) {
    final isSelected = _selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedRole = role);
          // You might want to clear controllers here if needed
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Center(
            child: Text(
              role,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color:
                    isSelected
                        ? Colors.white
                        : (_isDark ? Colors.white70 : Colors.black), // Changed
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _glassField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color:
            _isDark
                ? Colors.white.withOpacity(0.06)
                : Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(
          color: _isDark ? Colors.white : Colors.black,
        ), // Added this line
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: _isDark ? Colors.white54 : Colors.black54,
          ), // Added this line
          prefixIcon: Icon(
            icon,
            color: _isDark ? Colors.white70 : Colors.black87,
          ), // Changed this line
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  /// Handles the signup process with validation
  Future<void> _handleSignUp() async {
    // Validation
    if (_email.text.trim().isEmpty) {
      _showError('Please enter your email');
      return;
    }

    if (_password.text.isEmpty) {
      _showError('Please enter a password');
      return;
    }

    if (_password.text.length < 6) {
      _showError('Password must be at least 6 characters');
      return;
    }

    if (_password.text != _confirm.text) {
      _showError('Passwords do not match');
      return;
    }

    if (_selectedRole == 'Passenger') {
      if (_name.text.trim().isEmpty ||
          _username.text.trim().isEmpty ||
          _phone.text.trim().isEmpty ||
          _aadhar.text.trim().isEmpty) {
        _showError('Please fill in all required fields');
        return;
      }
    } else if (_selectedRole == 'Employee') {
      if (_employeeId.text.trim().isEmpty ||
          _name.text.trim().isEmpty ||
          _phone.text.trim().isEmpty ||
          _aadhar.text.trim().isEmpty) {
        _showError('Please fill in all required fields');
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      // Sign up with Supabase
      final response = await _authService.signUpWithEmail(
        _email.text.trim(),
        _password.text,
      );

      // If signup successful, optionally store additional user metadata
      if (response.user != null) {
        // You can store additional user data in Supabase here
        // For example, using Supabase database tables or user metadata
        try {
          final supabase = Supabase.instance.client;
          await supabase.from('user_profiles').insert({
            'user_id': response.user!.id,
            'role': _selectedRole.toLowerCase(),
            'name': _name.text.trim(),
            'phone': _phone.text.trim(),
            'aadhar': _aadhar.text.trim(),
            if (_selectedRole == 'Passenger') 'username': _username.text.trim(),
            if (_selectedRole == 'Employee') 'employee_id': _employeeId.text.trim(),
          });
        } catch (e) {
          // If table doesn't exist or insert fails, continue anyway
          // The user account is still created
          print('Could not save user profile: $e');
        }
      }

      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully! Please check your email to verify.'),
            backgroundColor: AppColors.green,
            duration: Duration(seconds: 3),
          ),
        );
        // Navigate back to login after a short delay
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.of(context).pop();
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showError('Signup failed: ${e.toString()}');
      }
    }
  }

  /// Shows an error message
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

class _BlobPainter extends CustomPainter {
  final double t;
  final Color base1;
  final Color base2;

  _BlobPainter({required this.t, required this.base1, required this.base2});

  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Paint()..color = base1.withOpacity(0.9);
    final p2 = Paint()..color = base2.withOpacity(0.6);
    final p3 = Paint()..color = base2.withOpacity(0.3);

    final w = size.width;
    final h = size.height;

    final cx = w * (0.3 + 0.05 * (1 - (t - 0.5).abs() * 2));
    final cy = h * (0.25 + 0.02 * (1 - (t - 0.5).abs() * 2));

    canvas.drawCircle(Offset(cx, cy), w * 0.45, p1);
    canvas.drawCircle(Offset(w * (0.85 - 0.05 * t), h * 0.75), w * 0.55, p2);
    canvas.drawCircle(
      Offset(w * (0.2 + 0.1 * t), h * (0.9 - 0.05 * t)),
      w * 0.35,
      p3,
    );
  }

  @override
  bool shouldRepaint(covariant _BlobPainter oldDelegate) =>
      oldDelegate.t != t ||
      oldDelegate.base1 != base1 ||
      oldDelegate.base2 != base2;
}
