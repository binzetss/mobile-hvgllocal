import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/daotao_provider.dart';

class DaotaoHeaderStats extends StatelessWidget {
  final DaotaoProvider provider;

  const DaotaoHeaderStats({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final tongSo = provider.isLoading ? 0 : provider.danhSach.length;
    final dangMo = provider.soLopDangMo;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.graduationCap,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chương trình đào tạo',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Đăng ký tham gia các khóa học',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: FontAwesomeIcons.bookOpen,
                  value: '$tongSo',
                  label: 'Tổng khóa học',
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              Expanded(
                child: _StatItem(
                  icon: FontAwesomeIcons.doorOpen,
                  value: '$dangMo',
                  label: 'Đang mở',
                  highlight: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final bool highlight;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: highlight
                ? Colors.white.withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: FaIcon(
              icon,
              color: highlight ? Colors.white.withValues(alpha: 1) : Colors.white,
              size: 14,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color:
                    highlight ? const Color.fromARGB(255, 255, 255, 255) : Colors.white,
                height: 1.1,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: Colors.white.withValues(alpha: 0.65),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
