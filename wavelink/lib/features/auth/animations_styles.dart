import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

Color navy = const Color(0xFF0D1B2A);
Color aqua = const Color(0xFF00B4D8);

Widget buildSkyBackground(Size size, bool isDarkMode) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 800),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDarkMode
            ? [
                const Color(0xFF0A0E27),
                const Color(0xFF1B1F3A),
                const Color(0xFF2C3E50),
                const Color(0xFF34495E),
              ]
            : [
                const Color(0xFFFFB75E),
                const Color(0xFFED8F03),
                const Color(0xFF87CEEB),
                const Color(0xFF4A90E2),
              ],
      ),
    ),
  );
}

// --- Sun/Moon ---
Widget buildSunMoon(Size size, AnimationController sunController, bool isDarkMode) {
  return AnimatedBuilder(
    animation: sunController,
    builder: (context, child) {
      final breathe = 1.0 + sin(sunController.value * 2 * pi) * 0.1;
      return Positioned(
        top: size.height * 0.15,
        right: size.width * 0.15,
        child: Transform.scale(
          scale: breathe,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: isDarkMode
                    ? [
                        Colors.white.withOpacity(0.9),
                        Colors.white.withOpacity(0.5),
                        Colors.white.withOpacity(0.1),
                      ]
                    : [
                        const Color(0xFFFFF3B0),
                        const Color(0xFFFFD54F),
                        Colors.orange.withOpacity(0.3),
                      ],
              ),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.3)
                      : Colors.orange.withOpacity(0.5),
                  blurRadius: 60,
                  spreadRadius: 20,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

// --- Distant Islands ---
Widget buildDistantIslands(Size size, bool isDarkMode) {
  return Positioned(
    bottom: size.height * 0.35,
    child: SizedBox(
      width: size.width,
      height: 80,
      child: CustomPaint(painter: IslandPainter(isDarkMode: isDarkMode)),
    ),
  );
}

// --- Waves ---
Widget buildOceanWaves(Size size, AnimationController waveController, bool isDarkMode) {
  return AnimatedBuilder(
    animation: waveController,
    builder: (context, child) {
      return Stack(
        children: [
          CustomPaint(
            size: Size(size.width, size.height),
            painter: WavePainter(
              animation: waveController,
              color: isDarkMode ? const Color(0xFF1A237E).withOpacity(0.4) : navy.withOpacity(0.3),
              waveHeight: 35,
              offset: 0,
              speed: 1.0,
            ),
          ),
          CustomPaint(
            size: Size(size.width, size.height),
            painter: WavePainter(
              animation: waveController,
              color: isDarkMode ? const Color(0xFF283593).withOpacity(0.5) : aqua.withOpacity(0.4),
              waveHeight: 28,
              offset: 150,
              speed: 1.3,
            ),
          ),
          CustomPaint(
            size: Size(size.width, size.height),
            painter: WavePainter(
              animation: waveController,
              color: isDarkMode ? const Color(0xFF3949AB).withOpacity(0.6) : aqua.withOpacity(0.5),
              waveHeight: 22,
              offset: 300,
              speed: 1.6,
            ),
          ),
          CustomPaint(
            size: Size(size.width, size.height),
            painter: ShimmerPainter(animation: waveController, isDarkMode: isDarkMode),
          ),
        ],
      );
    },
  );
}

// --- Mist ---
Widget buildFloatingMist(Size size, AnimationController particleController, bool isDarkMode) {
  return AnimatedBuilder(
    animation: particleController,
    builder: (context, child) {
      return CustomPaint(
        size: Size(size.width, size.height),
        painter: MistPainter(animation: particleController, isDarkMode: isDarkMode),
      );
    },
  );
}

// --- Boats ---
Widget buildMovingBoats(Size size, AnimationController boatController, bool isDarkMode) {
  return AnimatedBuilder(
    animation: boatController,
    builder: (context, child) {
      return Container(); // you can implement boats here if needed
    },
  );
}

// --- Ripple ---
Widget buildRippleEffects(Size size, AnimationController rippleController) {
  return AnimatedBuilder(
    animation: rippleController,
    builder: (context, child) {
      return CustomPaint(
        size: Size(size.width, size.height),
        painter: RipplePainter(animation: rippleController),
      );
    },
  );
}

// --- Custom Painters ---
class WavePainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;
  final double waveHeight;
  final double offset;
  final double speed;

  WavePainter({required this.animation, required this.color, required this.waveHeight, required this.offset, required this.speed}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final path = Path();
    final waveLength = size.width / 2;
    final animationValue = animation.value * 2 * pi * speed;

    path.moveTo(0, size.height * 0.65);
    for (double x = 0; x <= size.width; x++) {
      final y = size.height * 0.65 + sin((x / waveLength * 2 * pi) + animationValue + offset / 100) * waveHeight;
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => true;
}

class ShimmerPainter extends CustomPainter {
  final Animation<double> animation;
  final bool isDarkMode;

  ShimmerPainter({required this.animation, required this.isDarkMode}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(isDarkMode ? 0.1 : 0.3)..style = PaintingStyle.fill;
    final random = Random(42);
    final animValue = animation.value;
    for (int i = 0; i < 15; i++) {
      final x = (random.nextDouble() * size.width + animValue * size.width) % size.width;
      final y = size.height * 0.6 + random.nextDouble() * size.height * 0.15;
      final width = 20 + random.nextDouble() * 40;
      final height = 2 + random.nextDouble() * 3;
      canvas.drawOval(Rect.fromLTWH(x, y, width, height), paint);
    }
  }

  @override
  bool shouldRepaint(ShimmerPainter oldDelegate) => true;
}

class MistPainter extends CustomPainter {
  final Animation<double> animation;
  final bool isDarkMode;

  MistPainter({required this.animation, required this.isDarkMode}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(isDarkMode ? 0.08 : 0.15)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    final random = Random(123);
    for (int i = 0; i < 30; i++) {
      final baseX = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height * 0.6;
      final x = baseX + sin(animation.value * 2 * pi + i) * 30;
      final y = baseY + cos(animation.value * pi + i * 0.5) * 20;
      final radius = 15 + random.nextDouble() * 25;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(MistPainter oldDelegate) => true;
}

class IslandPainter extends CustomPainter {
  final bool isDarkMode;

  IslandPainter({required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = isDarkMode ? const Color(0xFF1A1A2E).withOpacity(0.6) : const Color(0xFF2C3E50).withOpacity(0.4)..style = PaintingStyle.fill;

    final path1 = Path();
    path1.moveTo(size.width * 0.1, size.height);
    path1.quadraticBezierTo(size.width * 0.15, size.height * 0.3, size.width * 0.25, size.height);
    path1.close();
    canvas.drawPath(path1, paint);

    final path2 = Path();
    path2.moveTo(size.width * 0.5, size.height);
    path2.quadraticBezierTo(size.width * 0.6, size.height * 0.2, size.width * 0.75, size.height);
    path2.close();
    canvas.drawPath(path2, paint);

    final path3 = Path();
    path3.moveTo(size.width * 0.8, size.height);
    path3.quadraticBezierTo(size.width * 0.85, size.height * 0.5, size.width * 0.95, size.height);
    path3.close();
    canvas.drawPath(path3, paint);
  }

  @override
  bool shouldRepaint(IslandPainter oldDelegate) => false;
}

class RipplePainter extends CustomPainter {
  final Animation<double> animation;

  RipplePainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    if (animation.value == 0) return;
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3 * (1 - animation.value))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final center = Offset(size.width / 2, size.height * 0.7);
    final radius = animation.value * 150;
    canvas.drawCircle(center, radius, paint);
    canvas.drawCircle(center, radius * 0.7, paint);
    canvas.drawCircle(center, radius * 0.4, paint);
  }

  @override
  bool shouldRepaint(RipplePainter oldDelegate) => true;
}
