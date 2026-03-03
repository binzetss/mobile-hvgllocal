import 'package:flutter/material.dart';
import '../../core/extensions/theme_extensions.dart';
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
    final isDark = context.isDark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF38383A) : const Color(0xFFF0F1F5),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          _buildWeekDays(context),
          const SizedBox(height: 12),
          _buildCalendarGrid(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isDark = context.isDark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _getMonthYearText(_currentMonth),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
            color: isDark ? Colors.white : const Color(0xFF0F0F0F),
          ),
        ),
        Row(
          children: [
            _buildNavigationButton(
              context: context,
              icon: Icons.chevron_left_rounded,
              onPressed: _previousMonth,
            ),
            const SizedBox(width: 6),
            _buildNavigationButton(
              context: context,
              icon: Icons.chevron_right_rounded,
              onPressed: _nextMonth,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNavigationButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        splashColor: context.primaryColor.withValues(alpha: 0.1),
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: context.primaryColor,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildWeekDays(BuildContext context) {
    final isDark = context.isDark;
    const weekDays = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekDays.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isDark 
                  ? Colors.grey[400]
                  : Colors.grey[600],
                letterSpacing: -0.1,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid(BuildContext context) {
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final startingWeekday = firstDayOfMonth.weekday % 7;

    final List<Widget> dayWidgets = [];

    for (int i = 0; i < startingWeekday; i++) {
      dayWidgets.add(const SizedBox.shrink());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      dayWidgets.add(_buildDayCell(context, date));
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.0,
      children: dayWidgets,
    );
  }

  Widget _buildDayCell(BuildContext context, DateTime date) {
    final isDark = context.isDark;
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
    Color textColor = context.textPrimary;

    if (isSelected) {
      backgroundColor = context.primaryColor;
      textColor = Colors.white;
    } else if (isToday) {
      backgroundColor = isDark 
        ? context.primaryColor.withValues(alpha: 0.12)
        : context.primaryColor.withValues(alpha: 0.08);
      textColor = context.primaryColor;
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
          dotColor = isDark
            ? Colors.grey[500]!
            : Colors.grey[300]!;
          break;
        case ChamcongStatus.holiday:
          dotColor = Colors.blue;
          break;
      }
    }

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () => widget.onDateSelected(date),
        borderRadius: BorderRadius.circular(8),
        splashColor: context.primaryColor.withValues(alpha: 0.1),
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
                      ? (isDark ? Colors.grey[600] : Colors.grey[400])
                      : textColor,
                ),
              ),
              if (dotColor != Colors.transparent) ...[
                const SizedBox(height: 2),
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ]
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
