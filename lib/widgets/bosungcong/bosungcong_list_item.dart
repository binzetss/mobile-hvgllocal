import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/bosung_chamcong_model.dart';

class BosungcongListItem extends StatelessWidget {
  final int stt;
  final BosungChamcongModel item;

  const BosungcongListItem({
    super.key,
    required this.stt,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.15),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: AppColors.primaryGradient,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '$stt',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.hoVaTen,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                    Text(
                      item.loai,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              _StatusBadge(status: item.trangThai),
            ],
          ),
          const SizedBox(height: 10),
          _InfoRow(
            icon: FontAwesomeIcons.calendar,
            label: 'Ngày',
            value: _formatDate(item.ngayBoSung),
            iconColor: const Color(0xFF42A5F5),
          ),
          const SizedBox(height: 6),
          _InfoRow(
            icon: FontAwesomeIcons.clock,
            label: 'Buổi',
            value: item.buoiText,
            iconColor: const Color(0xFFFF9800),
          ),
          const SizedBox(height: 6),
          _InfoRow(
            icon: FontAwesomeIcons.commentDots,
            label: 'Lý do',
            value: item.lyDo,
            iconColor: const Color(0xFF5C6BC0),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FaIcon(
          icon,
          size: 12,
          color: iconColor,
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 50,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final BosungStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (status) {
      case BosungStatus.pending:
        backgroundColor = Colors.orange.withValues(alpha: 0.15);
        textColor = Colors.orange.shade700;
        text = 'Chờ duyệt';
        break;
      case BosungStatus.approved:
        backgroundColor = AppColors.success.withValues(alpha: 0.15);
        textColor = const Color(0xFF2E7D32);
        text = 'Đã duyệt';
        break;
      case BosungStatus.rejected:
        backgroundColor = AppColors.error.withValues(alpha: 0.15);
        textColor = const Color(0xFFC62828);
        text = 'Từ chối';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: textColor,
          letterSpacing: -0.2,
        ),
      ),
    );
  }
}
