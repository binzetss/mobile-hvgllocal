import 'package:flutter/material.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../data/models/chamcong_model.dart';
import 'chamcong_history_card.dart';

// ── Event data ────────────────────────────────────────────────────────────────

class _Event {
  final String time;
  final String label;
  final Color color;
  final DateTime sortTime;

  const _Event({
    required this.time,
    required this.label,
    required this.color,
    required this.sortTime,
  });
}

// ── Main widget ───────────────────────────────────────────────────────────────

class ChamcongWebCalendar extends StatefulWidget {
  final DateTime currentMonth;
  final DateTime selectedDate;
  final List<ChamcongModel> attendances;
  final Function(DateTime) onDateSelected;
  final Function(int year, int month) onMonthChanged;
  final VoidCallback? onBosungCong;
  final VoidCallback? onDanhSach;

  const ChamcongWebCalendar({
    super.key,
    required this.currentMonth,
    required this.selectedDate,
    required this.attendances,
    required this.onDateSelected,
    required this.onMonthChanged,
    this.onBosungCong,
    this.onDanhSach,
  });

  @override
  State<ChamcongWebCalendar> createState() => _ChamcongWebCalendarState();
}

class _ChamcongWebCalendarState extends State<ChamcongWebCalendar> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth =
        DateTime(widget.currentMonth.year, widget.currentMonth.month);
  }

  @override
  void didUpdateWidget(covariant ChamcongWebCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentMonth.year != widget.currentMonth.year ||
        oldWidget.currentMonth.month != widget.currentMonth.month) {
      setState(() {
        _currentMonth =
            DateTime(widget.currentMonth.year, widget.currentMonth.month);
      });
    }
  }

  // ── Navigation ──────────────────────────────────────────────────────────────

  void _prevMonth() {
    final m = DateTime(_currentMonth.year, _currentMonth.month - 1);
    setState(() => _currentMonth = m);
    widget.onMonthChanged(m.year, m.month);
  }

  void _nextMonth() {
    final m = DateTime(_currentMonth.year, _currentMonth.month + 1);
    setState(() => _currentMonth = m);
    widget.onMonthChanged(m.year, m.month);
  }

  void _goToday() {
    final now = DateTime.now();
    final m = DateTime(now.year, now.month);
    setState(() => _currentMonth = m);
    widget.onMonthChanged(m.year, m.month);
    widget.onDateSelected(now);
  }

  // ── Week grid builder ────────────────────────────────────────────────────────

  List<List<DateTime?>> _buildWeeks() {
    final daysInMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final startOffset = firstDay.weekday % 7; // 0=Sun … 6=Sat

    final allDays = <DateTime?>[];
    for (int i = 0; i < startOffset; i++) { allDays.add(null); }
    for (int d = 1; d <= daysInMonth; d++) {
      allDays.add(DateTime(_currentMonth.year, _currentMonth.month, d));
    }
    while (allDays.length % 7 != 0) { allDays.add(null); }

    final weeks = <List<DateTime?>>[];
    for (int i = 0; i < allDays.length; i += 7) {
      weeks.add(allDays.sublist(i, i + 7));
    }
    return weeks;
  }

  // ── Event helpers ────────────────────────────────────────────────────────────

  List<_Event> _getEvents(DateTime date) {
    ChamcongModel? a;
    try {
      a = widget.attendances.firstWhere(
        (x) =>
            x.date.year == date.year &&
            x.date.month == date.month &&
            x.date.day == date.day,
      );
    } catch (_) {
      return [];
    }
    if (a.id.isEmpty || a.punches.isEmpty) return [];

    String fmt(DateTime t) =>
        '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

    Color colorFor(String loai) {
      switch (loai) {
        case 'Chấm cơm':
          return const Color(0xFF22C55E); // green
        case 'Chấm thư viện':
          return const Color(0xFF8B5CF6); // purple
        case 'Chấm đào tạo':
          return const Color(0xFFF97316); // orange
        default:
          return const Color(0xFF1877F2); // blue (Chấm công)
      }
    }

    // punches already sorted ascending by service
    return a.punches
        .map((p) => _Event(
              time: fmt(p.time),
              label: p.loaiChamCong,
              color: colorFor(p.loaiChamCong),
              sortTime: p.time,
            ))
        .toList();
  }

  Color _statusColor(ChamcongModel a) {
    switch (a.status) {
      case ChamcongStatus.present:
        return const Color(0xFF22C55E);
      case ChamcongStatus.late:
        return const Color(0xFFF97316);
      case ChamcongStatus.absent:
        return const Color(0xFFEF4444);
      case ChamcongStatus.earlyLeave:
        return const Color(0xFFEAB308);
      case ChamcongStatus.holiday:
        return const Color(0xFF3B82F6);
      case ChamcongStatus.weekend:
        return Colors.transparent;
    }
  }

  bool _isToday(DateTime d) {
    final n = DateTime.now();
    return d.year == n.year && d.month == n.month && d.day == n.day;
  }

  // ── Day detail popup ─────────────────────────────────────────────────────────

  void _showDetail(BuildContext context, DateTime date) {
    widget.onDateSelected(date);
    ChamcongModel? att;
    try {
      att = widget.attendances.firstWhere(
        (x) =>
            x.date.year == date.year &&
            x.date.month == date.month &&
            x.date.day == date.day,
      );
    } catch (_) {}

    if (att == null || att.id.isEmpty) return;

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InkWell(
                onTap: () => Navigator.pop(ctx),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ),
              ChamcongHistoryCard(attendance: att, selectedDate: date),
            ],
          ),
        ),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final weeks = _buildWeeks();

    return Column(
      children: [
        _TopBar(
          currentMonth: _currentMonth,
          isDark: isDark,
          onPrev: _prevMonth,
          onNext: _nextMonth,
          onToday: _goToday,
          onBosungCong: widget.onBosungCong,
          onDanhSach: widget.onDanhSach,
        ),
        _WeekdayHeader(isDark: isDark),
        Expanded(
          child: Column(
            children: weeks.asMap().entries.map((entry) {
              final weekIndex = entry.key;
              final isLastRow = weekIndex == weeks.length - 1;
              return Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: entry.value.asMap().entries.map((e) {
                    final col = e.key;
                    return Expanded(
                      child: _DayCell(
                        date: e.value,
                        col: col,
                        isLastCol: col == 6,
                        isLastRow: isLastRow,
                        events: e.value != null ? _getEvents(e.value!) : [],
                        attendance: e.value != null
                            ? () {
                                try {
                                  return widget.attendances.firstWhere(
                                    (a) =>
                                        a.date.year == e.value!.year &&
                                        a.date.month == e.value!.month &&
                                        a.date.day == e.value!.day,
                                  );
                                } catch (_) {
                                  return null;
                                }
                              }()
                            : null,
                        statusColor: null,
                        isToday: e.value != null && _isToday(e.value!),
                        isDark: isDark,
                        onTap: e.value != null
                            ? () => _showDetail(context, e.value!)
                            : null,
                        getStatusColor: (a) => _statusColor(a),
                      ),
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ── Top bar ───────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final DateTime currentMonth;
  final bool isDark;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onToday;
  final VoidCallback? onBosungCong;
  final VoidCallback? onDanhSach;

  const _TopBar({
    required this.currentMonth,
    required this.isDark,
    required this.onPrev,
    required this.onNext,
    required this.onToday,
    this.onBosungCong,
    this.onDanhSach,
  });

  @override
  Widget build(BuildContext context) {
    final mm = currentMonth.month.toString().padLeft(2, '0');
    final yyyy = currentMonth.year;

    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: context.cardColor,
        border: Border(
          bottom: BorderSide(color: context.borderColor.withValues(alpha: 0.5)),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // ← Navigation buttons
          _NavBtn(label: 'Tháng trước', icon: Icons.chevron_left_rounded, iconFirst: true, onTap: onPrev),
          const SizedBox(width: 4),
          _NavBtn(label: 'Tháng kế', icon: Icons.chevron_right_rounded, iconFirst: false, onTap: onNext),
          const SizedBox(width: 8),
          _NavBtn(label: 'Hôm nay', onTap: onToday),
          const Spacer(),
          // ── Month/year display
          Text(
            '$mm/$yyyy',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
              color: context.textPrimary,
            ),
          ),
          const Spacer(),
          // → Action buttons
          if (onBosungCong != null)
            _ActionBtn(
              icon: Icons.add_rounded,
              label: 'Bổ sung công',
              onTap: onBosungCong!,
            ),
          if (onDanhSach != null) ...[
            const SizedBox(width: 8),
            _ActionBtn(
              icon: Icons.list_alt_rounded,
              label: 'Danh sách',
              onTap: onDanhSach!,
              outlined: true,
            ),
          ],
        ],
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool iconFirst;
  final VoidCallback onTap;

  const _NavBtn({
    required this.label,
    this.icon,
    this.iconFirst = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = icon == null
        ? [Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textPrimary))]
        : iconFirst
            ? [
                Icon(icon, size: 14, color: context.textPrimary),
                const SizedBox(width: 2),
                Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textPrimary)),
              ]
            : [
                Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textPrimary)),
                const SizedBox(width: 2),
                Icon(icon, size: 14, color: context.textPrimary),
              ];

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(7),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: context.borderColor.withValues(alpha: 0.7)),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: content),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool outlined;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    if (outlined) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(7),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: context.primaryColor.withValues(alpha: 0.6)),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: context.primaryColor),
              const SizedBox(width: 5),
              Text(label,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: context.primaryColor)),
            ],
          ),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(7),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1877F2), Color(0xFF42A5F5)],
          ),
          borderRadius: BorderRadius.circular(7),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1877F2).withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.white),
            const SizedBox(width: 5),
            Text(label,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

// ── Weekday header ────────────────────────────────────────────────────────────

class _WeekdayHeader extends StatelessWidget {
  final bool isDark;
  const _WeekdayHeader({required this.isDark});

  @override
  Widget build(BuildContext context) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Container(
      height: 34,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.03)
            : const Color(0xFFF8F9FA),
        border: Border(
          bottom: BorderSide(
              color: context.borderColor.withValues(alpha: 0.4)),
        ),
      ),
      child: Row(
        children: days.asMap().entries.map((e) {
          return Expanded(
            child: Center(
              child: Text(
                e.value,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: context.textSecondary.withValues(alpha: 0.8),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Day cell ──────────────────────────────────────────────────────────────────

class _DayCell extends StatelessWidget {
  final DateTime? date;
  final int col;
  final bool isLastCol;
  final bool isLastRow;
  final List<_Event> events;
  final ChamcongModel? attendance;
  final Color? statusColor;
  final bool isToday;
  final bool isDark;
  final VoidCallback? onTap;
  final Color Function(ChamcongModel) getStatusColor;

  const _DayCell({
    required this.date,
    required this.col,
    required this.isLastCol,
    required this.isLastRow,
    required this.events,
    required this.attendance,
    required this.statusColor,
    required this.isToday,
    required this.isDark,
    required this.onTap,
    required this.getStatusColor,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = context.borderColor.withValues(alpha: 0.3);

    const cellBg = Colors.transparent;

    if (date == null) {
      return Container(
        decoration: BoxDecoration(
          color: cellBg,
          border: Border(
            bottom: isLastRow ? BorderSide.none : BorderSide(color: borderColor),
            right: isLastCol ? BorderSide.none : BorderSide(color: borderColor),
          ),
        ),
      );
    }

    final now = DateTime.now();
    final isFuture =
        date!.isAfter(DateTime(now.year, now.month, now.day));
    final hasData = attendance != null && attendance!.id.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: cellBg,
        border: Border(
          bottom: isLastRow ? BorderSide.none : BorderSide(color: borderColor),
          right: isLastCol ? BorderSide.none : BorderSide(color: borderColor),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          hoverColor: context.primaryColor.withValues(alpha: isDark ? 0.07 : 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Day number row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Status dot
                  Padding(
                    padding: const EdgeInsets.only(left: 5, top: 5),
                    child: hasData && !isFuture
                        ? Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: getStatusColor(attendance!),
                              shape: BoxShape.circle,
                            ),
                          )
                        : const SizedBox(width: 6, height: 6),
                  ),
                  // Day number
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 5, 6, 2),
                    child: Container(
                      width: 22,
                      height: 22,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isToday ? context.primaryColor : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${date!.day}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isToday ? FontWeight.w800 : FontWeight.w600,
                          color: isToday
                              ? Colors.white
                              : isFuture
                                  ? context.textSecondary.withValues(alpha: 0.3)
                                  : context.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Event chips
              ...events.take(5).map((e) => _EventChip(event: e, isFuture: isFuture)),
              if (events.length > 5)
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 1, 4, 0),
                  child: Text(
                    '+${events.length - 5}',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: context.textSecondary.withValues(alpha: 0.65),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Event chip ────────────────────────────────────────────────────────────────

class _EventChip extends StatelessWidget {
  final _Event event;
  final bool isFuture;

  const _EventChip({required this.event, required this.isFuture});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(3, 1, 3, 0),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: isFuture
            ? event.color.withValues(alpha: 0.35)
            : event.color,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            event.time,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(width: 3),
          Flexible(
            child: Text(
              event.label,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.clip,
            ),
          ),
        ],
      ),
    );
  }
}
