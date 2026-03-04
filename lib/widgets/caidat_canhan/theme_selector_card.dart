import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

class ThemeSelectorCard extends StatelessWidget {
  const ThemeSelectorCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF38383A) : const Color(0xFFE8EAF0);
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final subTextColor =
        isDark ? const Color(0xFF8E8E93) : const Color(0xFF757575);

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text(
              'Giao diện',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: subTextColor,
                letterSpacing: 0.3,
              ),
            ),
          ),
          _ThemeOption(
            icon: FontAwesomeIcons.sun,
            label: 'Sáng',
            description: 'Nền trắng, chữ đen',
            mode: ThemeMode.light,
            iconColor: const Color(0xFFF59E0B),

            iconBgLight: const Color(0xFFFFF8E1),
            iconBgDark: const Color(0xFF3A2E00),
            textColor: textColor,
            subTextColor: subTextColor,
            borderColor: borderColor,
          ),
          Divider(height: 1, indent: 60, color: borderColor),
          _ThemeOption(
            icon: FontAwesomeIcons.moon,
            label: 'Tối',
            description: 'Nền đen, chữ trắng',
            mode: ThemeMode.dark,
            iconColor: isDark ? const Color(0xFF818CF8) : const Color(0xFF6366F1),
            iconBgLight: const Color(0xFFEDE9FE),
            iconBgDark: const Color(0xFF1E1B40),
            textColor: textColor,
            subTextColor: subTextColor,
            borderColor: borderColor,
          ),
          Divider(height: 1, indent: 60, color: borderColor),
          _ThemeOption(
            icon: FontAwesomeIcons.circleHalfStroke,
            label: 'Theo hệ thống',
            description: 'Tự động theo thiết bị',
            mode: ThemeMode.system,
            iconColor: isDark ? const Color(0xFF34D399) : const Color(0xFF10B981),
            iconBgLight: const Color(0xFFD1FAE5),
            iconBgDark: const Color(0xFF0A2A1F),
            textColor: textColor,
            subTextColor: subTextColor,
            borderColor: borderColor,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final ThemeMode mode;
  final Color iconColor;
  final Color iconBgLight;
  final Color iconBgDark;
  final Color textColor;
  final Color subTextColor;
  final Color borderColor;
  final bool isLast;

  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.description,
    required this.mode,
    required this.iconColor,
    required this.iconBgLight,
    required this.iconBgDark,
    required this.textColor,
    required this.subTextColor,
    required this.borderColor,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ThemeProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = provider.themeMode == mode;
    final iconBg = isDark ? iconBgDark : iconBgLight;

    return InkWell(
      onTap: () => provider.setTheme(mode),
      borderRadius: isLast
          ? const BorderRadius.vertical(bottom: Radius.circular(16))
          : BorderRadius.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: FaIcon(icon, size: 16, color: iconColor),
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
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(fontSize: 12, color: subTextColor),
                  ),
                ],
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isSelected
                  ? Icon(
                      Icons.check_circle_rounded,
                      color: isDark
                          ? const Color(0xFF007AFF)
                          : const Color(0xFF1E88E5),
                      size: 22,
                      key: const ValueKey(true),
                    )
                  : Icon(
                      Icons.circle_outlined,
                      color: subTextColor,
                      size: 22,
                      key: const ValueKey(false),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
