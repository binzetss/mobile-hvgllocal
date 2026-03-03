import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/theme_extensions.dart';

class GioithieuFooter extends StatelessWidget {
  const GioithieuFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Center(
      child: Column(
        children: [
          Divider(
            color: isDark ? Colors.grey[700] : Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Powered by Phòng Công Nghệ Thông Tin',
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? Colors.grey[500]
                  : AppColors.textSecondary.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '© 2026 Bệnh viện Hùng Vượng Gia Lai',
            style: TextStyle(
              fontSize: 11,
              color: isDark
                  ? Colors.grey[600]
                  : AppColors.textSecondary.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
