import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/daotao_provider.dart';

class DaotaoLocTrangThai extends StatelessWidget {
  const DaotaoLocTrangThai({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DaotaoProvider>(
      builder: (context, provider, _) {
        return SizedBox(
          height: 42,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildChip(
                icon: FontAwesomeIcons.layerGroup,
                label: 'Tất cả',
                value: 'all',
                isSelected: provider.locTrangThai == 'all',
                onTap: () => provider.locTheoTrangThai('all'),
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              _buildChip(
                icon: FontAwesomeIcons.circleCheck,
                label: 'Đang mở',
                value: 'dangMo',
                isSelected: provider.locTrangThai == 'dangMo',
                onTap: () => provider.locTheoTrangThai('dangMo'),
                color: const Color(0xFF10B981),
                count: provider.soLopDangMo,
              ),
              const SizedBox(width: 8),
              _buildChip(
                icon: FontAwesomeIcons.clock,
                label: 'Sắp mở',
                value: 'chuaMo',
                isSelected: provider.locTrangThai == 'chuaMo',
                onTap: () => provider.locTheoTrangThai('chuaMo'),
                color: const Color(0xFFF59E0B),
              ),
              const SizedBox(width: 8),
              _buildChip(
                icon: FontAwesomeIcons.lock,
                label: 'Đã đóng',
                value: 'hetHan',
                isSelected: provider.locTrangThai == 'hetHan',
                onTap: () => provider.locTheoTrangThai('hetHan'),
                color: const Color(0xFF9CA3AF),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChip({
    required IconData icon,
    required String label,
    required String value,
    required bool isSelected,
    required VoidCallback onTap,
    required Color color,
    int? count,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : AppColors.border.withValues(alpha: 0.15),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              icon,
              size: 12,
              color: isSelected ? Colors.white : color.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : AppColors.textPrimary.withValues(alpha: 0.7),
              ),
            ),
            if (count != null && count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.25)
                      : color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : color,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
