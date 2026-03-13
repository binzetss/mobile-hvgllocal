import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedLogo extends StatelessWidget {
  final double size;
  final bool showBackground;

  const AnimatedLogo({
    super.key,
    this.size = 100,
    this.showBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'app_logo',
      child: Container(
        width: size,
        height: size,
        decoration: showBackground
            ? BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              )
            : null,
        child: ClipOval(
          child: Image.asset(
            'assets/images/Logo3D.png',
            fit: BoxFit.cover,
            width: size,
            height: size,
          ),
        ),
      )
          .animate()
          .scale(duration: 600.ms, curve: Curves.easeOutBack)
          .fade(duration: 1200.ms),
    );
  }
}
