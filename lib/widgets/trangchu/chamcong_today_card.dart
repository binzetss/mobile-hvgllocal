import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../providers/chamcong_provider.dart';
import '../../data/models/chamcong_model.dart';

class ChamcongTodayCard extends StatefulWidget {
  const ChamcongTodayCard({super.key});

  @override
  State<ChamcongTodayCard> createState() => _ChamcongTodayCardState();
}

class _ChamcongTodayCardState extends State<ChamcongTodayCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _controller;
  late Animation<double> _expandAnim;
  late Animation<double> _chevronAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _expandAnim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _chevronAnim = Tween<double>(begin: 0, end: 0.5).animate(_expandAnim);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChamcongProvider>(
      builder: (context, provider, _) {
        final todayAttendance = provider.todayAttendance;
        final punches = todayAttendance?.punches ?? [];

        // Ẩn hoàn toàn nếu hôm nay chưa chấm
        if (punches.isEmpty) return const SizedBox.shrink();

        final groups = _groupByLoai(punches);
        final isDark = context.isDark;

        return GestureDetector(
          onTap: _toggle,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: context.borderColor.withValues(alpha: isDark ? 1.0 : 0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: isDark ? 0.0 : 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // ── Header ──────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      // Icon
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: AppColors.primaryGradient,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.fingerprint,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Title + date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Chấm công hôm nay',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  size: 12,
                                  color: context.textSecondary.withValues(alpha: 0.7),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  DateFormat('dd/MM/yyyy').format(DateTime.now()),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: context.textSecondary.withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Badge tổng
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.success.withValues(alpha: 0.25),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${punches.length}',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: AppColors.success,
                                height: 1,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              'lần',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.success.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Chevron
                      RotationTransition(
                        turns: _chevronAnim,
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 22,
                          color: context.textSecondary.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Collapsed: mỗi loại 1 dòng, chỉ giờ cuối ───────
                _buildCollapsedSummary(context, groups),

                // ── Expanded: toàn bộ punches gom nhóm ─────────────
                SizeTransition(
                  sizeFactor: _expandAnim,
                  child: Column(
                    children: [
                      // Divider trước expanded
                      Container(
                        height: 1,
                        margin: const EdgeInsets.symmetric(horizontal: 14),
                        color: context.borderColor.withValues(alpha: isDark ? 0.5 : 0.2),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                        child: Column(
                          children: groups.entries.toList().asMap().entries.map((e) {
                            final idx = e.key;
                            final entry = e.value;
                            return Column(
                              children: [
                                if (idx > 0) const SizedBox(height: 10),
                                _buildGroupSection(context, entry.key, entry.value),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Tóm tắt thu gọn: 1 dòng/loại, hiện giờ chấm cuối ──────────────
  Widget _buildCollapsedSummary(
    BuildContext context,
    Map<String, List<ChamcongPunch>> groups,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: Column(
        children: groups.entries.toList().asMap().entries.map((e) {
          final idx = e.key;
          final entry = e.value;
          final loai = entry.key;
          final items = entry.value;
          final lastPunch = items.last;
          final color = _punchColor(loai);
          final icon = _punchIcon(loai);

          return Column(
            children: [
              if (idx > 0) const SizedBox(height: 8),
              Row(
                children: [
                  // Icon loại
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(child: Icon(icon, size: 14, color: color)),
                  ),
                  const SizedBox(width: 10),
                  // Tên loại
                  Expanded(
                    child: Text(
                      loai,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: context.textPrimary.withValues(alpha: 0.85),
                      ),
                    ),
                  ),
                  // Badge số lần (nếu > 1)
                  if (items.length > 1) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${items.length}x',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  // Giờ chấm cuối
                  Text(
                    DateFormat('HH:mm').format(lastPunch.time),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: color,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ── Nhóm loại đầy đủ (trong expanded) ──────────────────────────────
  Widget _buildGroupSection(
    BuildContext context,
    String loai,
    List<ChamcongPunch> items,
  ) {
    final color = _punchColor(loai);
    final icon = _punchIcon(loai);

    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: color.withValues(alpha: 0.22), width: 1),
      ),
      child: Column(
        children: [
          // Header nhóm
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withValues(alpha: 0.75)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(child: Icon(icon, size: 14, color: Colors.white)),
                ),
                const SizedBox(width: 9),
                Text(
                  loai,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    '${items.length} lần',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, indent: 12, endIndent: 12,
              color: color.withValues(alpha: 0.12)),
          // Chips giờ
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
            child: Wrap(
              spacing: 7,
              runSpacing: 7,
              children: items.map((p) => _timeChip(context, p.time, color)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeChip(BuildContext context, DateTime time, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: color.withValues(alpha: 0.28), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.access_time_rounded, size: 12, color: color.withValues(alpha: 0.7)),
          const SizedBox(width: 4),
          Text(
            DateFormat('HH:mm').format(time),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, List<ChamcongPunch>> _groupByLoai(List<ChamcongPunch> punches) {
    final map = <String, List<ChamcongPunch>>{};
    for (final p in punches) {
      map.putIfAbsent(p.loaiChamCong, () => []).add(p);
    }
    return map;
  }

  static Color _punchColor(String loai) {
    switch (loai) {
      case 'Chấm cơm':
        return const Color(0xFFFF9800);
      case 'Chấm đào tạo':
        return const Color(0xFF673AB7);
      case 'Chấm thư viện':
        return const Color(0xFF009688);
      default:
        return AppColors.primary;
    }
  }

  static IconData _punchIcon(String loai) {
    switch (loai) {
      case 'Chấm cơm':
        return Icons.restaurant_rounded;
      case 'Chấm đào tạo':
        return Icons.school_rounded;
      case 'Chấm thư viện':
        return Icons.menu_book_rounded;
      default:
        return Icons.fingerprint_rounded;
    }
  }
}
