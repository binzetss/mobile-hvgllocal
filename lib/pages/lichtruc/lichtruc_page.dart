import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
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
    return ChangeNotifierProvider(
      create: (_) => LichtructProvider(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const CommonAppBar(title: 'Lịch Trực'),
        body: Consumer<LichtructProvider>(
          builder: (context, provider, child) {
            final monthSchedules = provider.getMonthSchedules();
            final totalShifts = monthSchedules.length;

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
          },
        ),
      ),
    );
  }
}
