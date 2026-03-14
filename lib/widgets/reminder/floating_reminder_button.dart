import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/navigation/navigator_key.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/reminder_model.dart';
import '../../providers/reminder_provider.dart';
import '../../providers/xacthuc_provider.dart';

class FloatingReminderButton extends StatefulWidget {
  const FloatingReminderButton({super.key});

  @override
  State<FloatingReminderButton> createState() => _FloatingReminderButtonState();
}

class _FloatingReminderButtonState extends State<FloatingReminderButton>
    with SingleTickerProviderStateMixin {
  static const _btnSize = 50.0;
  static const _edge = 12.0;
  static const _popupW = 280.0;


  static const _prefX = 'hvgl_fab_x';
  static const _prefY = 'hvgl_fab_y';

  Offset? _position;
  bool _isOpen = false;
  bool _isDragging = false;
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;
  Timer? _idleTimer;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      value: 1.0,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeInOut);
    _loadPosition();
    _scheduleIdleFade();
    reminderPageOpen.addListener(_onReminderPageChanged);
  }

  void _onReminderPageChanged() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    reminderPageOpen.removeListener(_onReminderPageChanged);
    _idleTimer?.cancel();
    _fadeCtrl.dispose();
    super.dispose();
  }
  void _wakeUp() {
    _idleTimer?.cancel();
    _fadeCtrl.animateTo(1.0, duration: const Duration(milliseconds: 200));
  }

  void _scheduleIdleFade() {
    _idleTimer?.cancel();
    if (_isOpen) return;
    _idleTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && !_isOpen && !_isDragging) {
        _fadeCtrl.animateTo(0.3, duration: const Duration(milliseconds: 800));
      }
    });
  }
  Future<void> _loadPosition() async {
    final prefs = await SharedPreferences.getInstance();
    final x = prefs.getDouble(_prefX);
    final y = prefs.getDouble(_prefY);
    if (x != null && y != null && mounted) {
      setState(() => _position = Offset(x, y));
    }
  }

  Future<void> _savePosition() async {
    if (_position == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_prefX, _position!.dx);
    await prefs.setDouble(_prefY, _position!.dy);
  }
  Offset _defaultPos(Size s, EdgeInsets p) =>
      Offset(s.width - _btnSize - _edge, s.height * 0.55 - p.bottom);

  Offset _clamp(Offset pos, Size s, EdgeInsets p) => Offset(
        pos.dx.clamp(_edge, s.width - _btnSize - _edge),
        pos.dy.clamp(p.top + _edge + 56, s.height - _btnSize - _edge - p.bottom - 72),
      );

  void _snapToEdge(Size s, EdgeInsets p) {
    if (_position == null) return;
    final cx = _position!.dx + _btnSize / 2;
    final tx = cx < s.width / 2 ? _edge : s.width - _btnSize - _edge;
    setState(() {
      _position = _clamp(Offset(tx, _position!.dy), s, p);
      _isDragging = false;
    });
    _savePosition();
    _scheduleIdleFade();
  }

  bool get _onRight {
    final s = MediaQuery.of(context).size;
    return (_position?.dx ?? s.width) + _btnSize / 2 > s.width / 2;
  }

  double _popupLeft(Size s) {
    final left = _onRight
        ? _position!.dx - _popupW - 8
        : _position!.dx + _btnSize + 8;
    return left.clamp(8.0, s.width - _popupW - 8);
  }

  double _popupTop(Size s, EdgeInsets p) {
    const maxH = 360.0;
    final ideal = _position!.dy + _btnSize / 2 - maxH / 2;
    return ideal.clamp(p.top + 56.0, s.height - maxH - p.bottom - 16);
  }
  void _open() {
    _wakeUp();
    _idleTimer?.cancel();
    context.read<ReminderProvider>().load();
    setState(() => _isOpen = true);
  }

  void _close() {
    setState(() => _isOpen = false);
    _scheduleIdleFade();
  }

  void _goFullPage() {
    _close();
    appNavigatorKey.currentState?.pushNamed(AppRoutes.reminder);
  }
  @override
  Widget build(BuildContext context) {
    if (!context.watch<XacthucProvider>().isAuthenticated) {
      return const SizedBox.shrink();
    }
    if (reminderPageOpen.value) return const SizedBox.shrink();
    return _buildOverlay(context);
  }

  Widget _buildOverlay(BuildContext context) {
    final mq = MediaQuery.of(context);
    final s = mq.size;
    final p = mq.padding;
    _position ??= _defaultPos(s, p);

    final activeCount = context
        .watch<ReminderProvider>()
        .reminders
        .where((r) => r.isEnabled)
        .length;

    return Stack(
      children: [
        if (_isOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: _close,
              behavior: HitTestBehavior.translucent,
            ),
          ),
        if (_isOpen)
          Positioned(
            left: _popupLeft(s),
            top: _popupTop(s, p),
            width: _popupW,
            child: _Popup(onExpand: _goFullPage, onClose: _close),
          ),
        Positioned(
          left: _position!.dx,
          top: _position!.dy,
          child: GestureDetector(
            onPanStart: (_) {
              _wakeUp();
              _close();
              setState(() => _isDragging = true);
            },
            onPanUpdate: (d) => setState(() {
              _position = _clamp(_position! + d.delta, s, p);
            }),
            onPanEnd: (_) => _snapToEdge(s, p),
            onTap: () {
              _wakeUp();
              _isOpen ? _close() : _open();
            },
            child: FadeTransition(
              opacity: _fadeAnim,
              child: _Fab(
                isOpen: _isOpen,
                isDragging: _isDragging,
                badge: activeCount,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
class _Fab extends StatelessWidget {
  final bool isOpen;
  final bool isDragging;
  final int badge;

  const _Fab({required this.isOpen, required this.isDragging, required this.badge});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedScale(
      scale: isDragging ? 1.12 : (isOpen ? 0.9 : 1.0),
      duration: const Duration(milliseconds: 150),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF4599FF), const Color(0xFF1877F2)]
                    : [const Color(0xFF1877F2), const Color(0xFF0D5BC7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isOpen ? Icons.close_rounded : Icons.alarm_rounded,
                key: ValueKey(isOpen),
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          if (badge > 0 && !isOpen)
            Positioned(
              right: -3,
              top: -3,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    badge > 9 ? '9+' : '$badge',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
class _Popup extends StatelessWidget {
  final VoidCallback onExpand;
  final VoidCallback onClose;

  const _Popup({required this.onExpand, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final reminders = context.watch<ReminderProvider>().reminders;

    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 360),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.22),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _header(context),
              Flexible(
                child: reminders.isEmpty
                    ? _empty(isDark)
                    : _list(context, reminders, isDark),
              ),
              _footer(context, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF4599FF), const Color(0xFF1877F2)]
              : [const Color(0xFF1877F2), const Color(0xFF0D5BC7)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.alarm_rounded, color: Colors.white, size: 17),
          const SizedBox(width: 8),
          const Expanded(
            child: Text('Nhắc nhở',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
          ),
          _iconBtn(Icons.open_in_full_rounded, onExpand),
          const SizedBox(width: 6),
          _iconBtn(Icons.close_rounded, onClose),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(icon, color: Colors.white, size: 14),
        ),
      );

  Widget _empty(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.alarm_off_rounded,
              size: 38, color: Colors.grey.withValues(alpha: 0.35)),
          const SizedBox(height: 8),
          Text('Chưa có nhắc nhở nào',
              style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white54 : Colors.black38)),
        ],
      ),
    );
  }

  Widget _list(BuildContext ctx, List<ReminderModel> reminders, bool isDark) {
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 4),
      physics: const BouncingScrollPhysics(),
      itemCount: reminders.length,
      separatorBuilder: (_, i) => Divider(
        height: 1,
        thickness: 0.5,
        color: isDark ? Colors.white12 : Colors.black12,
        indent: 14,
        endIndent: 14,
      ),
      itemBuilder: (_, i) =>
          _ReminderItem(reminder: reminders[i], isDark: isDark),
    );
  }

  Widget _footer(BuildContext context, bool isDark) {
    final primary = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onExpand,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF0F2F5),
          border: Border(
            top: BorderSide(
                color: isDark ? Colors.white12 : Colors.black12, width: 0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_alarm_rounded, size: 16, color: primary),
            const SizedBox(width: 6),
            Text('Thêm / Quản lý nhắc nhở',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primary)),
          ],
        ),
      ),
    );
  }
}
class _ReminderItem extends StatelessWidget {
  final ReminderModel reminder;
  final bool isDark;

  const _ReminderItem({required this.reminder, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reminder.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${reminder.timeLabel}  ·  ${reminder.repeatLabel}',
                  style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.white38 : Colors.black38),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.78,
            child: Switch(
              value: reminder.isEnabled,
              onChanged: (_) =>
                  context.read<ReminderProvider>().toggle(reminder.id),
              activeThumbColor: Colors.white,
              activeTrackColor: Theme.of(context).colorScheme.primary,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey.withValues(alpha: 0.35),
            ),
          ),
        ],
      ),
    );
  }
}
