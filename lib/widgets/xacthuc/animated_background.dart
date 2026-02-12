import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _gradientController;
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _particleController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildGradient(),
        _buildParticles(),
        _buildBlurOverlay(),
      ],
    );
  }

  Widget _buildGradient() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _gradientController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                    AppColors.primaryDark,
                    AppColors.primary,
                    _gradientController.value,
                  )!,
                  AppColors.primary,
                  Color.lerp(
                    AppColors.primaryLight,
                    AppColors.primary,
                    _gradientController.value,
                  )!,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildParticles() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _particleController,
        builder: (context, child) {
          return CustomPaint(
            painter: ParticlesPainter(_particleController.value),
          );
        },
      ),
    );
  }

  Widget _buildBlurOverlay() {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          color: Colors.black.withValues(alpha: 0.1),
        ),
      ),
    );
  }
}

class ParticlesPainter extends CustomPainter {
  final double animationValue;
  final List<Particle> particles = [];

  ParticlesPainter(this.animationValue) {
    for (int i = 0; i < 30; i++) {
      particles.add(Particle(i));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final paint = Paint()..style = PaintingStyle.fill;

    for (final particle in particles) {
      final x = (particle.x * size.width +
              animationValue * particle.speedX * 100) %
          size.width;
      final y = (particle.y * size.height +
              animationValue * particle.speedY * 50) %
          size.height;

      paint.color = Colors.white.withValues(alpha: particle.opacity);
      canvas.drawCircle(Offset(x, y), particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlesPainter oldDelegate) => true;
}

class Particle {
  final double x;
  final double y;
  final double size;
  final double opacity;
  final double speedX;
  final double speedY;

  Particle(int seed)
      : x = (math.Random(seed).nextDouble()),
        y = (math.Random(seed * 2).nextDouble()),
        size = math.Random(seed * 3).nextDouble() * 3 + 1,
        opacity = math.Random(seed * 4).nextDouble() * 0.15 + 0.05,
        speedX = math.Random(seed * 5).nextDouble() * 2 - 1,
        speedY = math.Random(seed * 6).nextDouble() * 0.5 + 0.2;
}
