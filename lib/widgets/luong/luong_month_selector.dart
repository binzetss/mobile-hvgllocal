import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/constants/app_colors.dart';

class LuongMonthSelector extends StatelessWidget {
  final String selectedMonth;
  final List<String> availableMonths;
  final Function(String?) onMonthChanged;

  const LuongMonthSelector({
    super.key,
    required this.selectedMonth,
    required this.availableMonths,
    required this.onMonthChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const FaIcon(
              FontAwesomeIcons.calendarCheck,
              color: AppColors.primary,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Tháng:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.5),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedMonth,
                  isExpanded: true,
                  icon: const FaIcon(
                    FontAwesomeIcons.chevronDown,
                    size: 12,
                    color: AppColors.textSecondary,
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  items: availableMonths.map((month) {
                    return DropdownMenuItem(
                      value: month,
                      child: Text(month),
                    );
                  }).toList(),
                  onChanged: onMonthChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
