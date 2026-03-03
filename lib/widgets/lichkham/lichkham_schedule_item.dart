import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../data/models/lichkham_model.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/theme_extensions.dart';

class LichkhamScheduleItem extends StatelessWidget {
  final LichkhamModel schedule;

  const LichkhamScheduleItem({
    super.key,
    required this.schedule,
  });

  @override
  Widget build(BuildContext context) {
    final isToday = _isToday(schedule.ngay);
    final isDark = context.isDark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isToday
              ? AppColors.primary.withValues(alpha: 0.3)
              : (isDark ? const Color(0xFF38383A) : const Color(0xFFE8EAF0)),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildDateBox(schedule.ngay, isToday, isDark),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShiftRow(schedule.isMorning, isDark),
                    const SizedBox(height: 8),
                    _buildDoctorRow(schedule.doctorName, isDark),
                    const SizedBox(height: 4),
                    _buildNurseRow(schedule.nurseName, isDark),
                  ],
                ),
              ),
            ],
          ),
          if (schedule.hasNote) ...[
            const SizedBox(height: 10),
            _buildNoteBox(schedule.ghiChu!, isDark),
          ],
        ],
      ),
    );
  }

  Widget _buildDateBox(DateTime date, bool isToday, bool isDark) {
    return Container(
      width: 52,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isToday ? AppColors.primary : (isDark ? const Color(0xFF38383A) : Colors.white),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            DateFormat('dd').format(date),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isToday ? Colors.white : (isDark ? Colors.white : const Color(0xFF1A1A1A)),
            ),
          ),
          Text(
            'Th${date.month}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isToday
                  ? Colors.white.withValues(alpha: 0.9)
                  : (isDark ? Colors.grey[400] : Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShiftRow(bool isMorning, bool isDark) {
    return Row(
      children: [
        FaIcon(
          isMorning ? FontAwesomeIcons.cloudSun : FontAwesomeIcons.moon,
          size: 14,
          color: AppColors.primary,
        ),
        const SizedBox(width: 6),
        Text(
          isMorning ? 'Buổi sáng' : 'Buổi chiều',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorRow(String doctorName, bool isDark) {
    return Row(
      children: [
        const FaIcon(
          FontAwesomeIcons.userDoctor,
          size: 12,
          color: Color(0xFF1565C0),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            'BS: $doctorName',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNurseRow(String nurseName, bool isDark) {
    return Row(
      children: [
        const FaIcon(
          FontAwesomeIcons.userNurse,
          size: 12,
          color: Color(0xFF1565C0),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            'ĐD: $nurseName',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoteBox(String note, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF3A3F2E) : const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? const Color(0xFF5C6B47).withValues(alpha: 0.7) : const Color(0xFFFFE69C).withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FaIcon(
            FontAwesomeIcons.circleExclamation,
            size: 14,
            color: isDark ? const Color(0xFFFBBC04) : const Color(0xFFF59E0B),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              note,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.grey[300] : const Color(0xFF856404),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
