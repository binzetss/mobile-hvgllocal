import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/extensions/theme_extensions.dart';

class ThongBaoFilterChips extends StatelessWidget {
  final String currentFilter;
  final Function(String) onFilterChanged;
  final int unreadCount;

  const ThongBaoFilterChips({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
    required this.unreadCount,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _buildChip(context, key: 'all', label: 'Tất cả', icon: FontAwesomeIcons.list),
          _buildChip(context,
            key: 'unread',
            label: 'Chưa đọc',
            icon: FontAwesomeIcons.circleExclamation,
            badge: unreadCount > 0 ? unreadCount : null,
          ),
          _buildChip(context, key: 'chamcong', label: 'Chấm công', icon: FontAwesomeIcons.fingerprint),
          _buildChip(context, key: 'luong', label: 'Lương', icon: FontAwesomeIcons.wallet),
          _buildChip(context, key: 'vanban', label: 'Văn bản', icon: FontAwesomeIcons.fileLines),
          _buildChip(context, key: 'hethong', label: 'Hệ thống', icon: FontAwesomeIcons.gear),
          _buildChip(context, key: 'sukien', label: 'Sự kiện', icon: FontAwesomeIcons.calendar),
        ],
      ),
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required String key,
    required String label,
    required IconData icon,
    int? badge,
  }) {
    final isSelected = currentFilter == key;

    return GestureDetector(
      onTap: () => onFilterChanged(key),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? context.primaryColor
              : context.surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? context.primaryColor
                : context.borderColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              icon,
              size: 13,
              color: isSelected ? Colors.white : context.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : context.textSecondary,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.2)
                      : context.primaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badge.toString(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : context.primaryColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
