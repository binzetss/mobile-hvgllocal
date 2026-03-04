import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../data/models/lichtruc_model.dart';
import '../../providers/lichtruc_provider.dart';
import '../../widgets/common/common_app_bar.dart';
import '../../widgets/lichtruc/lichtruc_stats_card.dart';
import '../../widgets/lichtruc/lichtruc_month_selector.dart';
import '../../widgets/lichtruc/lichtruc_calendar.dart';
import '../../widgets/lichtruc/lichtruc_legend.dart';

class LichtructPage extends StatelessWidget {
  const LichtructPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = kIsWeb && MediaQuery.of(context).size.width >= 768;
    return ChangeNotifierProvider(
      create: (_) => LichtructProvider(),
      child: Scaffold(
        backgroundColor: isDesktop ? Colors.transparent : context.bgColor,
        appBar: isDesktop ? null : const CommonAppBar(title: 'Lịch Trực'),
        body: Consumer<LichtructProvider>(
          builder: (context, provider, child) {
            final totalShifts = provider.getMonthSchedules().length;
            if (isDesktop) {
              return _buildDesktopLayout(context, provider, totalShifts);
            }
            return _buildMobileLayout(context, provider, totalShifts);
          },
        ),
      ),
    );
  }
}

Widget _buildMobileLayout(
    BuildContext context, LichtructProvider provider, int totalShifts) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LichtructStatsCard(totalShifts: totalShifts),
        const SizedBox(height: 16),
        LichtructMonthSelector(
          monthYearText: provider.getMonthYearText(),
          onPreviousMonth: provider.previousMonth,
          onNextMonth: provider.nextMonth,
        ),
        const SizedBox(height: 16),
        LichtructCalendar(
          currentMonth: provider.currentMonth,
          allSchedules: provider.allSchedules,
        ),
        const SizedBox(height: 16),
        LichtructLegend(
          completedShifts: provider.getCompletedShifts(),
          upcomingShifts: provider.getUpcomingShifts(),
        ),
        const SizedBox(height: 24),
      ],
    ),
  );
}

Widget _buildDesktopLayout(
    BuildContext context, LichtructProvider provider, int totalShifts) {
  return Column(
    children: [
      _WebTopBar(provider: provider),
      Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(
              width: 400,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: LichtructCalendar(
                  currentMonth: provider.currentMonth,
                  allSchedules: provider.allSchedules,
                ),
              ),
            ),
            VerticalDivider(width: 1, color: context.borderColor),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child:
                              LichtructStatsCard(totalShifts: totalShifts),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: LichtructLegend(
                            completedShifts: provider.getCompletedShifts(),
                            upcomingShifts: provider.getUpcomingShifts(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _WebShiftList(
                      schedules: provider.getMonthSchedules(),
                      monthText: provider.getMonthYearText(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _WebTopBar extends StatelessWidget {
  final LichtructProvider provider;
  const _WebTopBar({required this.provider});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        border: Border(
          bottom: BorderSide(color: context.borderColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const FaIcon(
              FontAwesomeIcons.calendarCheck,
              size: 16,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Lịch Trực',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
            ),
          ),
          const Spacer(),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF2C2C2E)
                  : const Color(0xFFF0F2F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _NavBtn(
                  icon: FontAwesomeIcons.chevronLeft,
                  onTap: provider.previousMonth,
                ),
                SizedBox(
                  width: 148,
                  child: Text(
                    provider.getMonthYearText(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color:
                          isDark ? Colors.white : const Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                _NavBtn(
                  icon: FontAwesomeIcons.chevronRight,
                  onTap: provider.nextMonth,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: FaIcon(icon, size: 12, color: AppColors.primary),
        ),
      ),
    );
  }
}

class _WebShiftList extends StatelessWidget {
  final List<LichtructModel> schedules;
  final String monthText;

  const _WebShiftList({required this.schedules, required this.monthText});

  Color _shiftColor(LoaiCaTruct type) {
    switch (type) {
      case LoaiCaTruct.morning:
        return const Color(0xFF2196F3);
      case LoaiCaTruct.afternoon:
        return const Color(0xFFFF9800);
      case LoaiCaTruct.evening:
        return const Color(0xFF9C27B0);
      case LoaiCaTruct.night:
        return const Color(0xFF3F51B5);
    }
  }

  String _shiftLabel(LoaiCaTruct type) {
    switch (type) {
      case LoaiCaTruct.morning:
        return 'Ca sáng';
      case LoaiCaTruct.afternoon:
        return 'Ca chiều';
      case LoaiCaTruct.evening:
        return 'Ca tối';
      case LoaiCaTruct.night:
        return 'Ca đêm';
    }
  }

  IconData _shiftIcon(LoaiCaTruct type) {
    switch (type) {
      case LoaiCaTruct.morning:
        return FontAwesomeIcons.sun;
      case LoaiCaTruct.afternoon:
        return FontAwesomeIcons.cloud;
      case LoaiCaTruct.evening:
        return FontAwesomeIcons.moon;
      case LoaiCaTruct.night:
        return FontAwesomeIcons.moon;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final now = DateTime.now();
    final sorted = [...schedules]..sort((a, b) => a.date.compareTo(b.date));

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const FaIcon(FontAwesomeIcons.listCheck,
                      size: 14, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Text(
                  'Danh sách ca trực',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color:
                        isDark ? Colors.white : const Color(0xFF1A1A1A),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${sorted.length} ca',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? const Color(0xFF38383A) : Colors.grey[200],
          ),
          if (sorted.isEmpty)
            Padding(
              padding: const EdgeInsets.all(36),
              child: Center(
                child: Column(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.calendarXmark,
                      size: 32,
                      color: AppColors.textSecondary
                          .withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Không có ca trực trong $monthText',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary
                            .withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sorted.length,
              separatorBuilder: (_, _) => Divider(
                height: 1,
                color: isDark
                    ? const Color(0xFF38383A)
                    : Colors.grey[100],
              ),
              itemBuilder: (context, index) {
                final s = sorted[index];
                final color = _shiftColor(s.shiftType);
                final isPast = s.date.isBefore(
                    DateTime(now.year, now.month, now.day));
                final isToday = s.date.year == now.year &&
                    s.date.month == now.month &&
                    s.date.day == now.day;
                return _ShiftListItem(
                  schedule: s,
                  color: color,
                  icon: _shiftIcon(s.shiftType),
                  typeLabel: _shiftLabel(s.shiftType),
                  isPast: isPast,
                  isToday: isToday,
                  isDark: isDark,
                );
              },
            ),
        ],
      ),
    );
  }
}

class _ShiftListItem extends StatelessWidget {
  final LichtructModel schedule;
  final Color color;
  final IconData icon;
  final String typeLabel;
  final bool isPast;
  final bool isToday;
  final bool isDark;

  const _ShiftListItem({
    required this.schedule,
    required this.color,
    required this.icon,
    required this.typeLabel,
    required this.isPast,
    required this.isToday,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    const weekDayNames = ['', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    final weekDay = weekDayNames[schedule.date.weekday];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [

          Container(
            width: 48,
            height: 52,
            decoration: BoxDecoration(
              color: isToday ? color : color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${schedule.date.day}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isToday ? Colors.white : color,
                    height: 1,
                  ),
                ),
                Text(
                  weekDay,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isToday
                        ? Colors.white.withValues(alpha: 0.9)
                        : color.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FaIcon(icon, size: 11, color: color),
                    const SizedBox(width: 6),
                    Text(
                      typeLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  schedule.shift,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.locationDot,
                      size: 10,
                      color:
                          AppColors.textSecondary.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      schedule.location,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary
                            .withValues(alpha: 0.7),
                      ),
                    ),
                    if (schedule.note != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        '·',
                        style: TextStyle(
                          color: AppColors.textSecondary
                              .withValues(alpha: 0.4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          schedule.note!,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary
                                .withValues(alpha: 0.7),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isToday
                  ? color.withValues(alpha: 0.15)
                  : isPast
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isToday ? 'Hôm nay' : isPast ? 'Đã trực' : 'Sắp tới',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isToday
                    ? color
                    : isPast
                        ? Colors.green[700]
                        : Colors.orange[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
