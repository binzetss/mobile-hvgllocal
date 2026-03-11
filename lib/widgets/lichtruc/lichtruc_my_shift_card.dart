import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../data/models/lichtruc_model.dart';

const _weekDays = ['', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
const _colorToday = Color(0xFF1877F2);
const _colorPast = Color(0xFF34C759);
const _colorUpcoming = Color(0xFFFF9F0A);

Color _statusColor(ChamTrucModel s) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(s.ngay.year, s.ngay.month, s.ngay.day);
  if (day == today) return _colorToday;
  if (day.isBefore(today)) return _colorPast;
  return _colorUpcoming;
}

String _statusLabel(ChamTrucModel s) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(s.ngay.year, s.ngay.month, s.ngay.day);
  if (day == today) return 'Hôm nay';
  if (day.isBefore(today)) return 'Đã trực';
  return 'Sắp tới';
}

class LichtructMyShiftCard extends StatelessWidget {
  final ChamTrucModel s;
  const LichtructMyShiftCard({super.key, required this.s});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final color = _statusColor(s);
    final label = _statusLabel(s);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: color, width: 4)),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Date column
            SizedBox(
              width: 34,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${s.ngay.day}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: color,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _weekDays[s.ngay.weekday],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: color.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            // Divider
            Container(
              width: 1,
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 13),
              color: context.borderColor,
            ),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (s.moTa.isNotEmpty)
                    Text(
                      s.moTa,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: context.textPrimary,
                      ),
                    ),
                  const SizedBox(height: 5),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (s.kyHieu.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            s.kyHieu,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: color,
                            ),
                          ),
                        ),
                      if (s.tenKhoaPhong.isNotEmpty)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FaIcon(FontAwesomeIcons.hospital,
                                size: 10,
                                color: AppColors.textSecondary
                                    .withValues(alpha: 0.55)),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                s.tenKhoaPhong,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary
                                      .withValues(alpha: 0.75),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Status badge
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
