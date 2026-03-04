import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../data/models/lichkham_model.dart';
import '../../providers/lichkham_provider.dart';
import '../../widgets/common/common_app_bar.dart';
import '../../widgets/lichkham/lichkham_header.dart';
import '../../widgets/lichkham/lichkham_filters.dart';
import '../../widgets/lichkham/lichkham_room_card.dart';
import '../../widgets/lichkham/lichkham_empty_state.dart';
import '../../widgets/lichkham/lichkham_shimmer.dart';

class LichkhamPage extends StatefulWidget {
  const LichkhamPage({super.key});

  @override
  State<LichkhamPage> createState() => _LichkhamPageState();
}

class _LichkhamPageState extends State<LichkhamPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<LichkhamProvider>();
      if (!provider.isInitialized) {
        provider.init();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = kIsWeb && MediaQuery.of(context).size.width >= 768;
    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: isDesktop
          ? null
          : const CommonAppBar(title: 'Lịch khám bệnh'),
      body: Consumer<LichkhamProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const LichkhamShimmer();
          }
          if (isDesktop) {
            return _buildWebLayout(context, provider);
          }
          return _buildMobileLayout(context, provider);
        },
      ),
    );
  }

  Widget _buildMobileLayout(
      BuildContext context, LichkhamProvider provider) {
    final grouped = provider.getGroupedSchedules();
    return RefreshIndicator(
      onRefresh: provider.refresh,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: const LichkhamHeader()
                .animate()
                .fadeIn(duration: const Duration(milliseconds: 20))
                .slideY(
                  begin: -0.1,
                  end: 0,
                  duration: const Duration(milliseconds: 20),
                  curve: Curves.easeOutCubic,
                ),
          ),
          SliverToBoxAdapter(
            child: const LichkhamFilters()
                .animate()
                .fadeIn(
                  delay: const Duration(milliseconds: 20),
                  duration: const Duration(milliseconds: 20),
                )
                .slideY(
                  begin: -0.05,
                  end: 0,
                  delay: const Duration(milliseconds: 20),
                  duration: const Duration(milliseconds: 20),
                  curve: Curves.easeOutCubic,
                ),
          ),
          if (grouped.isEmpty)
            const SliverFillRemaining(child: LichkhamEmptyState())
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final room = grouped.keys.elementAt(index);
                    final schedules = grouped[room]!;
                    return LichkhamRoomCard(
                      roomName: room,
                      schedules: schedules,
                    )
                        .animate()
                        .fadeIn(
                          delay: Duration(
                              milliseconds: 200 + (50 * index)),
                          duration: const Duration(milliseconds: 400),
                        )
                        .slideY(
                          begin: 0.05,
                          end: 0,
                          delay: Duration(
                              milliseconds: 200 + (50 * index)),
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutCubic,
                        );
                  },
                  childCount: grouped.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWebLayout(
      BuildContext context, LichkhamProvider provider) {
    return Column(
      children: [
        _WebTopBar(provider: provider),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 256,
                child: _WebSidebar(provider: provider),
              ),
              VerticalDivider(width: 1, color: context.borderColor),
              Expanded(
                child: _WebContent(provider: provider),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WebTopBar extends StatelessWidget {
  final LichkhamProvider provider;
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
            child: const FaIcon(FontAwesomeIcons.calendarDays,
                size: 16, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Text(
            'Lịch khám bệnh',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: provider.refresh,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  FaIcon(FontAwesomeIcons.arrowsRotate,
                      size: 12, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                    'Làm mới',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WebSidebar extends StatelessWidget {
  final LichkhamProvider provider;
  const _WebSidebar({required this.provider});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    final Map<String, int> allRoomCounts = {};
    for (final s in provider.allSchedules) {
      if (s.isBetweenDates(provider.startDate, provider.endDate)) {
        allRoomCounts[s.tenPhongKham] =
            (allRoomCounts[s.tenPhongKham] ?? 0) + 1;
      }
    }
    final totalDateRange =
        allRoomCounts.values.fold(0, (a, b) => a + b);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          _SidebarCard(
            isDark: isDark,
            icon: FontAwesomeIcons.calendarDay,
            title: 'KHOẢNG THỜI GIAN',
            child: Column(
              children: [
                _FilterBtn(
                  label: 'Hôm nay',
                  isSelected: provider.selectedDateRange == 1,
                  onTap: () => context
                      .read<LichkhamProvider>()
                      .updateDateRange(1),
                ),
                const SizedBox(height: 6),
                _FilterBtn(
                  label: '7 ngày tới',
                  isSelected: provider.selectedDateRange == 7,
                  onTap: () => context
                      .read<LichkhamProvider>()
                      .updateDateRange(7),
                ),
                const SizedBox(height: 6),
                _FilterBtn(
                  label: 'Tùy chọn...',
                  isSelected: provider.selectedDateRange == 0,
                  onTap: () => context
                      .read<LichkhamProvider>()
                      .updateDateRange(0),
                ),
                if (provider.selectedDateRange == 0) ...[
                  const SizedBox(height: 10),
                  _WebDateField(
                    label: 'Từ ngày',
                    date: provider.startDate,
                    isDark: isDark,
                    onTap: () async {
                      final d =
                          await _pickDate(context, provider.startDate);
                      if (d != null && context.mounted) {
                        context
                            .read<LichkhamProvider>()
                            .setStartDate(d);
                      }
                    },
                  ),
                  const SizedBox(height: 6),
                  _WebDateField(
                    label: 'Đến ngày',
                    date: provider.endDate,
                    isDark: isDark,
                    onTap: () async {
                      final d =
                          await _pickDate(context, provider.endDate);
                      if (d != null && context.mounted) {
                        context
                            .read<LichkhamProvider>()
                            .setEndDate(d);
                      }
                    },
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),

          if (provider.rooms.isNotEmpty)
            _SidebarCard(
              isDark: isDark,
              icon: FontAwesomeIcons.doorOpen,
              title: 'PHÒNG KHÁM',
              child: Column(
                children: [
                  _RoomBtn(
                    label: 'Tất cả',
                    count: totalDateRange,
                    isSelected: provider.selectedRoom == 'all',
                    isDark: isDark,
                    onTap: () => context
                        .read<LichkhamProvider>()
                        .selectRoom('all'),
                  ),
                  ...provider.rooms.map(
                    (room) => Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: _RoomBtn(
                        label: room,
                        count: allRoomCounts[room] ?? 0,
                        isSelected: provider.selectedRoom == room,
                        isDark: isDark,
                        onTap: () => context
                            .read<LichkhamProvider>()
                            .selectRoom(room),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<DateTime?> _pickDate(
      BuildContext context, DateTime initial) {
    return showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2024),
      lastDate: DateTime(2027),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            onSurface: Color(0xFF1A1A1A),
          ),
        ),
        child: child!,
      ),
    );
  }
}

class _SidebarCard extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final String title;
  final Widget child;

  const _SidebarCard({
    required this.isDark,
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(icon, size: 11, color: AppColors.primary),
              const SizedBox(width: 7),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color:
                      isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _FilterBtn extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterBtn({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark
                  ? const Color(0xFF38383A)
                  : const Color(0xFFF5F5F5)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? Colors.white
                : (isDark
                    ? Colors.grey[300]
                    : const Color(0xFF1A1A1A)),
          ),
        ),
      ),
    );
  }
}

class _RoomBtn extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _RoomBtn({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.35)
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: isSelected
                      ? AppColors.primary
                      : (isDark
                          ? Colors.grey[300]
                          : const Color(0xFF1A1A1A)),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : (isDark
                        ? const Color(0xFF38383A)
                        : const Color(0xFFEEEEEE)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? AppColors.primary
                      : (isDark
                          ? Colors.grey[400]
                          : Colors.grey[600]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WebDateField extends StatelessWidget {
  final String label;
  final DateTime date;
  final bool isDark;
  final VoidCallback onTap;

  const _WebDateField({
    required this.label,
    required this.date,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF38383A)
              : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark
                ? const Color(0xFF48484A)
                : const Color(0xFFE0E0E0),
          ),
        ),
        child: Row(
          children: [
            const FaIcon(FontAwesomeIcons.calendar,
                size: 12, color: AppColors.primary),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark
                        ? Colors.grey[500]
                        : Colors.grey[600],
                  ),
                ),
                Text(
                  DateFormat('dd/MM/yyyy').format(date),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? Colors.white
                        : const Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
            const Spacer(),
            FaIcon(FontAwesomeIcons.chevronDown,
                size: 9,
                color:
                    isDark ? Colors.grey[500] : Colors.grey[500]),
          ],
        ),
      ),
    );
  }
}

class _WebContent extends StatelessWidget {
  final LichkhamProvider provider;
  const _WebContent({required this.provider});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final grouped = provider.getGroupedSchedules();
    final totalToday = provider.filteredSchedules
        .where((s) => s.isOnDate(DateTime.now()))
        .length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              _StatCard(
                label: 'Tổng lịch',
                value: '${provider.filteredSchedules.length}',
                icon: FontAwesomeIcons.calendarCheck,
                color: AppColors.primary,
                isDark: isDark,
              ),
              const SizedBox(width: 12),
              _StatCard(
                label: 'Phòng khám',
                value: '${grouped.length}',
                icon: FontAwesomeIcons.doorOpen,
                color: const Color(0xFF9C27B0),
                isDark: isDark,
              ),
              const SizedBox(width: 12),
              _StatCard(
                label: 'Hôm nay',
                value: '$totalToday',
                icon: FontAwesomeIcons.calendarDay,
                color: const Color(0xFF4CAF50),
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (grouped.isEmpty)
            _EmptyWeb(isDark: isDark)
          else
            ...grouped.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _WebRoomTable(
                  roomName: entry.key,
                  schedules: entry.value,
                  isDark: isDark,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: FaIcon(icon, size: 18, color: color),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: isDark
                        ? Colors.white
                        : const Color(0xFF1A1A1A),
                    height: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? Colors.grey[400]
                        : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WebRoomTable extends StatelessWidget {
  final String roomName;
  final List<LichkhamModel> schedules;
  final bool isDark;

  const _WebRoomTable({
    required this.roomName,
    required this.schedules,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
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
        children: [

          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        AppColors.primaryDark.withValues(alpha: 0.25),
                        AppColors.primaryLight.withValues(alpha: 0.1),
                      ]
                    : [
                        AppColors.primary.withValues(alpha: 0.08),
                        AppColors.primaryLight.withValues(alpha: 0.03),
                      ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              AppColors.primaryDark,
                              AppColors.primaryLight
                            ]
                          : AppColors.primaryGradient,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: FaIcon(FontAwesomeIcons.doorOpen,
                        size: 15, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    roomName,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? Colors.white
                          : const Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${schedules.length} lịch',
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

          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
            color: isDark
                ? const Color(0xFF38383A).withValues(alpha: 0.5)
                : const Color(0xFFF9FAFB),
            child: Row(
              children: [
                SizedBox(
                    width: 76,
                    child: Text('Ngày', style: _th(isDark))),
                SizedBox(
                    width: 100,
                    child: Text('Buổi', style: _th(isDark))),
                Expanded(
                    child: Text('Bác sĩ', style: _th(isDark))),
                Expanded(
                    child:
                        Text('Điều dưỡng', style: _th(isDark))),
                const SizedBox(width: 88),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isDark
                ? const Color(0xFF38383A)
                : Colors.grey[200],
          ),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: schedules.length,
            separatorBuilder: (_, _) => Divider(
              height: 1,
              color: isDark
                  ? const Color(0xFF38383A)
                  : Colors.grey[100],
            ),
            itemBuilder: (_, index) => _WebRow(
              schedule: schedules[index],
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _th(bool isDark) => TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4,
        color: isDark ? Colors.grey[500] : Colors.grey[500],
      );
}

class _WebRow extends StatelessWidget {
  final LichkhamModel schedule;
  final bool isDark;

  const _WebRow({required this.schedule, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isToday = schedule.isOnDate(DateTime.now());
    final isMorning = schedule.isMorning;
    const weekDays = ['', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    final weekDay = weekDays[schedule.ngay.weekday];
    final shiftColor =
        isMorning ? const Color(0xFF2196F3) : const Color(0xFF9C27B0);

    return Container(
      color: isToday
          ? AppColors.primary.withValues(alpha: 0.04)
          : Colors.transparent,
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      child: Row(
        children: [

          SizedBox(
            width: 76,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isToday
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('dd').format(schedule.ngay),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: isToday ? Colors.white : AppColors.primary,
                      height: 1,
                    ),
                  ),
                  Text(
                    weekDay,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: isToday
                          ? Colors.white.withValues(alpha: 0.85)
                          : AppColors.primary.withValues(alpha: 0.65),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(
            width: 100,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: shiftColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(
                    isMorning
                        ? FontAwesomeIcons.cloudSun
                        : FontAwesomeIcons.moon,
                    size: 10,
                    color: shiftColor,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    isMorning ? 'Sáng' : 'Chiều',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: shiftColor,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: schedule.hasDoctor
                ? Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.userDoctor,
                          size: 11, color: Color(0xFF1565C0)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          schedule.doctorName,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? Colors.grey[200]
                                : const Color(0xFF1A1A1A),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                : Text(
                    '—',
                    style: TextStyle(
                      color: isDark
                          ? Colors.grey[600]
                          : Colors.grey[400],
                    ),
                  ),
          ),

          Expanded(
            child: schedule.hasNurse
                ? Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.userNurse,
                          size: 11, color: Color(0xFF1565C0)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          schedule.nurseName,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? Colors.grey[200]
                                : const Color(0xFF1A1A1A),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                : Text(
                    '—',
                    style: TextStyle(
                      color: isDark
                          ? Colors.grey[600]
                          : Colors.grey[400],
                    ),
                  ),
          ),

          SizedBox(
            width: 88,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isToday)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color:
                          AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Hôm nay',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  )
                else if (schedule.hasNote)
                  Tooltip(
                    message: schedule.ghiChu!,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.circleExclamation,
                        size: 12,
                        color: Color(0xFFF59E0B),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyWeb extends StatelessWidget {
  final bool isDark;
  const _EmptyWeb({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 64),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          FaIcon(
            FontAwesomeIcons.calendarXmark,
            size: 40,
            color: AppColors.textSecondary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Không có lịch khám',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Thử chọn khoảng thời gian khác',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.grey[600] : Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}
