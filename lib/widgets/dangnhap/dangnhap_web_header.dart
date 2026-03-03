import 'package:flutter/material.dart';

class DangnhapWebHeader extends StatelessWidget {
  const DangnhapWebHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo tròn
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Image.asset(
              'assets/images/logo_splash.png',
              fit: BoxFit.contain,
            ),
          ),
        ),

        const SizedBox(height: 18),

        const Text(
          'HÙNG VƯƠNG GIA LAI',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
            shadows: [
              Shadow(
                color: Color(0xFF003D7A),
                offset: Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 6),

        Text(
          'Hệ Thống Quản Lý Nội Bộ',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.85),
            fontSize: 13,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 20),

        // Separator
        Container(
          width: 48,
          height: 2,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.40),
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        const SizedBox(height: 20),

        // Feature list
        _FeatureRow(
          icon: Icons.badge_outlined,
          text: 'Quản lý hồ sơ nhân viên',
        ),
        const SizedBox(height: 12),
        _FeatureRow(
          icon: Icons.access_time_rounded,
          text: 'Chấm công & Bổ sung công',
        ),
        const SizedBox(height: 12),
        _FeatureRow(
          icon: Icons.description_outlined,
          text: 'Văn bản & Thông báo nội bộ',
        ),
        const SizedBox(height: 12),
        _FeatureRow(
          icon: Icons.payments_outlined,
          text: 'Bảng lương & Đào tạo',
        ),
      ],
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.18),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.30),
              width: 1,
            ),
          ),
          child: Icon(icon, color: Colors.white, size: 17),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.90),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
