import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/theme_extensions.dart';
import '../../providers/lichtruc_provider.dart';

class LichtructDayNavigator extends StatefulWidget {
  final LichtructProvider provider;
  const LichtructDayNavigator({super.key, required this.provider});

  @override
  State<LichtructDayNavigator> createState() => _LichtructDayNavigatorState();
}

class _LichtructDayNavigatorState extends State<LichtructDayNavigator> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final p = widget.provider;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: context.cardColor,
        border: Border(bottom: BorderSide(color: context.borderColor)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Day navigation row
          Row(
            children: [
              _NavBtn(
                icon: FontAwesomeIcons.chevronLeft,
                onTap: p.previousDay,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: p.isSelectedDateToday ? null : p.goToToday,
                  child: Column(
                    children: [
                      Text(
                        p.getSelectedDateText(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: context.textPrimary,
                        ),
                      ),
                      if (!p.isSelectedDateToday) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Nhấn để về hôm nay',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              _NavBtn(
                icon: FontAwesomeIcons.chevronRight,
                onTap: p.nextDay,
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Search field
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _searchCtrl,
            builder: (context, value, _) {
              return TextField(
                controller: _searchCtrl,
                onChanged: p.setSearchKhoa,
                style: TextStyle(fontSize: 13, color: context.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Tìm theo khoa phòng...',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: context.textSecondary.withValues(alpha: 0.55),
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: FaIcon(
                      FontAwesomeIcons.magnifyingGlass,
                      size: 14,
                      color: context.textSecondary.withValues(alpha: 0.55),
                    ),
                  ),
                  prefixIconConstraints:
                      const BoxConstraints(minWidth: 0, minHeight: 0),
                  suffixIcon: value.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _searchCtrl.clear();
                            p.setSearchKhoa('');
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: FaIcon(
                              FontAwesomeIcons.circleXmark,
                              size: 15,
                              color:
                                  context.textSecondary.withValues(alpha: 0.5),
                            ),
                          ),
                        )
                      : null,
                  suffixIconConstraints:
                      const BoxConstraints(minWidth: 0, minHeight: 0),
                  filled: true,
                  fillColor: isDark
                      ? const Color(0xFF2C2C2E)
                      : const Color(0xFFF0F2F5),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: FaIcon(icon, size: 12, color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}
