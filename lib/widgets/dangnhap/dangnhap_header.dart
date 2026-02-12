import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../common/animated_logo.dart';

class DangnhapHeader extends StatelessWidget {
  const DangnhapHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'app_logo',
      child: Column(
        children: [
          const AnimatedLogo(
            size: 120,
            showBorderCircles: true,
            showGlow: true,
          ),
          const SizedBox(height: 24),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Colors.white,
                Color(0xFFE3F2FD),
                Colors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ).createShader(bounds),
            child: const Text(
              'BỆNH VIỆN HÙNG VƯƠNG GIA LAI',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                height: 1.3,
                shadows: [
                  Shadow(
                    color: Color(0xFF1976D2),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                  Shadow(
                    color: Color(0xFF0D47A1),
                    blurRadius: 4,
                    offset: Offset(0, 1.5),
                  ),
                  Shadow(
                    color: Colors.black38,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          )
              .animate()
              .fadeIn(delay: 300.ms, duration: 700.ms)
              .slideY(begin: 0.3, end: 0, curve: Curves.easeOut)
              .then(delay: 200.ms)
              .shimmer(duration: 1200.ms, color: Colors.white.withValues(alpha: 0.3)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Text(
              'HUNG VUONG GIA LAI HOSPITAL',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 2.5,
                height: 1.4,
                shadows: [
                  Shadow(
                    color: Color(0xFF1976D2),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                  Shadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          )
              .animate()
              .fadeIn(delay: 500.ms, duration: 700.ms)
              .slideY(begin: 0.3, end: 0, curve: Curves.easeOut)
              .then(delay: 100.ms)
              .shimmer(duration: 1400.ms, color: Colors.white.withValues(alpha: 0.2)),
        ],
      ),
    );
  }
}
