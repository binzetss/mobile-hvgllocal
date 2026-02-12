import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/lichtruc_model.dart';

class LichtructCalendar extends StatelessWidget {
  final DateTime currentMonth;
  final List<LichtructModel> allSchedules;

  const LichtructCalendar({
    super.key,
    required this.currentMonth,
    required this.allSchedules,
  });

  @override
  Widget build(BuildContext context) {
    const weekDays = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekDays.map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary.withValues(alpha: 0.8),
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final daysInMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final startingWeekday = firstDayOfMonth.weekday % 7;

    final List<Widget> dayWidgets = [];

    for (int i = 0; i < startingWeekday; i++) {
      dayWidgets.add(const SizedBox.shrink());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(currentMonth.year, currentMonth.month, day);
      dayWidgets.add(_buildDayCell(date));
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: dayWidgets,
    );
  }

  Widget _buildDayCell(DateTime date) {
    final schedulesForDay = allSchedules.where((s) =>
        s.date.year == date.year &&
        s.date.month == date.month &&
        s.date.day == date.day).toList();

    final isToday = DateTime.now().year == date.year &&
        DateTime.now().month == date.month &&
        DateTime.now().day == date.day;

    final now = DateTime.now();
    final isPast = date.isBefore(DateTime(now.year, now.month, now.day));
    final hasSchedule = schedulesForDay.isNotEmpty;

    Color? backgroundColor;
    Color textColor = AppColors.textPrimary;
    Color borderColor = Colors.transparent;

    if (hasSchedule) {
      if (isPast || isToday) {
        // Đã trực - màu xanh dương
        backgroundColor = const Color(0xFF2196F3).withValues(alpha: 0.15);
        borderColor = const Color(0xFF2196F3);
        textColor = isToday ? Colors.white : const Color(0xFF1976D2);
        if (isToday) {
          backgroundColor = const Color(0xFF2196F3);
        }
      } else {
        // Sẽ trực - màu đỏ
        backgroundColor = const Color(0xFFF44336).withValues(alpha: 0.15);
        borderColor = const Color(0xFFF44336);
        textColor = const Color(0xFFC62828);
      }
    } else if (isToday) {
      backgroundColor = AppColors.primary;
      textColor = Colors.white;
      borderColor = AppColors.primary;
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: hasSchedule || isToday ? 2 : 0,
        ),
      ),
      child: Center(
        child: Text(
          '${date.day}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: hasSchedule || isToday ? FontWeight.w700 : FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
