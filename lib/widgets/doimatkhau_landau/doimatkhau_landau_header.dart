import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/theme_extensions.dart';

class DoimatkhauLandauHeader extends StatelessWidget {
  final String hoVaTen;

  const DoimatkhauLandauHeader({super.key, required this.hoVaTen});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      children: [

        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? const [Color(0xFF1C1C1E), Color(0xFF2C2C2E)]
                  : AppColors.primaryGradient,
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: isDark ? 0.1 : 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.shieldHalved,
                      color: isDark ? context.primaryColor : Colors.white,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Bảo mật tài khoản',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: isDark ? context.textPrimary : Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Xin chào, $hoVaTen',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? context.textSecondary
                        : Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),

        Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2D2000) : const Color(0xFFFFF8E1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF7A5C00)
                  : const Color(0xFFFFCC02),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FaIcon(
                FontAwesomeIcons.triangleExclamation,
                color: Color(0xFFF59E0B),
                size: 18,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Đây là lần đầu tiên bạn đăng nhập. Vui lòng đặt mật khẩu mới để bảo vệ tài khoản trước khi sử dụng ứng dụng.',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? const Color(0xFFFBBF24)
                        : const Color(0xFF92400E),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
