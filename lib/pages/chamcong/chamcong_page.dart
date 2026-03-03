import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../providers/chamcong_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../widgets/chamcong/chamcong_calendar.dart';
import '../../widgets/chamcong/chamcong_web_calendar.dart';
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
  static const int _chamcongTabIndex = 3;
  NavigationProvider? _navProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ChamcongProvider>().init();
      _navProvider = context.read<NavigationProvider>()
        ..addListener(_onTabChanged);
    });
  }

  void _onTabChanged() {
    if (!mounted) return;
    if (_navProvider?.currentIndex == _chamcongTabIndex) {
      context.read<ChamcongProvider>().refresh();
    }
  }

  @override
  void dispose() {
    _navProvider?.removeListener(_onTabChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = kIsWeb && MediaQuery.of(context).size.width >= 768;
    return Scaffold(
      backgroundColor: isDesktop ? Colors.transparent : context.bgColor,
      body: Consumer<ChamcongProvider>(
        builder: (context, provider, child) {
          if (isDesktop) return _buildDesktopLayout(context, provider);
          return _buildMobileLayout(context, provider);
        },
      ),
    );
  }

  // ── Mobile layout ──────────────────────────────────────────────────────────

  Widget _buildMobileLayout(BuildContext context, ChamcongProvider provider) {
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
                    context: context,
                    icon: FontAwesomeIcons.plus,
                    label: 'Bổ sung công',
                    onTap: _navigateToSupplementaryAttendance,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    context: context,
                    icon: FontAwesomeIcons.listCheck,
                    label: 'Danh sách công bổ sung',
                    onTap: _navigateToSupplementaryList,
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
              onDateSelected: provider.selectDate,
              onMonthChanged: provider.changeMonth,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: ChamcongHistoryCard(
              attendance: provider.getAttendanceByDate(provider.selectedDate),
              selectedDate: provider.selectedDate,
            ),
          ),
        ),
      ],
    );
  }

  // ── Desktop full-calendar layout ──────────────────────────────────────────

  Widget _buildDesktopLayout(BuildContext context, ChamcongProvider provider) {
    final isEmpty = provider.monthlyAttendances.isEmpty;

    // Loading (lần đầu tải)
    if (provider.isLoading && isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Mọi trường hợp data rỗng: hiển thị lỗi hoặc thông báo + nút Tải lại
    if (isEmpty) {
      final msg = provider.error ?? 'Chưa tải được dữ liệu. Hãy nhấn Tải lại.';
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              provider.error != null ? Icons.error_outline : Icons.cloud_off_rounded,
              size: 48,
              color: provider.error != null
                  ? Colors.red
                  : context.textSecondary.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                msg,
                style: TextStyle(color: context.textSecondary, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => context.read<ChamcongProvider>().init(),
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Tải lại'),
            ),
          ],
        ),
      );
    }

    return ChamcongWebCalendar(
      currentMonth: provider.selectedDate,
      selectedDate: provider.selectedDate,
      attendances: provider.monthlyAttendances,
      onDateSelected: provider.selectDate,
      onMonthChanged: provider.changeMonth,
      onBosungCong: _navigateToSupplementaryAttendance,
      onDanhSach: _navigateToSupplementaryList,
    );
  }

  // ── Shared ─────────────────────────────────────────────────────────────────

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: context.cardColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.borderColor, width: 0.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(icon, size: 16, color: context.primaryColor),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
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
    final isDesktop = kIsWeb && MediaQuery.of(context).size.width >= 768;
    if (isDesktop) {
      context.read<NavigationProvider>().setWebCurrentPage('bosungcong');
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BosungcongPage()),
    );
  }

  void _navigateToSupplementaryList() {
    final isDesktop = kIsWeb && MediaQuery.of(context).size.width >= 768;
    if (isDesktop) {
      context.read<NavigationProvider>().setWebCurrentPage('danhsach_bosungcong');
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DanhsachBosungcongPage()),
    );
  }
}
