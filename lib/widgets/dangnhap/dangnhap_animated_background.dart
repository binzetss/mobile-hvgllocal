import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'dangnhap_particles.dart';

class DangnhapAnimatedBackground extends StatelessWidget {
  final AnimationController gradientController;
  final AnimationController particleController;

  const DangnhapAnimatedBackground({
    super.key,
    required this.gradientController,
    required this.particleController,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildProfessionalGradient(),
        _buildParticles(),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(color: Colors.black.withValues(alpha: 0.05)),
          ),
        ),
      ],
    );
  }

  Widget _buildProfessionalGradient() {
    return AnimatedBuilder(
      animation: gradientController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(
                  const Color(0xFF0D47A1),
                  const Color(0xFF1565C0),
                  gradientController.value,
                )!,
                const Color(0xFF1976D2),
                Color.lerp(
                  const Color(0xFF1E88E5),
                  const Color(0xFF42A5F5),
                  gradientController.value,
                )!,
                const Color(0xFF64B5F6),
              ],
              stops: const [0.0, 0.3, 0.7, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildParticles() {
    return AnimatedBuilder(
      animation: particleController,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlesPainter(particleController.value),
          size: Size.infinite,
        );
      },
    );
  }
}
