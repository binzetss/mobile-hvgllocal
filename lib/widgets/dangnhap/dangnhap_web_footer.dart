import 'package:flutter/material.dart';

class DangnhapWebFooter extends StatelessWidget {
  const DangnhapWebFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24, top: 8),
      child: Column(
        children: [
          const Text(
            '© Copyright 2026 Bệnh viện Hùng Vương Gia Lai',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(fontSize: 11, color: Colors.white54),
              children: [
                TextSpan(text: 'Powered by '),
                TextSpan(
                  text: 'Phòng Công Nghệ Thông Tin™',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
