import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/chamcong_provider.dart';
import '../../widgets/chamcong/chamcong_calendar.dart';
import '../../widgets/chamcong/chamcong_stats_card.dart';
import '../../widgets/chamcong/chamcong_history_card.dart';
import 'bosungcong_page.dart';
import 'danhsach_bosungcong_page.dart';

class ChamcongPage extends StatefulWidget {
  const ChamcongPage({super.key});

  @override
  State<ChamcongPage> createState() => _ChamcongPageState();
}

class _ChamcongPageState extends State<ChamcongPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChamcongProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<ChamcongProvider>(
        builder: (context, provider, child) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: ChamcongStatsCard(stats: provider.monthlyStats),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          icon: FontAwesomeIcons.plus,
                          label: 'Bổ sung công',
                          onTap: () => _navigateToSupplementaryAttendance(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionButton(
                          icon: FontAwesomeIcons.listCheck,
                          label: 'Danh sách công bổ sung',
                          onTap: () => _navigateToSupplementaryList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: ChamcongCalendar(
                    selectedDate: provider.selectedDate,
                    attendances: provider.monthlyAttendances,
                    onDateSelected: (date) {
                      provider.selectDate(date);
                    },
                    onMonthChanged: (year, month) {
                      provider.changeMonth(year, month);
                    },
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: ChamcongHistoryCard(
                    attendance: provider.getAttendanceByDate(
                      provider.selectedDate,
                    ),
                    selectedDate: provider.selectedDate,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.border.withValues(alpha: 0.3),
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                icon,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToSupplementaryAttendance() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BosungcongPage(),
      ),
    );
  }

  void _navigateToSupplementaryList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DanhsachBosungcongPage(),
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
    return '${months[date.month - 1]}, ${date.year}';
  }
}
