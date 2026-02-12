import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DangnhapFooter extends StatelessWidget {
  const DangnhapFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 32, top: 20),
      child: Column(
        children: [
          Container(
            height: 1,
            width: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.0),
                  Colors.white.withValues(alpha: 0.5),
                  Colors.white.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '© 2026 PHÒNG CÔNG NGHỆ THÔNG TIN',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 1300.ms, duration: 600.ms);
  }
}
