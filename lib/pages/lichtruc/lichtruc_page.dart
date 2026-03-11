import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../providers/lichtruc_provider.dart';
import '../../widgets/lichtruc/lichtruc_calendar.dart';
import '../../widgets/lichtruc/lichtruc_my_shift_card.dart';
import '../../widgets/lichtruc/lichtruc_day_navigator.dart';
import '../../widgets/lichtruc/lichtruc_dept_section.dart';

// ─── Page ─────────────────────────────────────────────────────────────────────

class LichtructPage extends StatefulWidget {
  const LichtructPage({super.key});

  @override
  State<LichtructPage> createState() => _LichtructPageState();
}

class _LichtructPageState extends State<LichtructPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = kIsWeb && MediaQuery.of(context).size.width >= 768;

    return ChangeNotifierProvider(
      create: (_) => LichtructProvider()..init(),
      child: Consumer<LichtructProvider>(
        builder: (context, provider, _) {
          if (isDesktop) return _buildWebLayout(context, provider);
          return _buildMobileLayout(context, provider);
        },
      ),
    );
  }

  // ── Mobile ──────────────────────────────────────────────────────────────────

  Widget _buildMobileLayout(BuildContext context, LichtructProvider provider) {
    final isDark = context.isDark;
    final bgColor = isDark ? Colors.black : AppColors.primary;

    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Lịch Trực',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withValues(alpha: 0.55),
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle:
              const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          unselectedLabelStyle:
              const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          tabs: const [
            Tab(text: 'Lịch trực của tôi'),
            Tab(text: 'Lịch trực toàn viện'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _MyScheduleTab(provider: provider),
          _AllScheduleTab(provider: provider),
        ],
      ),
    );
  }

  // ── Web ─────────────────────────────────────────────────────────────────────

  Widget _buildWebLayout(BuildContext context, LichtructProvider provider) {
    final isDark = context.isDark;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Top bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            decoration: BoxDecoration(
              color: context.cardColor.withValues(alpha: isDark ? 0.6 : 0.85),
              border: Border(
                bottom: BorderSide(
                    color: context.borderColor.withValues(alpha: 0.4)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: FaIcon(FontAwesomeIcons.calendarCheck,
                      size: 14, color: context.primaryColor),
                ),
                const SizedBox(width: 12),
                Text(
                  'Lịch trực',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: context.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const Spacer(),
                // Tabs as pill buttons
                _WebTabBar(tabController: _tabController),
              ],
            ),
          ),
          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _MyScheduleTabWeb(provider: provider),
                _AllScheduleTabWeb(provider: provider),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Web Tab Bar ──────────────────────────────────────────────────────────────

class _WebTabBar extends StatefulWidget {
  final TabController tabController;
  const _WebTabBar({required this.tabController});

  @override
  State<_WebTabBar> createState() => _WebTabBarState();
}

class _WebTabBarState extends State<_WebTabBar> {
  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(_onTabChange);
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_onTabChange);
    super.dispose();
  }

  void _onTabChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: context.borderColor.withValues(alpha: isDark ? 1.0 : 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _WebTabPill(
            label: 'Lịch trực của tôi',
            isSelected: widget.tabController.index == 0,
            onTap: () => widget.tabController.animateTo(0),
          ),
          const SizedBox(width: 2),
          _WebTabPill(
            label: 'Lịch trực toàn viện',
            isSelected: widget.tabController.index == 1,
            onTap: () => widget.tabController.animateTo(1),
          ),
        ],
      ),
    );
  }
}

class _WebTabPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _WebTabPill(
      {required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? context.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : context.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ─── Web Tab 0: Lịch trực của tôi ────────────────────────────────────────────

class _MyScheduleTabWeb extends StatelessWidget {
  final LichtructProvider provider;
  const _MyScheduleTabWeb({required this.provider});

  @override
  Widget build(BuildContext context) {
    if (provider.isLoadingMy) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.errorMy != null) {
      return _ErrorState(
          message: provider.errorMy!, onRetry: provider.fetchMySchedule);
    }

    final schedules = provider.getMyMonthSchedules();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: calendar
          SizedBox(
            width: 420,
            child: Column(
              children: [
                _MonthSelector(
                  monthText: provider.getMonthYearText(),
                  onPrev: provider.previousMonth,
                  onNext: provider.nextMonth,
                ),
                const SizedBox(height: 16),
                LichtructCalendar(
                  currentMonth: provider.currentMonth,
                  allSchedules: schedules,
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          // Right: shift list
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Ca trực trong tháng',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: context.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    if (schedules.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${schedules.length} ca',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                if (schedules.isEmpty)
                  _EmptyState(
                      message:
                          'Không có ca trực trong ${provider.getMonthYearText()}')
                else
                  ...schedules.map((s) => LichtructMyShiftCard(s: s)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Web Tab 1: Lịch trực toàn viện ──────────────────────────────────────────

class _AllScheduleTabWeb extends StatelessWidget {
  final LichtructProvider provider;
  const _AllScheduleTabWeb({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: LichtructDayNavigator(provider: provider),
        ),
        Expanded(
          child: provider.isLoadingAll
              ? const Center(child: CircularProgressIndicator())
              : provider.errorAll != null
                  ? _ErrorState(
                      message: provider.errorAll!,
                      onRetry: provider.fetchAllSchedule)
                  : _AllBodyWeb(provider: provider),
        ),
      ],
    );
  }
}

class _AllBodyWeb extends StatelessWidget {
  final LichtructProvider provider;
  const _AllBodyWeb({required this.provider});

  @override
  Widget build(BuildContext context) {
    final grouped = provider.getGroupedByDeptForDay();

    if (grouped.isEmpty) {
      return _EmptyState(
        message: provider.searchKhoa.isNotEmpty
            ? 'Không tìm thấy khoa phòng\n"${provider.searchKhoa}"'
            : 'Không có dữ liệu lịch trực\n${provider.getSelectedDateText()}',
      );
    }

    final keys = grouped.keys.toList();
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(28, 8, 28, 32),
      itemCount: keys.length,
      itemBuilder: (context, i) => LichtructDeptSection(
        deptName: keys[i],
        items: grouped[keys[i]]!,
      ),
    );
  }
}

// ─── Shared helpers ───────────────────────────────────────────────────────────

class _MonthSelector extends StatelessWidget {
  final String monthText;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  const _MonthSelector(
      {required this.monthText, required this.onPrev, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _NavBtn(icon: FontAwesomeIcons.chevronLeft, onTap: onPrev),
        SizedBox(
          width: 172,
          child: Center(
            child: Text(
              monthText,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: context.textPrimary,
              ),
            ),
          ),
        ),
        _NavBtn(icon: FontAwesomeIcons.chevronRight, onTap: onNext),
      ],
    );
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: FaIcon(icon, size: 12, color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          children: [
            FaIcon(FontAwesomeIcons.calendarXmark,
                size: 36,
                color: AppColors.textSecondary.withValues(alpha: 0.35)),
            const SizedBox(height: 10),
            Text(
              message,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(FontAwesomeIcons.triangleExclamation,
                size: 36, color: Colors.red.withValues(alpha: 0.55)),
            const SizedBox(height: 12),
            Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary.withValues(alpha: 0.8))),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const FaIcon(FontAwesomeIcons.rotateRight, size: 13),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Mobile Tab 0: Lịch trực của tôi ─────────────────────────────────────────

class _MyScheduleTab extends StatelessWidget {
  final LichtructProvider provider;
  const _MyScheduleTab({required this.provider});

  @override
  Widget build(BuildContext context) {
    if (provider.isLoadingMy) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.errorMy != null) {
      return _ErrorState(
          message: provider.errorMy!, onRetry: provider.fetchMySchedule);
    }

    final schedules = provider.getMyMonthSchedules();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MonthSelector(
            monthText: provider.getMonthYearText(),
            onPrev: provider.previousMonth,
            onNext: provider.nextMonth,
          ),
          const SizedBox(height: 16),
          LichtructCalendar(
            currentMonth: provider.currentMonth,
            allSchedules: schedules,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                'Ca trực trong tháng',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: context.textPrimary,
                ),
              ),
              const Spacer(),
              if (schedules.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${schedules.length} ca',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          if (schedules.isEmpty)
            _EmptyState(
                message:
                    'Không có ca trực trong ${provider.getMonthYearText()}')
          else
            ...schedules.map((s) => LichtructMyShiftCard(s: s)),
        ],
      ),
    );
  }
}

// ─── Mobile Tab 1: Lịch trực toàn viện ───────────────────────────────────────

class _AllScheduleTab extends StatelessWidget {
  final LichtructProvider provider;
  const _AllScheduleTab({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LichtructDayNavigator(provider: provider),
        Expanded(
          child: provider.isLoadingAll
              ? const Center(child: CircularProgressIndicator())
              : provider.errorAll != null
                  ? _ErrorState(
                      message: provider.errorAll!,
                      onRetry: provider.fetchAllSchedule)
                  : _AllBody(provider: provider),
        ),
      ],
    );
  }
}

class _AllBody extends StatelessWidget {
  final LichtructProvider provider;
  const _AllBody({required this.provider});

  @override
  Widget build(BuildContext context) {
    final grouped = provider.getGroupedByDeptForDay();

    if (grouped.isEmpty) {
      return _EmptyState(
        message: provider.searchKhoa.isNotEmpty
            ? 'Không tìm thấy khoa phòng\n"${provider.searchKhoa}"'
            : 'Không có dữ liệu lịch trực\n${provider.getSelectedDateText()}',
      );
    }

    final keys = grouped.keys.toList();
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      itemCount: keys.length,
      itemBuilder: (context, i) => LichtructDeptSection(
        deptName: keys[i],
        items: grouped[keys[i]]!,
      ),
    );
  }
}
