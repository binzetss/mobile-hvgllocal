import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.1),
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
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.history_rounded,
                  color: AppColors.primary,
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
                        color: AppColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(selectedDate),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (attendance == null || attendance!.id.isEmpty)
            _buildEmptyState()
          else
            _buildAttendanceDetails(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final isFuture = selectedDate.isAfter(DateTime.now());
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              isFuture ? Icons.event_busy_rounded : Icons.info_outline_rounded,
              size: 48,
              color: AppColors.textSecondary.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 12),
            Text(
              isFuture ? 'Ngày chưa đến' : 'Không có dữ liệu',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary.withValues(alpha: 0.6),
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
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceDetails() {
    return Column(
      children: [
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
        const SizedBox(height: 20),

        if (attendance!.hasAllChecks ||
            attendance!.checkInMorning != null ||
            attendance!.checkOutMorning != null ||
            attendance!.checkInAfternoon != null ||
            attendance!.checkOutAfternoon != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.2),
                width: 0.5,
              ),
            ),
            child: Column(
              children: [
                if (attendance!.checkInMorning != null)
                  _buildTimeRow(
                    icon: Icons.wb_sunny_outlined,
                    label: 'Sáng - Vào',
                    time: _formatTime(attendance!.checkInMorning!),
                    color: const Color(0xFFFFA726),
                  ),
                if (attendance!.checkInMorning != null &&
                    attendance!.checkOutMorning != null)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1),
                  ),
                if (attendance!.checkOutMorning != null)
                  _buildTimeRow(
                    icon: Icons.wb_sunny_rounded,
                    label: 'Sáng - Ra',
                    time: _formatTime(attendance!.checkOutMorning!),
                    color: const Color(0xFFFF7043),
                  ),
                if (attendance!.checkOutMorning != null &&
                    attendance!.checkInAfternoon != null)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1),
                  ),
                if (attendance!.checkInAfternoon != null)
                  _buildTimeRow(
                    icon: Icons.brightness_3_outlined,
                    label: 'Chiều - Vào',
                    time: _formatTime(attendance!.checkInAfternoon!),
                    color: const Color(0xFF42A5F5),
                  ),
                if (attendance!.checkInAfternoon != null &&
                    attendance!.checkOutAfternoon != null)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1),
                  ),
                if (attendance!.checkOutAfternoon != null)
                  _buildTimeRow(
                    icon: Icons.brightness_3_rounded,
                    label: 'Chiều - Ra',
                    time: _formatTime(attendance!.checkOutAfternoon!),
                    color: const Color(0xFF1E88E5),
                  ),
              ],
            ),
          ),

        if (attendance!.location != null) ...[
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.location_on_rounded,
            label: 'Địa điểm',
            value: attendance!.location!,
          ),
        ],

        if (attendance!.notes != null && attendance!.notes!.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.note_rounded,
            label: 'Ghi chú',
            value: attendance!.notes!,
          ),
        ],
      ],
    );
  }

  Widget _buildTimeRow({
    required IconData icon,
    required String label,
    required String time,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Text(
          time,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.primary,
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
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
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
