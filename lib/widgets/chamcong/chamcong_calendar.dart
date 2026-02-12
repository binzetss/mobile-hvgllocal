import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/chamcong_model.dart';

class ChamcongCalendar extends StatefulWidget {
  final DateTime selectedDate;
  final List<ChamcongModel> attendances;
  final Function(DateTime) onDateSelected;
  final Function(int year, int month) onMonthChanged;

  const ChamcongCalendar({
    super.key,
    required this.selectedDate,
    required this.attendances,
    required this.onDateSelected,
    required this.onMonthChanged,
  });

  @override
  State<ChamcongCalendar> createState() => _ChamcongCalendarState();
}

class _ChamcongCalendarState extends State<ChamcongCalendar> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(widget.selectedDate.year, widget.selectedDate.month, 1);
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
    widget.onMonthChanged(_currentMonth.year, _currentMonth.month);
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
    widget.onMonthChanged(_currentMonth.year, _currentMonth.month);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.1),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildWeekDays(),
          const SizedBox(height: 12),
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _getMonthYearText(_currentMonth),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        Row(
          children: [
            _buildNavigationButton(
              icon: Icons.chevron_left_rounded,
              onPressed: _previousMonth,
            ),
            const SizedBox(width: 8),
            _buildNavigationButton(
              icon: Icons.chevron_right_rounded,
              onPressed: _nextMonth,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: AppColors.primary.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildWeekDays() {
    const weekDays = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekDays.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary.withValues(alpha: 0.8),
                letterSpacing: -0.2,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final startingWeekday = firstDayOfMonth.weekday % 7;

    final List<Widget> dayWidgets = [];

    for (int i = 0; i < startingWeekday; i++) {
      dayWidgets.add(const SizedBox.shrink());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
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
    final attendance = widget.attendances.firstWhere(
      (a) => a.date.year == date.year && a.date.month == date.month && a.date.day == date.day,
      orElse: () => ChamcongModel(
        id: '',
        userId: '',
        date: date,
        status: ChamcongStatus.absent,
      ),
    );

    final isSelected = widget.selectedDate.year == date.year &&
        widget.selectedDate.month == date.month &&
        widget.selectedDate.day == date.day;

    final isToday = DateTime.now().year == date.year &&
        DateTime.now().month == date.month &&
        DateTime.now().day == date.day;

    final isFuture = date.isAfter(DateTime.now());

    Color backgroundColor = Colors.transparent;
    Color dotColor = Colors.transparent;
    Color textColor = AppColors.textPrimary;

    if (isSelected) {
      backgroundColor = AppColors.primary;
      textColor = Colors.white;
    } else if (isToday) {
      backgroundColor = AppColors.primary.withValues(alpha: 0.1);
      textColor = AppColors.primary;
    }

    if (!isFuture && attendance.id.isNotEmpty) {
      switch (attendance.status) {
        case ChamcongStatus.present:
          dotColor = Colors.green;
          break;
        case ChamcongStatus.late:
          dotColor = Colors.orange;
          break;
        case ChamcongStatus.absent:
          dotColor = Colors.red;
          break;
        case ChamcongStatus.earlyLeave:
          dotColor = Colors.amber;
          break;
        case ChamcongStatus.weekend:
          dotColor = AppColors.textSecondary.withValues(alpha: 0.3);
          break;
        case ChamcongStatus.holiday:
          dotColor = Colors.blue;
          break;
      }
    }

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () => widget.onDateSelected(date),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected || isToday ? FontWeight.w700 : FontWeight.w600,
                  color: isFuture
                      ? AppColors.textSecondary.withValues(alpha: 0.3)
                      : textColor,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              if (dotColor != Colors.transparent)
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonthYearText(DateTime date) {
    const months = [
      'Tháng 1',
      'Tháng 2',
      'Tháng 3',
      'Tháng 4',
      'Tháng 5',
      'Tháng 6',
      'Tháng 7',
      'Tháng 8',
      'Tháng 9',
      'Tháng 10',
      'Tháng 11',
      'Tháng 12',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
