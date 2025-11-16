import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:wavelink/core/constants/app_colors.dart';
import 'package:wavelink/core/utils/password_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage>
    with SingleTickerProviderStateMixin {
  final SupabaseClient supabase = Supabase.instance.client;

  // Controllers
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

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
    _password.dispose();
    _confirm.dispose();
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
              Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: _isDark ? Colors.white : Colors.black,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.dark_mode,
                    size: 18,
                    color: _isDark ? Colors.white70 : Colors.black87,
                  ),
                  Switch(
                    value: _isDark,
                    onChanged: (v) => setState(() => _isDark = v),
                    activeColor: AppColors.aqua,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          /// Passenger fields
          _glassField(
            controller: _name,
            hint: "Full Name",
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 12),
          _glassField(
            controller: _email,
            hint: "Email",
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          _glassField(
            controller: _phone,
            hint: "Phone Number",
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          _glassField(
            controller: _password,
            hint: "Password",
            icon: Icons.lock_outline,
            obscureText: true,
          ),
          const SizedBox(height: 12),
          _glassField(
            controller: _confirm,
            hint: "Confirm Password",
            icon: Icons.lock_reset_outlined,
            obscureText: true,
          ),
          const SizedBox(height: 20),

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
              ),
              onPressed: _isLoading ? null : _createPassengerAccount,
              child: _isLoading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : const Text("Create Account"),
            ),
          ),
          const SizedBox(height: 10),

          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Back to Login",
              style: TextStyle(
                color: _isDark ? AppColors.aqua : AppColors.navy,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Create passenger user in `users` table
Future<void> _createPassengerAccount() async {
  if (_email.text.trim().isEmpty ||
      _name.text.trim().isEmpty ||
      _phone.text.trim().isEmpty) {
    _showError("Fill all fields");
    return;
  }

  if (_password.text != _confirm.text) {
    _showError("Passwords do not match");
    return;
  }

  setState(() => _isLoading = true);

  try {
    // Hash password (ASYNC!)
    final hashedPassword = await hashPassword(_password.text);

    // Insert into Supabase
    await supabase.from("users").insert({
      "email": _email.text.trim(),
      "password": hashedPassword,
      "full_name": _name.text.trim(),
      "phone": _phone.text.trim(),
      "role": "passenger",
      "is_active": true,
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Account created!"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  } catch (e) {
    _showError("Signup failed: $e");
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
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
        color: _isDark
            ? Colors.white.withOpacity(0.06)
            : Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(color: _isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: _isDark ? Colors.white54 : Colors.black54,
          ),
          prefixIcon: Icon(
            icon,
            color: _isDark ? Colors.white70 : Colors.black87,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.red,
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
