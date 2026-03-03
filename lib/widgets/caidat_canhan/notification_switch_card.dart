import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../providers/notification_settings_provider.dart';

class NotificationSwitchCard extends StatelessWidget {
  const NotificationSwitchCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF38383A) : const Color(0xFFE8EAF0);
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final subTextColor =
        isDark ? const Color(0xFF8E8E93) : const Color(0xFF757575);

    return Consumer<NotificationSettingsProvider>(
      builder: (context, settings, _) {
        return Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildRow(
                isDark: isDark,
                icon: FontAwesomeIcons.bell,
                iconColor: isDark
                    ? const Color(0xFF4599FF)
                    : const Color(0xFF1877F2),
                iconBg: isDark
                    ? const Color(0xFF0A2040)
                    : const Color(0xFFE7F3FF),
                label: 'Thông báo',
                description: 'Bật/tắt toàn bộ thông báo',
                value: settings.allEnabled,
                onChanged: settings.setAll,
                textColor: textColor,
                subTextColor: subTextColor,
                borderColor: borderColor,
              ),
              Divider(height: 1, indent: 60, color: borderColor),
              _buildRow(
                isDark: isDark,
                icon: FontAwesomeIcons.utensils,
                iconColor: isDark
                    ? const Color(0xFF34D399)
                    : const Color(0xFF10B981),
                iconBg: isDark
                    ? const Color(0xFF0A2A1F)
                    : const Color(0xFFD1FAE5),
                label: 'Chấm cơm',
                description: 'Thông báo đăng ký bữa ăn',
                value: settings.chamComEnabled,
                onChanged: settings.allEnabled ? settings.setChamCom : null,
                textColor: textColor,
                subTextColor: subTextColor,
                borderColor: borderColor,
                disabled: !settings.allEnabled,
              ),
              Divider(height: 1, indent: 60, color: borderColor),
              _buildRow(
                isDark: isDark,
                icon: FontAwesomeIcons.fingerprint,
                iconColor: isDark
                    ? const Color(0xFFF59E0B)
                    : const Color(0xFFD97706),
                iconBg: isDark
                    ? const Color(0xFF3A2E00)
                    : const Color(0xFFFFF8E1),
                label: 'Chấm công',
                description: 'Nhắc nhở chấm công hàng ngày',
                value: settings.chamCongEnabled,
                onChanged: settings.allEnabled ? settings.setChamCong : null,
                textColor: textColor,
                subTextColor: subTextColor,
                borderColor: borderColor,
                disabled: !settings.allEnabled,
              ),
              Divider(height: 1, indent: 60, color: borderColor),
              _buildRow(
                isDark: isDark,
                icon: FontAwesomeIcons.fileLines,
                iconColor: isDark
                    ? const Color(0xFFC084FC)
                    : const Color(0xFF9333EA),
                iconBg: isDark
                    ? const Color(0xFF2D1B4E)
                    : const Color(0xFFF5F3FF),
                label: 'Văn bản',
                description: 'Thông báo văn bản mới',
                value: settings.vanBanEnabled,
                onChanged: settings.allEnabled ? settings.setVanBan : null,
                textColor: textColor,
                subTextColor: subTextColor,
                borderColor: borderColor,
                disabled: !settings.allEnabled,
              ),
              Divider(height: 1, indent: 60, color: borderColor),
              _buildRow(
                isDark: isDark,
                icon: FontAwesomeIcons.solidHospital,
                iconColor: isDark
                    ? const Color(0xFFF87171)
                    : const Color(0xFFEF4444),
                iconBg: isDark
                    ? const Color(0xFF3A0A0A)
                    : const Color(0xFFFFF1F2),
                label: 'Lịch trực',
                description: 'Nhắc nhở lịch trực theo ca',
                value: settings.lichTrucEnabled,
                onChanged: settings.allEnabled ? settings.setLichTruc : null,
                textColor: textColor,
                subTextColor: subTextColor,
                borderColor: borderColor,
                isLast: true,
                disabled: !settings.allEnabled,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRow({
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    required String description,
    required bool value,
    required Function(bool)? onChanged,
    required Color textColor,
    required Color subTextColor,
    required Color borderColor,
    bool isLast = false,
    bool disabled = false,
  }) {
    final effectiveTextColor =
        disabled ? subTextColor.withValues(alpha: 0.5) : textColor;
    final effectiveSubColor =
        disabled ? subTextColor.withValues(alpha: 0.4) : subTextColor;
    final effectiveIconBg = disabled
        ? (isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7))
        : iconBg;
    final effectiveIconColor = disabled
        ? (isDark ? const Color(0xFF636366) : const Color(0xFFAEAEB2))
        : iconColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: effectiveIconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: FaIcon(icon, size: 16, color: effectiveIconColor),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: effectiveTextColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: effectiveSubColor),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor:
                isDark ? const Color(0xFF4599FF) : const Color(0xFF1877F2),
          ),
        ],
      ),
    );
  }
}
