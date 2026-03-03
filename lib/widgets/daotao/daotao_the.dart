import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../data/models/daotao_model.dart';
import 'daotao_nut_dangky.dart';

class DaotaoThe extends StatelessWidget {
  final DaotaoModel lopDaoTao;

  const DaotaoThe({super.key, required this.lopDaoTao});

  Color get _statusColor {
    if (lopDaoTao.dangMoDangKy) return const Color(0xFF10B981);
    if (lopDaoTao.chuaMoDangKy) return const Color(0xFFF59E0B);
    return const Color(0xFF9CA3AF);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (_statusColor.withValues(alpha: 0.1)).withAlpha(isDark ? 20 : 0),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header màu gradient ──
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.06),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              border: Border(
                bottom: BorderSide(
                  color: _statusColor.withValues(alpha: 0.12),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                // Badge trạng thái
                _TrangThaiBadge(lopDaoTao: lopDaoTao, color: _statusColor),
                if (lopDaoTao.isNew) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B6B), Color(0xFFEE5A24)],
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      'MỚI',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                // Số tiết
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.bookOpen,
                      size: 11,
                      color: _statusColor.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${lopDaoTao.soTiet.toStringAsFixed(lopDaoTao.soTiet % 1 == 0 ? 0 : 1)} tiết',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _statusColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Nội dung chính ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên khóa học
                Text(
                  lopDaoTao.tenLopDaoTao,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                    letterSpacing: -0.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 14),

                // Thông tin ngày
                Row(
                  children: [
                    Expanded(
                      child: _InfoChip(
                        icon: FontAwesomeIcons.calendarDay,
                        label: 'Ngày học',
                        value: _formatDate(lopDaoTao.ngayBatDau),
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  height: 1,
                  color: AppColors.border.withValues(alpha: 0.1),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _InfoChip(
                        icon: FontAwesomeIcons.calendarPlus,
                        label: 'Bắt đầu đăng ký',
                        value: _formatDateTime(lopDaoTao.ngayBatDauDangKy),
                        color: const Color(0xFF10B981),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 36,
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      color: AppColors.border.withValues(alpha: 0.15),
                    ),
                    Expanded(
                      child: _InfoChip(
                        icon: FontAwesomeIcons.calendarXmark,
                        label: 'Hết hạn đăng ký',
                        value: _formatDateTime(lopDaoTao.ngayKetThucDangKy),
                        color: const Color(0xFFF59E0B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Nút đăng ký (chỉ khi đang mở) ──
          if (lopDaoTao.dangMoDangKy) ...[
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: DaotaoDangKyButton(lopDaoTao: lopDaoTao),
            ),
          ] else ...[
            const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final compareDate = DateTime(date.year, date.month, date.day);
    if (today == compareDate) return 'Hôm nay';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatDateTime(DateTime date) {
    final d = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    final t = '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    return '$d $t';
  }
}

class _TrangThaiBadge extends StatelessWidget {
  final DaotaoModel lopDaoTao;
  final Color color;

  const _TrangThaiBadge({required this.lopDaoTao, required this.color});

  @override
  Widget build(BuildContext context) {
    final IconData icon;
    final String text;

    if (lopDaoTao.dangMoDangKy) {
      icon = FontAwesomeIcons.circleCheck;
      text = 'Đang mở đăng ký';
    } else if (lopDaoTao.chuaMoDangKy) {
      icon = FontAwesomeIcons.clock;
      text = 'Sắp mở';
    } else {
      icon = FontAwesomeIcons.lock;
      text = 'Đã đóng';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 11, color: color),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: FaIcon(icon, size: 13, color: color),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
