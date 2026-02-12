import 'dart:math' as math;
import 'package:flutter/material.dart';

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
    final paint = Paint()..style = PaintingStyle.fill;

    for (final particle in particles) {
      final x =
          (particle.x * size.width + animationValue * particle.speedX * 100) %
          size.width;
      final y =
          (particle.y * size.height + animationValue * particle.speedY * 50) %
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
