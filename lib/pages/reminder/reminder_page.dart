import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../core/navigation/navigator_key.dart';
import '../../data/models/reminder_model.dart';
import '../../providers/reminder_provider.dart';
import '../../widgets/common/common_app_bar.dart';
class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      reminderPageOpen.value = true;
      if (mounted) context.read<ReminderProvider>().load();
    });
  }

  @override
  void dispose() {
    reminderPageOpen.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: CommonAppBar(
        title: 'Nhắc nhở',
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, color: Colors.white),
            onPressed: () => _openSheet(context),
            tooltip: 'Thêm nhắc nhở',
          ),
        ],
      ),
      body: Consumer<ReminderProvider>(
        builder: (context, provider, _) {
          if (!provider.isLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.reminders.isEmpty) {
            return _buildEmpty();
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: provider.reminders.length,
            separatorBuilder: (ctx, i) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final r = provider.reminders[index];
              return _ReminderCard(
                reminder: r,
                onToggle: () => provider.toggle(r.id),
                onEdit: () => _openSheet(context, existing: r),
                onDelete: () => _confirmDelete(context, r),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openSheet(context),
        backgroundColor: context.primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_alarm_rounded),
        label: const Text('Thêm nhắc nhở'),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.alarm_off_rounded,
              size: 72, color: context.textSecondary.withValues(alpha: 0.4)),
          const SizedBox(height: 16),
          Text('Chưa có nhắc nhở nào',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: context.textSecondary)),
          const SizedBox(height: 8),
          Text('Nhấn + để thêm nhắc nhở mới',
              style:
                  TextStyle(fontSize: 14, color: context.textSecondary.withValues(alpha: 0.7))),
        ],
      ),
    );
  }

  void _openSheet(BuildContext context, {ReminderModel? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ReminderSheet(existing: existing),
    );
  }

  void _confirmDelete(BuildContext context, ReminderModel r) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.cardColor,
        title: Text('Xoá nhắc nhở', style: TextStyle(color: context.textPrimary)),
        content: Text('Xoá "${r.title}"?',
            style: TextStyle(color: context.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Huỷ', style: TextStyle(color: context.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ReminderProvider>().remove(r.id);
            },
            child: const Text('Xoá', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// ─── Card ─────────────────────────────────────────────────────────────────────

class _ReminderCard extends StatelessWidget {
  final ReminderModel reminder;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ReminderCard({
    required this.reminder,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Dismissible(
      key: ValueKey(reminder.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white, size: 26),
      ),
      child: GestureDetector(
        onTap: onEdit,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: reminder.isEnabled
                  ? context.primaryColor.withValues(alpha: 0.3)
                  : context.borderColor,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Bell icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: reminder.isEnabled
                      ? context.primaryColor.withValues(alpha: 0.12)
                      : context.surfaceColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.bell,
                    size: 20,
                    color: reminder.isEnabled
                        ? context.primaryColor
                        : context.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Title + time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: reminder.isEnabled
                            ? context.textPrimary
                            : context.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          reminder.timeLabel,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: reminder.isEnabled
                                ? context.primaryColor
                                : context.textSecondary,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: context.surfaceColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            reminder.repeatLabel,
                            style: TextStyle(
                                fontSize: 11,
                                color: context.textSecondary,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    if (reminder.note?.isNotEmpty == true) ...[
                      const SizedBox(height: 3),
                      Text(
                        reminder.note!,
                        style: TextStyle(
                            fontSize: 12,
                            color: context.textSecondary.withValues(alpha: 0.8)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              // Toggle switch
              Switch(
                value: reminder.isEnabled,
                onChanged: (_) => onToggle(),
                activeThumbColor: context.primaryColor,
                activeTrackColor: context.primaryColor.withValues(alpha: 0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Add / Edit Bottom Sheet ──────────────────────────────────────────────────

class _ReminderSheet extends StatefulWidget {
  final ReminderModel? existing;
  const _ReminderSheet({this.existing});

  @override
  State<_ReminderSheet> createState() => _ReminderSheetState();
}

class _ReminderSheetState extends State<_ReminderSheet> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _noteCtrl;
  late TimeOfDay _time;
  late List<int> _selectedDays; // empty = daily

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _titleCtrl = TextEditingController(text: e?.title ?? '');
    _noteCtrl = TextEditingController(text: e?.note ?? '');
    _time = e != null
        ? TimeOfDay(hour: e.hour, minute: e.minute)
        : TimeOfDay.now();
    _selectedDays = e != null ? List<int>.from(e.repeatDays) : [];
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    var picked = _time;
    final isDark = context.isDark;
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: 300,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle + Done
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text('Huỷ',
                        style: TextStyle(
                            color: isDark ? Colors.white54 : Colors.black45,
                            fontSize: 16)),
                  ),
                  Text('Chọn giờ',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87)),
                  TextButton(
                    onPressed: () {
                      setState(() => _time = picked);
                      Navigator.pop(ctx);
                    },
                    child: Text('Xong',
                        style: TextStyle(
                            color: context.primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Cupertino drum picker
            Expanded(
              child: CupertinoTheme(
                data: CupertinoThemeData(
                  brightness: isDark ? Brightness.dark : Brightness.light,
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: true,
                  initialDateTime: DateTime(2000, 1, 1, _time.hour, _time.minute),
                  onDateTimeChanged: (dt) =>
                      picked = TimeOfDay(hour: dt.hour, minute: dt.minute),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleDay(int day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  void _save() {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tiêu đề nhắc nhở')),
      );
      return;
    }
    final provider = context.read<ReminderProvider>();
    if (_isEdit) {
      final updated = widget.existing!.copyWith(
        title: title,
        note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
        hour: _time.hour,
        minute: _time.minute,
        repeatDays: _selectedDays,
      );
      provider.update(updated);
    } else {
      final reminder = ReminderModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        notifBaseId: ReminderProvider.generateNotifBaseId(),
        title: title,
        note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
        hour: _time.hour,
        minute: _time.minute,
        repeatDays: _selectedDays,
        isEnabled: true,
      );
      provider.add(reminder);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 24 + bottomPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            _isEdit ? 'Chỉnh sửa nhắc nhở' : 'Thêm nhắc nhở',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: context.textPrimary),
          ),
          const SizedBox(height: 20),

          // Title input
          _label('Tiêu đề'),
          const SizedBox(height: 6),
          TextField(
            controller: _titleCtrl,
            textCapitalization: TextCapitalization.sentences,
            style: TextStyle(color: context.textPrimary),
            decoration: _inputDecoration(context, 'Ví dụ: Uống thuốc, Họp nhóm...'),
          ),
          const SizedBox(height: 16),

          // Time picker
          _label('Giờ nhắc'),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: _pickTime,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF7F8FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.borderColor),
              ),
              child: Row(
                children: [
                  Icon(Icons.access_time_rounded,
                      color: context.primaryColor, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: context.primaryColor,
                      letterSpacing: 2,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.chevron_right_rounded, color: context.textSecondary),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Repeat days
          _label('Lặp lại'),
          const SizedBox(height: 8),
          _buildDayChips(context),
          const SizedBox(height: 16),

          // Note input
          _label('Ghi chú (tuỳ chọn)'),
          const SizedBox(height: 6),
          TextField(
            controller: _noteCtrl,
            maxLines: 2,
            style: TextStyle(color: context.textPrimary),
            decoration: _inputDecoration(context, 'Thêm ghi chú...'),
          ),
          const SizedBox(height: 24),

          // Save button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: Text(
                _isEdit ? 'Lưu thay đổi' : 'Thêm nhắc nhở',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayChips(BuildContext context) {
    const dayLabels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    return Row(
      children: [
        // "Hàng ngày" chip
        _DayChip(
          label: 'Mỗi ngày',
          selected: _selectedDays.isEmpty,
          onTap: () => setState(() => _selectedDays.clear()),
        ),
        const SizedBox(width: 6),
        // Individual days
        ...List.generate(7, (i) {
          final day = i + 1;
          return Padding(
            padding: const EdgeInsets.only(right: 4),
            child: _DayChip(
              label: dayLabels[i],
              selected: _selectedDays.contains(day),
              onTap: () => _toggleDay(day),
            ),
          );
        }),
      ],
    );
  }

  Widget _label(String text) => Text(
        text,
        style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: context.textSecondary),
      );

  InputDecoration _inputDecoration(BuildContext context, String hint) {
    final isDark = context.isDark;
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
          color: context.textSecondary.withValues(alpha: 0.5), fontSize: 14),
      filled: true,
      fillColor: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF7F8FA),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: context.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: context.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: context.primaryColor, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }
}

class _DayChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DayChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(
          horizontal: label == 'Mỗi ngày' ? 10 : 7,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: selected
              ? context.primaryColor
              : context.surfaceColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? context.primaryColor : context.borderColor,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : context.textSecondary,
          ),
        ),
      ),
    );
  }
}
