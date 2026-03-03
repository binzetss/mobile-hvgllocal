import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../data/models/chamcong_model.dart';

class ChamcongHistoryCard extends StatelessWidget {
  final ChamcongModel? attendance;
  final DateTime selectedDate;

  const ChamcongHistoryCard({
    super.key,
    this.attendance,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.borderColor,
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.history_rounded,
                  color: context.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chi tiết chấm công',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(selectedDate),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: context.textSecondary.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (attendance == null || attendance!.id.isEmpty)
            _buildEmptyState(context)
          else
            _buildAttendanceDetails(context),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isFuture = selectedDate.isAfter(DateTime.now());
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: context.borderColor,
          width: 0.5,
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              isFuture ? Icons.event_busy_rounded : Icons.info_outline_rounded,
              size: 48,
              color: context.textSecondary.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 12),
            Text(
              isFuture ? 'Ngày chưa đến' : 'Không có dữ liệu',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: context.textSecondary.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isFuture
                  ? 'Chưa có thông tin chấm công'
                  : 'Không có dữ liệu chấm công cho ngày này',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: context.textSecondary.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceDetails(BuildContext context) {
    final punches = attendance!.punches;
    final groups = _groupByLoai(punches);

    return Column(
      children: [
        // Status badge
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: _getStatusColor().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _getStatusColor().withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getStatusIcon(),
                  color: _getStatusColor(),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  attendance!.statusText,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _getStatusColor(),
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        ),

        if (punches.isNotEmpty) ...[
          const SizedBox(height: 20),
          // Từng nhóm loại chấm
          ...groups.entries.toList().asMap().entries.map((mapEntry) {
            final idx = mapEntry.key;
            final entry = mapEntry.value;
            return Column(
              children: [
                if (idx > 0) const SizedBox(height: 12),
                _buildGroupSection(context, entry.key, entry.value),
              ],
            );
          }),
        ],

        if (attendance!.location != null) ...[
          const SizedBox(height: 12),
          _buildInfoRow(
            context: context,
            icon: Icons.location_on_rounded,
            label: 'Địa điểm',
            value: attendance!.location!,
          ),
        ],

        if (attendance!.notes != null && attendance!.notes!.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildInfoRow(
            context: context,
            icon: Icons.note_rounded,
            label: 'Ghi chú',
            value: attendance!.notes!,
          ),
        ],
      ],
    );
  }

  /// Gom nhóm punches theo loại, giữ thứ tự xuất hiện đầu tiên
  Map<String, List<ChamcongPunch>> _groupByLoai(List<ChamcongPunch> punches) {
    final map = <String, List<ChamcongPunch>>{};
    for (final p in punches) {
      map.putIfAbsent(p.loaiChamCong, () => []).add(p);
    }
    return map;
  }

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
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
      ),
      child: Column(
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [color, color.withValues(alpha: 0.75)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(child: Icon(icon, size: 16, color: Colors.white)),
                ),
                const SizedBox(width: 10),
                Text(
                  loai,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${items.length} lần',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Divider
          Divider(
            height: 1,
            thickness: 1,
            indent: 14,
            endIndent: 14,
            color: color.withValues(alpha: 0.15),
          ),
          // Danh sách giờ chấm
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
            child: Column(
              children: items.asMap().entries.map((entry) {
                final idx = entry.key;
                final punch = entry.value;
                return Column(
                  children: [
                    if (idx > 0)
                      Divider(
                        height: 18,
                        thickness: 0.5,
                        color: context.borderColor,
                      ),
                    _buildPunchRow(context, punch, color, idx + 1),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPunchRow(
    BuildContext context,
    ChamcongPunch punch,
    Color color,
    int index,
  ) {
    return Row(
      children: [
        // Số thứ tự
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$index',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 13,
                color: context.textSecondary.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 4),
              Text(
                'Lần $index',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: context.textSecondary.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        Text(
          _formatTime(punch.time),
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.borderColor,
          width: 0.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: context.primaryColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: context.textSecondary.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

  Color _getStatusColor() {
    if (attendance == null) return AppColors.textSecondary;

    switch (attendance!.status) {
      case ChamcongStatus.present:
        return Colors.green;
      case ChamcongStatus.late:
        return Colors.orange;
      case ChamcongStatus.absent:
        return Colors.red;
      case ChamcongStatus.earlyLeave:
        return Colors.amber;
      case ChamcongStatus.weekend:
        return AppColors.textSecondary;
      case ChamcongStatus.holiday:
        return Colors.blue;
    }
  }

  IconData _getStatusIcon() {
    if (attendance == null) return Icons.help_outline_rounded;

    switch (attendance!.status) {
      case ChamcongStatus.present:
        return Icons.check_circle_rounded;
      case ChamcongStatus.late:
        return Icons.schedule_rounded;
      case ChamcongStatus.absent:
        return Icons.cancel_rounded;
      case ChamcongStatus.earlyLeave:
        return Icons.exit_to_app_rounded;
      case ChamcongStatus.weekend:
        return Icons.weekend_rounded;
      case ChamcongStatus.holiday:
        return Icons.celebration_rounded;
    }
  }

  String _formatDate(DateTime date) {
    const weekDays = ['Chủ nhật', 'Thứ hai', 'Thứ ba', 'Thứ tư', 'Thứ năm', 'Thứ sáu', 'Thứ bảy'];
    final weekDay = weekDays[date.weekday % 7];
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return '$weekDay, $day/$month/$year';
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
