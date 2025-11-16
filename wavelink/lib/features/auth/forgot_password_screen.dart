import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wavelink/core/constants/app_colors.dart';
import 'package:wavelink/core/utils/password_utils.dart'; // ✅ hashing
import 'package:wavelink/core/utils/navigation_helper.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _email = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirm = TextEditingController();

  bool _isDark = false;
  bool _loading = false;

  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  late final AnimationController _bg;

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _bg = AnimationController(vsync: this, duration: const Duration(seconds: 10))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bg.dispose();
    _email.dispose();
    _newPassword.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (_email.text.trim().isEmpty ||
        _newPassword.text.isEmpty ||
        _confirm.text.isEmpty) {
      _showMsg("All fields are required");
      return;
    }

    if (_newPassword.text != _confirm.text) {
      _showMsg("Passwords do not match");
      return;
    }

    if (_newPassword.text.length < 6) {
      _showMsg("Password must be at least 6 characters");
      return;
    }

    setState(() => _loading = true);

    try {
      // Check if email exists
      final user = await supabase
          .from("users")
          .select("id")
          .eq("email", _email.text.trim())
          .maybeSingle();

      if (user == null) {
        _showMsg("No user found with this email");
        setState(() => _loading = false);
        return;
      }

      // Hash password
      final hashed = await hashPassword(_newPassword.text);

      // Update in DB
      await supabase.from("users").update({
        "password": hashed,
        "updated_at": DateTime.now().toIso8601String(),
      }).eq("email", _email.text.trim());

      _showMsg("Password updated successfully!", success: true);

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    } catch (e) {
      _showMsg("Error: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showMsg(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _bg,
            builder: (_, __) => CustomPaint(
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
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _isDark
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
                            const Text(
                              'Reset Password',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w700),
                            ),
                            Switch(
                              value: _isDark,
                              onChanged: (v) => setState(() => _isDark = v),
                              activeColor: AppColors.aqua,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // EMAIL
                        _inputField(
                          controller: _email,
                          hint: "Enter your email",
                          icon: Icons.email_outlined,
                        ),
                        const SizedBox(height: 14),

                        // NEW PASSWORD
                        _inputField(
                          controller: _newPassword,
                          hint: "Enter new password",
                          icon: Icons.lock_outline,
                          obscure: !_showNewPassword,
                          suffix: IconButton(
                            icon: Icon(
                              _showNewPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () => setState(
                              () => _showNewPassword = !_showNewPassword,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // CONFIRM PASSWORD
                        _inputField(
                          controller: _confirm,
                          hint: "Confirm password",
                          icon: Icons.lock_reset,
                          obscure: !_showConfirmPassword,
                          suffix: IconButton(
                            icon: Icon(
                              _showConfirmPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () => setState(
                              () => _showConfirmPassword = !_showConfirmPassword,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _resetPassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.aqua,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text("Update Password"),
                          ),
                        ),

                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Back to login"),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _isDark
            ? Colors.white.withOpacity(0.06)
            : Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
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
