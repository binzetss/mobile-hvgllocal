import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/chamcong_provider.dart';
import '../../data/models/chamcong_model.dart';

class CheckInItem {
  final String label;
  final DateTime time;
  final bool isCheckIn;

  CheckInItem({
    required this.label,
    required this.time,
    required this.isCheckIn,
  });
}

class ChamcongTodayCard extends StatelessWidget {
  const ChamcongTodayCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChamcongProvider>(
      builder: (context, provider, _) {
        final todayAttendance = provider.todayAttendance;
        final checkIns = _getAllCheckIns(todayAttendance);

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.border.withValues(alpha: 0.12),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.06),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withValues(alpha: 0.05),
                      Colors.white,
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: AppColors.primaryGradient,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.fingerprint,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Chấm công hôm nay',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 13,
                                color: AppColors.textSecondary.withValues(alpha: 0.7),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                DateFormat('dd/MM/yyyy').format(DateTime.now()),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary.withValues(alpha: 0.85),
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: checkIns.isNotEmpty
                            ? AppColors.success.withValues(alpha: 0.12)
                            : AppColors.backgroundSecondary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: checkIns.isNotEmpty
                              ? AppColors.success.withValues(alpha: 0.25)
                              : AppColors.border.withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${checkIns.length}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: checkIns.isNotEmpty
                                  ? AppColors.success
                                  : AppColors.textSecondary,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'lần',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: checkIns.isNotEmpty
                                  ? AppColors.success.withValues(alpha: 0.8)
                                  : AppColors.textSecondary.withValues(alpha: 0.7),
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Divider
              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppColors.border.withValues(alpha: 0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              // Content Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: checkIns.isEmpty
                    ? _buildEmptyState()
                    : Column(
                        children: [
                          ...checkIns.asMap().entries.map((entry) {
                            final index = entry.key;
                            final item = entry.value;
                            return Column(
                              children: [
                                if (index > 0) const SizedBox(height: 10),
                                _buildCheckInRow(item),
                              ],
                            );
                          }),
                          if (todayAttendance?.status != null &&
                              todayAttendance?.status != ChamcongStatus.weekend &&
                              todayAttendance?.status != ChamcongStatus.holiday) ...[
                            const SizedBox(height: 14),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 14,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(todayAttendance!.status)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _getStatusColor(todayAttendance.status)
                                      .withValues(alpha: 0.25),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    _getStatusIcon(todayAttendance.status),
                                    size: 12,
                                    color: _getStatusColor(todayAttendance.status),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    todayAttendance.statusText,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: _getStatusColor(todayAttendance.status),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: FaIcon(
                FontAwesomeIcons.clockRotateLeft,
                size: 22,
                color: AppColors.textSecondary.withValues(alpha: 0.4),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Chưa có dữ liệu chấm công',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Vui lòng thực hiện chấm công',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckInRow(CheckInItem item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: item.isCheckIn
                    ? [
                        AppColors.success,
                        AppColors.success.withValues(alpha: 0.85),
                      ]
                    : [
                        AppColors.primary,
                        AppColors.primary.withValues(alpha: 0.85),
                      ],
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: (item.isCheckIn ? AppColors.success : AppColors.primary)
                      .withValues(alpha: 0.25),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: FaIcon(
                item.isCheckIn
                    ? FontAwesomeIcons.arrowRightToBracket
                    : FontAwesomeIcons.arrowRightFromBracket,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 11,
                      color: AppColors.textSecondary.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Thời gian chấm công',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary.withValues(alpha: 0.65),
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.15),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              DateFormat('HH:mm').format(item.time),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: 0.8,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<CheckInItem> _getAllCheckIns(dynamic attendance) {
    if (attendance == null) return [];

    final List<CheckInItem> checkIns = [];

    if (attendance.checkInMorning != null) {
      checkIns.add(CheckInItem(
        label: 'Vào sáng',
        time: attendance.checkInMorning!,
        isCheckIn: true,
      ));
    }

    if (attendance.checkOutMorning != null) {
      checkIns.add(CheckInItem(
        label: 'Ra sáng',
        time: attendance.checkOutMorning!,
        isCheckIn: false,
      ));
    }

    if (attendance.checkInAfternoon != null) {
      checkIns.add(CheckInItem(
        label: 'Vào chiều',
        time: attendance.checkInAfternoon!,
        isCheckIn: true,
      ));
    }

    if (attendance.checkOutAfternoon != null) {
      checkIns.add(CheckInItem(
        label: 'Ra chiều',
        time: attendance.checkOutAfternoon!,
        isCheckIn: false,
      ));
    }

    return checkIns;
  }

  Color _getStatusColor(ChamcongStatus status) {
    switch (status) {
      case ChamcongStatus.present:
        return AppColors.success;
      case ChamcongStatus.late:
        return const Color(0xFFFF9800);
      case ChamcongStatus.earlyLeave:
        return const Color(0xFFFF9800);
      case ChamcongStatus.absent:
        return AppColors.error;
      case ChamcongStatus.holiday:
        return AppColors.primary;
      case ChamcongStatus.weekend:
        return AppColors.primary;
    }
  }

  IconData _getStatusIcon(ChamcongStatus status) {
    switch (status) {
      case ChamcongStatus.present:
        return FontAwesomeIcons.circleCheck;
      case ChamcongStatus.late:
        return FontAwesomeIcons.clock;
      case ChamcongStatus.earlyLeave:
        return FontAwesomeIcons.clockRotateLeft;
      case ChamcongStatus.absent:
        return FontAwesomeIcons.circleXmark;
      case ChamcongStatus.holiday:
        return FontAwesomeIcons.umbrellaBeach;
      case ChamcongStatus.weekend:
        return FontAwesomeIcons.calendarDay;
    }
  }
}
