import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/extensions/theme_extensions.dart';

class WebAppBackground extends StatefulWidget {
  const WebAppBackground({super.key});

  @override
  State<WebAppBackground> createState() => _WebAppBackgroundState();
}

class _WebAppBackgroundState extends State<WebAppBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 28),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Stack(
      fit: StackFit.expand,
      children: [

        Container(
          decoration: BoxDecoration(
            gradient: isDark
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF000000),
                      Color(0xFF04091A),
                      Color(0xFF000000),
                    ],
                  )
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFF3F8FF),
                      Color(0xFFE8F1FC),
                      Color(0xFFF0F6FF),
                    ],
                  ),
          ),
        ),

        AnimatedBuilder(
          animation: _controller,
          builder: (_, _) => CustomPaint(
            painter: _BlobPainter(_controller.value, isDark),
          ),
        ),
      ],
    );
  }
}

class _BlobPainter extends CustomPainter {
  final double t;
  final bool isDark;

  _BlobPainter(this.t, this.isDark);

  void _blob(Canvas c, Offset center, double r, Color color, double alpha) {
    c.drawCircle(center, r, Paint()..color = color.withValues(alpha: alpha));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final s = math.sin(t * math.pi * 2);
    final c = math.cos(t * math.pi * 2);
    final s2 = math.sin(t * math.pi * 2 + 1.1);

    if (isDark) {

      _blob(canvas, Offset(-90 + s * 28, -90 + c * 20), 340,
          const Color(0xFF1A3A8A), 0.20);
      _blob(canvas, Offset(size.width + 70 + c * 22, -70 + s * 16), 300,
          const Color(0xFF0D1F55), 0.16);
      _blob(canvas, Offset(size.width + 50, size.height + 50 - s * 28), 280,
          const Color(0xFF162850), 0.14);
      _blob(canvas,
          Offset(-50, size.height * 0.45 + s2 * 24), 220,
          const Color(0xFF0A1535), 0.12);
      _blob(canvas,
          Offset(size.width * 0.45 + c * 35, size.height + 55), 250,
          const Color(0xFF1A3070), 0.14);
    } else {

      _blob(canvas, Offset(-110 + s * 28, -110 + c * 20), 380,
          const Color(0xFF80B8E8), 0.38);
      _blob(canvas, Offset(size.width + 90 + c * 22, -80 + s * 16), 320,
          const Color(0xFFA8D0F5), 0.32);
      _blob(canvas, Offset(size.width + 60, size.height + 60 - s * 26), 300,
          const Color(0xFF90C4EE), 0.30);
      _blob(canvas,
          Offset(-65, size.height * 0.42 + s2 * 22), 230,
          const Color(0xFFB0D5F8), 0.24);
      _blob(canvas,
          Offset(size.width * 0.48 + c * 32, size.height + 65), 260,
          const Color(0xFF78AEDD), 0.22);

      _blob(canvas,
          Offset(size.width * 0.75 + s * 18, size.height * 0.25 + c * 14),
          180, const Color(0xFFBFDDFF), 0.14);
    }
  }

  @override
  bool shouldRepaint(_BlobPainter old) =>
      old.t != t || old.isDark != isDark;
}
