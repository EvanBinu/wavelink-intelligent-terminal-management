import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:wavelink/core/constants/app_colors.dart';
import 'package:wavelink/core/utils/navigation_helper.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _email = TextEditingController();
  late final AnimationController _bg;
  bool _isDark = false;

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
    _email.dispose();
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
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Container(
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
                            const Text(
                              'Reset password',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.dark_mode, size: 18),
                                Switch(
                                  value: _isDark,
                                  onChanged: (v) => setState(() => _isDark = v),
                                  activeColor: AppColors.aqua,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color:
                                _isDark
                                    ? Colors.white.withOpacity(0.06)
                                    : Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.25),
                            ),
                          ),
                          child: TextField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: 'Enter your account email',
                              prefixIcon: Icon(Icons.email_outlined),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                            ),
                          ),
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
                            ),
                            onPressed: () {
                              // TODO: integrate password reset flow
                              Navigator.of(context).pop();
                            },
                            child: const Text('Send reset link'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Back to login'),
                        ),
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
