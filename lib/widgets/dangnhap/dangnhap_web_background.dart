import 'dart:math' as math;
import 'package:flutter/material.dart';

class DangnhapWebBackground extends StatelessWidget {
  final AnimationController controller;

  const DangnhapWebBackground({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFD5EAF8),
                Color(0xFFADD2EE),
                Color(0xFF80B8E2),
              ],
              stops: [0.0, 0.55, 1.0],
            ),
          ),
        ),

        AnimatedBuilder(
          animation: controller,
          builder: (ctx, _) => CustomPaint(
            painter: _BlobPainter(controller.value),
            size: Size.infinite,
          ),
        ),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 220,
          child: AnimatedBuilder(
            animation: controller,
            builder: (ctx, _) => CustomPaint(
              painter: _WavePainter(controller.value),
            ),
          ),
        ),
      ],
    );
  }
}

class _BlobPainter extends CustomPainter {
  final double t;
  _BlobPainter(this.t);

  void _blob(Canvas canvas, Offset center, double radius, double alpha) {
    canvas.drawCircle(
      center,
      radius,
      Paint()..color = Colors.white.withValues(alpha: alpha),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final s = math.sin(t * math.pi * 2);
    final c = math.cos(t * math.pi * 2);

    _blob(canvas, Offset(-90 + s * 18, -90 + c * 12), 240, 0.22);

    _blob(canvas, Offset(size.width + 70 + c * 16, -70 + s * 10), 200, 0.18);

    _blob(canvas, Offset(size.width + 50, size.height + 50 - s * 18), 190, 0.20);

    _blob(
      canvas,
      Offset(-55, size.height * 0.45 + math.sin(t * math.pi * 2 + 1.2) * 14),
      130,
      0.13,
    );

    _blob(
      canvas,
      Offset(size.width * 0.18 + c * 10, size.height + 35),
      150,
      0.10,
    );
  }

  @override
  bool shouldRepaint(_BlobPainter old) => old.t != t;
}

class _WavePainter extends CustomPainter {
  final double t;
  _WavePainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final shift = math.sin(t * math.pi * 2) * 12;

    final p1 = Path()
      ..moveTo(0, size.height * 0.45 + shift)
      ..cubicTo(
        size.width * 0.22, size.height * 0.15 + shift,
        size.width * 0.45, size.height * 0.65 + shift,
        size.width * 0.65, size.height * 0.35 + shift,
      )
      ..cubicTo(
        size.width * 0.80, size.height * 0.15 + shift,
        size.width * 0.92, size.height * 0.55 + shift,
        size.width, size.height * 0.42 + shift,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      p1,
      Paint()..color = const Color(0xFF5598C8).withValues(alpha: 0.28),
    );

    final shift2 = math.cos(t * math.pi * 2) * 10;
    final p2 = Path()
      ..moveTo(0, size.height * 0.65 + shift2)
      ..quadraticBezierTo(
        size.width * 0.28, size.height * 0.42 + shift2,
        size.width * 0.55, size.height * 0.60 + shift2,
      )
      ..quadraticBezierTo(
        size.width * 0.78, size.height * 0.76 + shift2,
        size.width, size.height * 0.58 + shift2,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      p2,
      Paint()..color = const Color(0xFF3F84B8).withValues(alpha: 0.22),
    );
  }

  @override
  bool shouldRepaint(_WavePainter old) => old.t != t;
}
