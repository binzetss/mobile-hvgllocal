import 'dart:math' as math;
import 'package:flutter/material.dart';

class DangnhapSuccessOverlay extends StatefulWidget {
  const DangnhapSuccessOverlay({super.key});

  @override
  State<DangnhapSuccessOverlay> createState() => _DangnhapSuccessOverlayState();
}

class _DangnhapSuccessOverlayState extends State<DangnhapSuccessOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );


    _scaleAnimation = Tween<double>(begin: 0.0, end: 5.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInCubic,
      ),
    );

  
    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.0),
        weight: 80, 
      ),
    ]).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final logoTop = 40.0 + MediaQuery.of(context).padding.top + 50;
    final logoCenter = Offset(size.width / 2, logoTop);

    return Material(
      color: Colors.transparent,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _RadialWhitePainter(
                    center: logoCenter,
                    radius: _scaleAnimation.value * size.height * 1.5,
                    opacity: _opacityAnimation.value,
                  ),
                ),
              ),
    
              if (_scaleAnimation.value > 2.0)
                Positioned.fill(
                  child: Container(
                    color: Colors.white.withValues(
                      alpha: math.min(1.0, (_scaleAnimation.value - 2.0) / 1.5),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _RadialWhitePainter extends CustomPainter {
  final Offset center;
  final double radius;
  final double opacity;

  _RadialWhitePainter({
    required this.center,
    required this.radius,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: opacity),
          Colors.white.withValues(alpha: opacity * 0.9),
          Colors.white.withValues(alpha: opacity * 0.7),
          Colors.white.withValues(alpha: opacity * 0.5),
          Colors.white.withValues(alpha: opacity * 0.2),
          Colors.white.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_RadialWhitePainter oldDelegate) {
    return oldDelegate.radius != radius || oldDelegate.opacity != opacity;
  }
}
