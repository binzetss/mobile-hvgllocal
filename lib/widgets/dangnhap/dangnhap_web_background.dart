import 'package:flutter/material.dart';

class DangnhapWebBackground extends StatelessWidget {
  const DangnhapWebBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
