import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class GioithieuFooter extends StatelessWidget {
  const GioithieuFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Divider(),
          const SizedBox(height: 16),
          Text(
            'Powered by Phòng Công Nghệ Thông Tin',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '© 2026 Bệnh viện Hùng Vương Gia Lai',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
