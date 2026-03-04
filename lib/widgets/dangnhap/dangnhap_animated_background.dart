import 'package:flutter/material.dart';

class DangnhapAnimatedBackground extends StatelessWidget {
  const DangnhapAnimatedBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF000000),
                  Color(0xFF0A1628),
                  Color(0xFF0D1F3C),
                  Color(0xFF000000),
                ],
                stops: [0.0, 0.3, 0.7, 1.0],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0D47A1),
                  Color(0xFF1976D2),
                  Color(0xFF1E88E5),
                  Color(0xFF64B5F6),
                ],
                stops: [0.0, 0.3, 0.7, 1.0],
              ),
      ),
    );
  }
}
