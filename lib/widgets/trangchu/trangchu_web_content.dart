import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/xacthuc_provider.dart';
import 'vanban_thongbao_card.dart';
import 'meal_registration_card.dart';
import 'chamcong_today_card.dart';
import 'facebook_post_card.dart';

class TrangchuWebContent extends StatelessWidget {
  const TrangchuWebContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Welcome banner ────────────────────────────────────────────
          const _WelcomeBanner()
              .animate()
              .fadeIn(duration: 450.ms)
              .slideY(begin: -0.08, end: 0, curve: Curves.easeOutCubic),

          const SizedBox(height: 20),

          // ── Quick actions row ─────────────────────────────────────────
          const _QuickActionsRow()
              .animate()
              .fadeIn(delay: 100.ms, duration: 400.ms)
              .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),

          const SizedBox(height: 20),

          // ── Main 2-column grid ─────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: chấm công + facebook
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    const ChamcongTodayCard()
                        .animate()
                        .fadeIn(delay: 150.ms, duration: 400.ms)
                        .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
                    const SizedBox(height: 16),
                    const FacebookPostCard()
                        .animate()
                        .fadeIn(delay: 350.ms, duration: 400.ms)
                        .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // Right: đăng ký cơm + văn bản
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    const MealRegistrationCard()
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 400.ms)
                        .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
                    const SizedBox(height: 16),
                    const VanbanThongbaoCard()
                        .animate()
                        .fadeIn(delay: 280.ms, duration: 400.ms)
                        .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Welcome Banner ────────────────────────────────────────────────────────────

class _WelcomeBanner extends StatefulWidget {
  const _WelcomeBanner();

  @override
  State<_WelcomeBanner> createState() => _WelcomeBannerState();
}

class _WelcomeBannerState extends State<_WelcomeBanner> {
  late Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _greeting {
    final h = _now.hour;
    if (h < 12) return 'Chào buổi sáng';
    if (h < 18) return 'Chào buổi chiều';
    return 'Chào buổi tối';
  }

  String get _dayName {
    const days = ['Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy', 'Chủ Nhật'];
    return days[_now.weekday - 1];
  }

  String get _dateStr =>
      '${_now.day.toString().padLeft(2, '0')}/'
      '${_now.month.toString().padLeft(2, '0')}/'
      '${_now.year}';

  String get _timeStr =>
      '${_now.hour.toString().padLeft(2, '0')}:'
      '${_now.minute.toString().padLeft(2, '0')}:'
      '${_now.second.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final user = context.read<XacthucProvider>().user;
    final isDark = context.isDark;

    final name = user?.hoVaTen ?? 'bạn';
    final sub = (user?.chucVu != null && user?.phongBan != null)
        ? '${user!.chucVu} • ${user.phongBan}'
        : 'Chúc bạn một ngày làm việc hiệu quả!';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0D3070), Color(0xFF1251A3)],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1565C0), Color(0xFF1976D2), Color(0xFF2196F3)],
              ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withValues(alpha: isDark ? 0.4 : 0.25),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.18),
              border:
                  Border.all(color: Colors.white.withValues(alpha: 0.45), width: 2),
            ),
            child: user?.hinhAnh != null
                ? ClipOval(
                    child: Image.network(
                      user!.hinhAnh!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          const Icon(Icons.person_rounded, color: Colors.white, size: 28),
                    ),
                  )
                : const Icon(Icons.person_rounded, color: Colors.white, size: 28),
          ),

          const SizedBox(width: 16),

          // Greeting text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$_greeting, $name!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  sub,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.80),
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Clock + date
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _timeStr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$_dayName, $_dateStr',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.80),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Quick Actions Row ─────────────────────────────────────────────────────────

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _QuickCard(
          icon: Icons.access_time_rounded,
          label: 'Chấm công',
          color: const Color(0xFF1976D2),
          onTap: () => context.read<NavigationProvider>().setIndex(3),
        ),
        const SizedBox(width: 12),
        _QuickCard(
          icon: Icons.description_outlined,
          label: 'Văn bản',
          color: const Color(0xFF7C3AED),
          onTap: () => context.read<NavigationProvider>().setIndex(1),
        ),
        const SizedBox(width: 12),
        _QuickCard(
          icon: Icons.payments_outlined,
          label: 'Bảng lương',
          color: const Color(0xFF059669),
          onTap: () => context.read<NavigationProvider>().setWebCurrentPage('luong'),
        ),
        const SizedBox(width: 12),
        _QuickCard(
          icon: Icons.notifications_outlined,
          label: 'Thông báo',
          color: const Color(0xFFD97706),
          onTap: () => context.read<NavigationProvider>().setWebCurrentPage('thongbao'),
        ),
        const SizedBox(width: 12),
        _QuickCard(
          icon: Icons.calendar_month_outlined,
          label: 'Lịch trực',
          color: const Color(0xFF0891B2),
          onTap: () => context.read<NavigationProvider>().setWebCurrentPage('lichtruc'),
        ),
        const SizedBox(width: 12),
        _QuickCard(
          icon: Icons.school_outlined,
          label: 'Đào tạo',
          color: const Color(0xFFDB2777),
          onTap: () => context.read<NavigationProvider>().setWebCurrentPage('daotao'),
        ),
      ],
    );
  }
}

class _QuickCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_QuickCard> createState() => _QuickCardState();
}

class _QuickCardState extends State<_QuickCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: _hovered
                  ? widget.color.withValues(alpha: 0.12)
                  : context.cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _hovered
                    ? widget.color.withValues(alpha: 0.40)
                    : context.borderColor,
                width: 1,
              ),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withValues(alpha: 0.12),
                  ),
                  child: Icon(widget.icon, color: widget.color, size: 20),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
